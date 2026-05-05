---
name: flutter-architecture
description: |
  Flutter architecture skill — Riverpod + Dio + GoRouter + repository pattern + clean architecture.
  AUTO-TRIGGER khi: chạm file .dart (NOT mobile-design UI), file có `import 'package:riverpod`, `package:dio`, `package:go_router`, hoặc user nói "viết repository/service/state/notifier/route/interceptor/error handler" + "Flutter".
  Force apply 7 luật cứng: (1) immutable models with copyWith/Freezed, (2) Riverpod providers (NOT setState global), (3) Dio interceptor for auth+retry+log, (4) GoRouter type-safe + guards, (5) Result type cho error handling (NOT exceptions cross layers), (6) repository pattern (data sources behind interface), (7) feature-based folder structure.
  Distilled từ Flutter production patterns (lme-ui, lsite-mobile, itg-mobile).
  KHÔNG dùng cho: UI design (use mobile-design), iOS/Android native, React Native.
---

# Flutter Architecture Skill — Production Patterns

> **Triết lý:** Flutter UI dễ, architecture mới khó. Skill này = state management + data flow + error handling + folder structure mà sẽ scale từ 1 màn → 100 màn không vỡ.
> **Source:** distilled từ lme-ui, lsite-mobile, itg-mobile production codebases.

---

## 1. AUTO-TRIGGER

```
DÙNG khi:
  ✓ Chạm file .dart KHÔNG phải UI widget (lib/data/, lib/domain/, lib/presentation/state/)
  ✓ File import: package:flutter_riverpod, package:dio, package:go_router, package:freezed_annotation
  ✓ User nói "viết repository/service/notifier/provider/route/interceptor/use case"
  ✓ User nói "state management/error handling/data layer/auth flow"
  ✓ Project có pubspec.yaml với riverpod/dio/go_router

KHÔNG dùng khi:
  ✗ UI widget styling/layout — dùng mobile-design hoặc lme-flutter
  ✗ iOS/Android native (Swift/Kotlin)
  ✗ React Native
```

---

## 2. BẢY LUẬT CỨNG

### LUẬT 1 — Immutable models với Freezed

```dart
// ❌ SAI — mutable, hard to reason about
class User {
  String name;
  int age;
  User(this.name, this.age);
}

// ✅ ĐÚNG — Freezed
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required int age,
    @Default([]) List<String> roles,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

// Usage
final updated = user.copyWith(name: 'New Name');  // creates new instance
```

**Rules:**
- Mọi data model: Freezed (`@freezed`) HOẶC manual immutable với `copyWith`
- Equality auto (Freezed handles `==` and `hashCode`)
- JSON serialization: `json_serializable` package
- KHÔNG mutate model fields trực tiếp

### LUẬT 2 — State qua Riverpod, KHÔNG setState global

```dart
// ❌ SAI — global state qua singleton
class AuthService {
  static User? currentUser;
}

// ✅ ĐÚNG — Riverpod provider
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      return user;
    });
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}

// Widget consume
final auth = ref.watch(authNotifierProvider);
```

**Rules:**
- Local widget state: `useState` / `StatefulWidget` (OK)
- Cross-widget state: Riverpod provider
- Global state: Riverpod provider (KHÔNG singleton, KHÔNG InheritedWidget tự build)
- Async state: `AsyncValue<T>` (loading/data/error built-in)
- Use `ref.watch` (rebuild on change) vs `ref.read` (one-time read)
- Riverpod 2.0+: code generation với `@riverpod` annotation

### LUẬT 3 — Dio interceptor cho auth + retry + log

```dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ref.read(envProvider).apiUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // Auth interceptor — inject JWT
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await ref.read(secureStorageProvider).getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      // Handle 401 — refresh token
      if (error.response?.statusCode == 401) {
        final refreshed = await ref.read(authNotifierProvider.notifier).refresh();
        if (refreshed) {
          // Retry original request
          final clone = await dio.fetch(error.requestOptions);
          return handler.resolve(clone);
        } else {
          // Force logout
          ref.read(authNotifierProvider.notifier).logout();
        }
      }
      handler.next(error);
    },
  ));

  // Logging interceptor (debug only)
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  // Retry interceptor (network failures)
  dio.interceptors.add(RetryInterceptor(
    dio: dio,
    retries: 3,
    retryDelays: const [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 4)],
  ));

  return dio;
});
```

**Rules:**
- 1 Dio instance, configured qua provider
- Auth interceptor inject JWT, handle 401 refresh
- Log interceptor CHỈ trong `kDebugMode`
- Retry với exponential backoff cho network errors
- Timeout config: connect 10s, receive 30s (adjust theo use case)

### LUẬT 4 — GoRouter type-safe + guards

```dart
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@TypedGoRoute<OrderDetailRoute>(path: '/orders/:orderId')
class OrderDetailRoute extends GoRouteData {
  const OrderDetailRoute({required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      OrderDetailScreen(orderId: orderId);
}

// Auth guard
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = auth.value != null;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';
      return null;  // no redirect
    },
    routes: $appRoutes,  // generated from @TypedGoRoute
  );
});

// Navigate type-safely
const OrderDetailRoute(orderId: '123').go(context);
const OrderDetailRoute(orderId: '123').push(context);
```

**Rules:**
- Type-safe routes via `go_router_builder` codegen (`@TypedGoRoute`)
- KHÔNG `Navigator.pushNamed` với string magic — dùng generated routes
- Auth guard ở `redirect` — observe Riverpod auth state
- Deep link supported automatically với GoRouter

### LUẬT 5 — Result type cho error handling

```dart
// ❌ SAI — exceptions thrown across layers
Future<User> getUser(String id) async {
  final response = await dio.get('/users/$id');
  if (response.statusCode != 200) throw Exception('Failed');  // bubble up
  return User.fromJson(response.data);
}

// ✅ ĐÚNG — Result type
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}

// Repository
Future<Result<User>> getUser(String id) async {
  try {
    final response = await dio.get('/users/$id');
    return Success(User.fromJson(response.data));
  } on DioException catch (e) {
    return Failure(_mapDioError(e));
  } catch (e, st) {
    logger.error('Unexpected', error: e, stackTrace: st);
    return Failure(AppError.unknown());
  }
}

// Use case / notifier
final result = await ref.read(userRepoProvider).getUser('123');
switch (result) {
  case Success(:final data):
    state = AsyncValue.data(data);
  case Failure(:final error):
    state = AsyncValue.error(error, StackTrace.current);
}
```

**Rules:**
- Repository return `Result<T>` HOẶC throw typed exception (`AppError`)
- KHÔNG bubble Dio/DB exceptions up to UI
- AppError sealed class với specific cases (NetworkError, AuthError, ValidationError, ServerError)
- UI layer pattern match → display correct message

### LUẬT 6 — Repository pattern (data sources behind interface)

```dart
// Domain layer (no dependencies)
abstract class OrderRepository {
  Future<Result<List<Order>>> getOrders({int page = 1});
  Future<Result<Order>> getOrder(String id);
  Future<Result<Order>> createOrder(CreateOrderRequest request);
}

// Data layer (implementation)
class OrderRepositoryImpl implements OrderRepository {
  final Dio _dio;
  final OrderLocalDataSource _local;
  final OrderRemoteDataSource _remote;

  OrderRepositoryImpl(this._dio, this._local, this._remote);

  @override
  Future<Result<List<Order>>> getOrders({int page = 1}) async {
    // Try cache first
    final cached = await _local.getOrders();
    if (cached.isNotEmpty) {
      return Success(cached);
    }

    // Fetch remote
    final result = await _remote.getOrders(page: page);
    return result.map((orders) {
      _local.cacheOrders(orders);  // side-effect cache
      return orders;
    });
  }

  // ...
}

// Provider
final orderRepoProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    ref.read(dioProvider),
    ref.read(orderLocalDataSourceProvider),
    ref.read(orderRemoteDataSourceProvider),
  );
});
```

**Rules:**
- Repository = interface in domain layer
- Implementation in data layer
- DataSource: chia local (Hive/SharedPrefs) vs remote (Dio)
- Repository orchestrate: cache strategy, error mapping, transformation
- Notifier/use case CHỈ depend vào repository interface

### LUẬT 7 — Feature-based folder structure

```
lib/
├── main.dart
├── app.dart                          # MaterialApp.router với GoRouter
├── core/
│   ├── env/                          # Env config provider
│   ├── network/                      # Dio provider, interceptors
│   ├── error/                        # AppError sealed class
│   ├── result/                       # Result<T> type
│   ├── theme/                        # ThemeData
│   ├── router/                       # GoRouter config + guards
│   └── storage/                      # SecureStorage, Hive setup
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/         # AuthRemoteDataSource, AuthLocalDataSource
│   │   │   ├── models/              # AuthDto, UserDto (Freezed + JSON)
│   │   │   └── repositories/        # AuthRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/            # User entity (pure Dart)
│   │   │   ├── repositories/        # AuthRepository abstract
│   │   │   └── usecases/            # LoginUseCase, LogoutUseCase
│   │   └── presentation/
│   │       ├── providers/           # AuthNotifier (Riverpod)
│   │       ├── screens/             # LoginScreen, RegisterScreen
│   │       └── widgets/             # LoginForm, AuthButton
│   ├── orders/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── ...
└── shared/
    ├── widgets/                      # Reusable: AppButton, AppTextField
    ├── extensions/                   # Context extensions, Date extensions
    └── constants/                    # AppColors (or use theme), AppDurations
```

**Rules:**
- Feature-based, KHÔNG layer-based (avoid `lib/screens/`, `lib/services/` flat)
- Mỗi feature có data/domain/presentation
- `core/` cho cross-cutting concerns (network, theme, error)
- `shared/` cho widgets/utils dùng cross-feature
- Riverpod providers gần consumer (presentation/providers/) thay vì global

---

## 3. PATTERNS BẮT BUỘC

### Async UI states

```dart
final ordersAsync = ref.watch(ordersNotifierProvider);

return ordersAsync.when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stack) => ErrorView(
    error: error,
    onRetry: () => ref.invalidate(ordersNotifierProvider),
  ),
  data: (orders) {
    if (orders.isEmpty) return const EmptyOrdersView();
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (_, i) => OrderTile(order: orders[i]),
    );
  },
);
```

**Mọi screen consume async data PHẢI handle 4 states:** loading / error / empty / data.

### Form validation

```dart
final emailFieldProvider = StateProvider.autoDispose<String>((_) => '');

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailFieldProvider);
    final isValid = _validateEmail(email);

    return TextFormField(
      onChanged: (v) => ref.read(emailFieldProvider.notifier).state = v,
      validator: (v) => isValid ? null : 'Email không hợp lệ',
      decoration: const InputDecoration(labelText: 'Email'),
    );
  }
}
```

### Pagination với pull-to-refresh + infinite scroll

```dart
@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  int _currentPage = 1;
  bool _hasMore = true;
  final List<Order> _orders = [];

  @override
  Future<List<Order>> build() async {
    return _loadPage(1);
  }

  Future<List<Order>> _loadPage(int page) async {
    final repo = ref.read(orderRepoProvider);
    final result = await repo.getOrders(page: page);
    return switch (result) {
      Success(:final data) => data,
      Failure(:final error) => throw error,
    };
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _currentPage++;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newOrders = await _loadPage(_currentPage);
      _hasMore = newOrders.isNotEmpty;
      _orders.addAll(newOrders);
      return _orders;
    });
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _orders.clear();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadPage(1));
  }
}
```

### Dependency injection hierarchy

```dart
// Bottom layer: pure functions / config
final envProvider = Provider<Env>((ref) => Env.fromEnv());

// Network layer
final dioProvider = Provider<Dio>((ref) { ... });

// Storage layer
final secureStorageProvider = Provider<SecureStorage>((ref) { ... });

// Data sources
final orderRemoteDsProvider = Provider<OrderRemoteDataSource>((ref) {
  return OrderRemoteDataSource(ref.read(dioProvider));
});

// Repositories
final orderRepoProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.read(orderRemoteDsProvider), ...);
});

// State / Notifiers (consume repos)
final ordersNotifierProvider = AsyncNotifierProvider<...>(...);
```

**Hierarchy:** env → network → storage → data sources → repos → notifiers → UI.

---

## 4. ERROR HANDLING

```dart
sealed class AppError {
  const AppError();
  String get userMessage;
}

class NetworkError extends AppError {
  final String detail;
  const NetworkError(this.detail);
  @override
  String get userMessage => 'Lỗi kết nối. Vui lòng thử lại.';
}

class AuthError extends AppError {
  final String reason;
  const AuthError(this.reason);
  @override
  String get userMessage => 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';
}

class ValidationError extends AppError {
  final Map<String, String> fields;  // field name → error message
  const ValidationError(this.fields);
  @override
  String get userMessage => 'Dữ liệu không hợp lệ.';
}

class ServerError extends AppError {
  final int statusCode;
  final String message;
  const ServerError(this.statusCode, this.message);
  @override
  String get userMessage => message.isNotEmpty ? message : 'Lỗi máy chủ. Vui lòng thử lại sau.';
}

class UnknownError extends AppError {
  const UnknownError();
  @override
  String get userMessage => 'Đã có lỗi xảy ra.';
}

// Mapping from Dio
AppError _mapDioError(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionTimeout || DioExceptionType.receiveTimeout
      => const NetworkError('Timeout'),
    DioExceptionType.connectionError
      => const NetworkError('No internet'),
    DioExceptionType.badResponse => switch (e.response?.statusCode) {
        401 => AuthError(e.response?.data['detail'] ?? 'Unauthorized'),
        422 => ValidationError(_parseValidationErrors(e.response?.data)),
        >= 500 => ServerError(
            e.response?.statusCode ?? 500,
            e.response?.data['detail'] ?? '',
          ),
        _ => ServerError(
            e.response?.statusCode ?? 0,
            e.response?.data['detail'] ?? '',
          ),
    },
    _ => const UnknownError(),
  };
}
```

---

## 5. TESTING

```dart
// Unit test notifier với mocked repo
test('login success updates state', () async {
  final mockRepo = MockAuthRepository();
  when(() => mockRepo.login('test@example.com', 'pass'))
      .thenAnswer((_) async => Success(testUser));

  final container = ProviderContainer(overrides: [
    authRepositoryProvider.overrideWithValue(mockRepo),
  ]);

  final notifier = container.read(authNotifierProvider.notifier);
  await notifier.login('test@example.com', 'pass');

  expect(container.read(authNotifierProvider).valueOrNull, testUser);
});

// Widget test
testWidgets('LoginScreen shows error on auth failure', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authNotifierProvider.overrideWith(() =>
          FakeAuthNotifier(initialState: const AsyncValue.error(
            AuthError('Wrong password'), StackTrace.empty,
          ))),
      ],
      child: const MaterialApp(home: LoginScreen()),
    ),
  );

  expect(find.text('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.'), findsOneWidget);
});
```

---

## 6. ANTI-PATTERNS

| ✗ Sai | ✓ Đúng | Lý do |
|------|--------|-------|
| `setState` cho global state | Riverpod provider | Tied to widget lifecycle |
| Multiple Dio instances | 1 Dio qua provider | Hard to add interceptor consistently |
| `Navigator.pushNamed('/route')` | TypedGoRoute generated | Type-safe + refactor-safe |
| Throw exception across layers | Result<T> hoặc AppError typed | UI never sees Dio/DB exceptions |
| Service singleton | Riverpod provider | Testable + scoped |
| Mutable model fields | Freezed + copyWith | Predictable state |
| `print()` debug | logger với level | Filter / disable production |
| HTTP call trong widget | Notifier + repository | Separation of concerns |
| Same widget loading + data + error | when/match 4 states | UI predictable |
| Fetch trong initState | Notifier auto-build | Provider handles lifecycle |
| Hardcoded strings | l10n / app_en.arb | i18n ready |
| Magic numbers | Constants/Theme | Maintainable |
| Material Icons mọi nơi | Custom icon set / LME | Brand consistency |

---

## 7. SELF-CHECK TRƯỚC COMMIT

```
□ flutter analyze pass (no warnings)?
□ Mọi async function return Future<Result<T>> hoặc throw AppError typed?
□ Provider hierarchy đúng (no circular dep)?
□ ref.watch trong build, ref.read trong callback?
□ Dispose properly (autoDispose providers, controller dispose)?
□ Error states handled trong UI (when/match)?
□ Loading state có CircularProgressIndicator hoặc skeleton?
□ Empty state có user guidance?
□ JSON serialization tested (fromJson/toJson roundtrip)?
□ No print() — use logger?
□ No hardcoded strings (use l10n)?
□ No setState cho cross-widget state — use provider?
```

---

## 8. REFERENCE FILES

| File | Khi nào đọc |
|------|-------------|
| `references/riverpod-patterns.md` | Specific Riverpod patterns: family, autoDispose, listen, invalidate |
| `references/dio-recipes.md` | Dio interceptors: auth refresh, retry, cache, multipart upload |

---

## 9. STARTER pubspec.yaml DEPS

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.5.0

  # Network
  dio: ^5.4.0

  # Routing
  go_router: ^13.0.0

  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Models
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0

  # Utils
  logger: ^2.0.0
  intl: ^0.19.0

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  go_router_builder: ^2.4.0
  mocktail: ^1.0.0
  flutter_test:
    sdk: flutter
```

```bash
# Generate code (Freezed + Riverpod + GoRouter)
flutter pub run build_runner build --delete-conflicting-outputs
# Watch mode
flutter pub run build_runner watch --delete-conflicting-outputs
```
