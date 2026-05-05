# Dio Recipes — Production Patterns

> Reusable Dio patterns: interceptors, retry, cache, multipart, refresh token.

---

## 1. Base Dio configuration

```dart
final dioProvider = Provider<Dio>((ref) {
  final env = ref.read(envProvider);

  final dio = Dio(BaseOptions(
    baseUrl: env.apiUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {
      'Accept': 'application/json',
      'X-Client-Version': env.appVersion,
      'X-Platform': Platform.isIOS ? 'ios' : 'android',
    },
    validateStatus: (status) => status != null && status < 500,
    // Don't throw on 4xx — let app handle
  ));

  // Order matters: log → auth → retry
  dio.interceptors.addAll([
    if (kDebugMode) PrettyDioLogger(),
    AuthInterceptor(ref),
    RetryInterceptor(dio: dio),
  ]);

  return dio;
});
```

---

## 2. Auth interceptor with refresh token

```dart
class AuthInterceptor extends Interceptor {
  final Ref ref;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor(this.ref);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth header cho login/refresh endpoints
    if (options.path.contains('/auth/login') || options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final token = await ref.read(secureStorageProvider).getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Avoid refresh loop on refresh endpoint itself
      if (err.requestOptions.path.contains('/auth/refresh')) {
        ref.read(authNotifierProvider.notifier).logout();
        return handler.next(err);
      }

      // Single-flight refresh
      if (_isRefreshing) {
        // Queue the request, wait for refresh to complete
        _pendingRequests.add(err.requestOptions);
        return;
      }

      _isRefreshing = true;
      try {
        final refreshed = await ref.read(authNotifierProvider.notifier).refresh();

        if (refreshed) {
          // Retry original request
          final dio = ref.read(dioProvider);
          final newRequest = err.requestOptions;
          final newToken = await ref.read(secureStorageProvider).getAccessToken();
          newRequest.headers['Authorization'] = 'Bearer $newToken';

          // Retry pending requests
          for (final pending in _pendingRequests) {
            pending.headers['Authorization'] = 'Bearer $newToken';
            dio.fetch(pending);
          }
          _pendingRequests.clear();

          final clone = await dio.fetch(newRequest);
          return handler.resolve(clone);
        } else {
          // Refresh failed → logout
          ref.read(authNotifierProvider.notifier).logout();
        }
      } finally {
        _isRefreshing = false;
      }
    }

    handler.next(err);
  }
}
```

---

## 3. Retry interceptor (network errors only)

```dart
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<Duration> delays;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.delays = const [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 4)],
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = _shouldRetry(err);
    final attempt = (err.requestOptions.extra['retry_attempt'] ?? 0) as int;

    if (!shouldRetry || attempt >= maxRetries) {
      return handler.next(err);
    }

    await Future.delayed(delays[attempt.clamp(0, delays.length - 1)]);

    err.requestOptions.extra['retry_attempt'] = attempt + 1;
    try {
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    // Retry only on network errors and 5xx (NOT 4xx)
    return err.type == DioExceptionType.connectionTimeout ||
           err.type == DioExceptionType.receiveTimeout ||
           err.type == DioExceptionType.connectionError ||
           (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
```

---

## 4. Cache interceptor (GET requests)

```dart
class CacheInterceptor extends Interceptor {
  final Map<String, _CacheEntry> _cache = {};
  final Duration defaultTtl;

  CacheInterceptor({this.defaultTtl = const Duration(minutes: 5)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method != 'GET') return handler.next(options);

    final cacheKey = '${options.uri}';
    final entry = _cache[cacheKey];

    if (entry != null && DateTime.now().isBefore(entry.expiresAt)) {
      // Cache hit — return cached response
      return handler.resolve(Response(
        requestOptions: options,
        data: entry.data,
        statusCode: 200,
        extra: {'cached': true},
      ));
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      final ttl = response.requestOptions.extra['cache_ttl'] as Duration? ?? defaultTtl;
      _cache['${response.requestOptions.uri}'] = _CacheEntry(
        data: response.data,
        expiresAt: DateTime.now().add(ttl),
      );
    }
    handler.next(response);
  }

  void invalidate(String? pathPattern) {
    if (pathPattern == null) {
      _cache.clear();
    } else {
      _cache.removeWhere((k, _) => k.contains(pathPattern));
    }
  }
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiresAt;
  _CacheEntry({required this.data, required this.expiresAt});
}

// Usage with custom TTL per request
dio.get('/users', options: Options(extra: {'cache_ttl': const Duration(hours: 1)}));
```

---

## 5. Multipart file upload

```dart
class FileUploadService {
  final Dio _dio;

  FileUploadService(this._dio);

  Future<Result<String>> uploadImage(File file, {void Function(int sent, int total)? onProgress}) async {
    try {
      final filename = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: filename),
        'metadata': jsonEncode({'uploaded_at': DateTime.now().toIso8601String()}),
      });

      final response = await _dio.post(
        '/upload/image',
        data: formData,
        onSendProgress: onProgress,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
          sendTimeout: const Duration(minutes: 5),  // longer for upload
        ),
      );

      return Success(response.data['url'] as String);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    }
  }
}

// Usage with progress
final result = await ref.read(fileUploadProvider).uploadImage(
  imageFile,
  onProgress: (sent, total) {
    final percent = (sent / total * 100).toStringAsFixed(0);
    ref.read(uploadProgressProvider.notifier).state = '$percent%';
  },
);
```

---

## 6. Download with progress

```dart
Future<Result<File>> downloadFile(String url, String savePath, {
  void Function(int received, int total)? onProgress,
}) async {
  try {
    await _dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
      options: Options(
        receiveTimeout: const Duration(minutes: 10),
        headers: {'Accept': '*/*'},
      ),
    );
    return Success(File(savePath));
  } on DioException catch (e) {
    return Failure(_mapDioError(e));
  }
}
```

---

## 7. Cancel token (abort request)

```dart
class SearchService {
  CancelToken? _searchToken;
  final Dio _dio;

  SearchService(this._dio);

  Future<Result<List<Product>>> search(String query) async {
    // Cancel previous search
    _searchToken?.cancel('New search started');
    _searchToken = CancelToken();

    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {'q': query},
        cancelToken: _searchToken,
      );
      return Success((response.data as List).map((j) => Product.fromJson(j)).toList());
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        return const Failure(AppError.cancelled());
      }
      return Failure(_mapDioError(e));
    }
  }
}
```

---

## 8. Streaming response (SSE / large download)

```dart
Future<void> streamChat(String prompt) async {
  final response = await _dio.post<ResponseBody>(
    '/chat/stream',
    data: {'prompt': prompt},
    options: Options(
      responseType: ResponseType.stream,
      headers: {'Accept': 'text/event-stream'},
    ),
  );

  final stream = response.data!.stream;
  await for (final chunk in stream.transform(utf8.decoder).transform(const LineSplitter())) {
    if (chunk.startsWith('data: ')) {
      final json = chunk.substring(6).trim();
      if (json == '[DONE]') break;
      final delta = jsonDecode(json);
      // Append delta to UI state
      ref.read(chatNotifierProvider.notifier).appendMessage(delta['content']);
    }
  }
}
```

---

## 9. Error mapping (DioException → AppError)

```dart
AppError _mapDioError(DioException e) {
  // Network errors
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return const NetworkError(detail: 'Timeout — vui lòng thử lại');
  }

  if (e.type == DioExceptionType.connectionError) {
    return const NetworkError(detail: 'Không có kết nối mạng');
  }

  if (e.type == DioExceptionType.cancel) {
    return const AppError.cancelled();
  }

  // HTTP errors
  if (e.type == DioExceptionType.badResponse) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    final detail = data is Map ? data['detail'] as String? ?? '' : '';

    return switch (status) {
      400 => ValidationError(_parseValidationErrors(data)),
      401 => AuthError(reason: detail.isNotEmpty ? detail : 'Phiên hết hạn'),
      403 => AuthError(reason: 'Không có quyền truy cập'),
      404 => const NotFoundError(),
      409 => ConflictError(detail: detail.isNotEmpty ? detail : 'Xung đột dữ liệu'),
      422 => ValidationError(_parseValidationErrors(data)),
      >= 500 => ServerError(statusCode: status ?? 500, message: detail),
      _ => UnknownError(detail: detail),
    };
  }

  return const UnknownError();
}

Map<String, String> _parseValidationErrors(dynamic data) {
  if (data is! Map) return {};
  // FastAPI validation error format
  if (data['detail'] is List) {
    final errors = <String, String>{};
    for (final err in data['detail'] as List) {
      if (err is Map && err['loc'] is List && err['loc'].length >= 2) {
        errors[err['loc'][1] as String] = err['msg'] as String;
      }
    }
    return errors;
  }
  return {};
}
```

---

## 10. Idempotency for POST

```dart
import 'package:uuid/uuid.dart';

class OrderRepository {
  final Dio _dio;
  final _uuid = const Uuid();

  Future<Result<Order>> createOrder(CreateOrderRequest req) async {
    final idempotencyKey = _uuid.v4();
    try {
      final response = await _dio.post(
        '/orders',
        data: req.toJson(),
        options: Options(headers: {'Idempotency-Key': idempotencyKey}),
      );
      return Success(Order.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    }
  }
}
```

**Backend handle Idempotency-Key:** check Redis cho key, return cached response nếu đã processed. Tránh duplicate orders khi user double-tap submit button.

---

## TIMEOUT GUIDELINES

| Operation | connect | receive |
|-----------|---------|---------|
| Quick read (GET single resource) | 10s | 15s |
| List with pagination | 10s | 30s |
| Search | 10s | 30s |
| File upload | 30s | 5min |
| File download | 30s | 10min |
| AI chat (streaming) | 10s | 5min |
| Background sync | 30s | 2min |
