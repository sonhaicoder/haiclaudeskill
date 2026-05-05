# Riverpod Patterns Cookbook

> Specific Riverpod 2.0+ patterns. Use code generation (`@riverpod` annotation).

---

## 1. Provider types — when to use what

| Type | When |
|------|------|
| `Provider<T>` | Pure function / immutable singleton. KHÔNG có state. |
| `StateProvider<T>` | Simple mutable state (counter, toggle). ≤ 5 lines logic. |
| `FutureProvider<T>` | One-time async load (config, current user). |
| `StreamProvider<T>` | Reactive stream (websocket, Firestore listener). |
| `NotifierProvider<N, T>` | Sync state với business logic. |
| `AsyncNotifierProvider<N, T>` | Async state với business logic — most common. |

```dart
// Simple Provider
@riverpod
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient(ref.read(dioProvider));
}

// StateProvider (simple counter)
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
  void reset() => state = 0;
}

// AsyncNotifier (most common — server data)
@riverpod
class Orders extends _$Orders {
  @override
  Future<List<Order>> build() async {
    return ref.read(orderRepoProvider).getOrders().then((r) => r.dataOrThrow);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
      ref.read(orderRepoProvider).getOrders().then((r) => r.dataOrThrow));
  }

  Future<void> createOrder(CreateOrderRequest req) async {
    final result = await ref.read(orderRepoProvider).createOrder(req);
    switch (result) {
      case Success(:final data):
        state = AsyncData([data, ...?state.value]);  // optimistic update
      case Failure(:final error):
        // Don't update state — show error toast
        ref.read(toastProvider.notifier).showError(error.userMessage);
    }
  }
}
```

---

## 2. Family — parameterized providers

```dart
@riverpod
Future<Order> order(OrderRef ref, String orderId) async {
  return ref.read(orderRepoProvider).getOrder(orderId).then((r) => r.dataOrThrow);
}

// Usage
final orderAsync = ref.watch(orderProvider('order_123'));

// Each unique orderId = separate cache entry
// Auto-disposed when no longer watched (with autoDispose default in Riverpod 2.0)
```

**Rule:** Use family cho per-id data (specific order, user, post). Mỗi id một cache entry.

---

## 3. autoDispose — memory management

```dart
// Default Riverpod 2.0+ với codegen: autoDispose
@riverpod  // = autoDispose by default
Future<List<Order>> orders(OrdersRef ref) async { ... }

// Keep alive (NOT auto disposed)
@Riverpod(keepAlive: true)
Future<User?> currentUser(CurrentUserRef ref) async { ... }
```

**Rules:**
- autoDispose: dispose khi no widget watches → save memory
- keepAlive: app-level singletons (auth, current user, env config)
- `ref.keepAlive()` runtime: keep alive after first successful load

```dart
@riverpod
Future<List<Order>> orders(OrdersRef ref) async {
  final result = await ref.read(orderRepoProvider).getOrders();
  if (result is Success) {
    ref.keepAlive();  // chỉ keep nếu success
  }
  return result.dataOrThrow;
}
```

---

## 4. ref.listen — side effects (toast, navigation)

```dart
class OrdersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen state changes WITHOUT rebuild
    ref.listen(ordersNotifierProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          if (error is AppError) {
            showSnackBar(context, error.userMessage);
          }
        },
        data: (orders) {
          if (prev?.value?.length == orders.length - 1) {
            showSnackBar(context, 'Đã thêm đơn hàng mới');
          }
        },
      );
    });

    final orders = ref.watch(ordersNotifierProvider);
    // ... rebuild on changes
  }
}
```

**Rule:** `ref.watch` rebuilds widget. `ref.listen` chỉ trigger callback (no rebuild). Use `listen` cho:
- Show toast/snackbar
- Navigation (after login success → navigate home)
- Logging analytics

---

## 5. invalidate — refresh provider

```dart
// Force re-run build()
ref.invalidate(ordersNotifierProvider);

// Specific family entry
ref.invalidate(orderProvider('order_123'));

// All family entries
ref.invalidate(orderProvider);

// In notifier (refresh self)
ref.invalidateSelf();
```

**Pattern:** Pull-to-refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(ordersNotifierProvider);
    await ref.read(ordersNotifierProvider.future);  // wait for new data
  },
  child: ListView(...),
)
```

---

## 6. Dependent providers (graph)

```dart
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final auth = ref.watch(authNotifierProvider);
  if (auth.value == null) throw const AuthError('No user');
  return auth.value!;
}

@riverpod
Future<List<Order>> userOrders(UserOrdersRef ref) async {
  final user = await ref.watch(currentUserProvider.future);  // wait for user
  return ref.read(orderRepoProvider).getOrdersByUser(user.id).then((r) => r.dataOrThrow);
}

// Auth changes → user changes → orders re-fetch automatically
```

**Rule:** `ref.watch` cho dependent provider — change in dep auto-triggers re-build.

---

## 7. Optimistic updates

```dart
@riverpod
class Orders extends _$Orders {
  @override
  Future<List<Order>> build() async => _fetch();

  Future<void> deleteOrder(String orderId) async {
    final previousState = state.value ?? [];
    // Optimistic remove
    state = AsyncData(previousState.where((o) => o.id != orderId).toList());

    final result = await ref.read(orderRepoProvider).deleteOrder(orderId);
    if (result is Failure) {
      // Rollback
      state = AsyncData(previousState);
      ref.read(toastProvider.notifier).showError(result.error.userMessage);
    }
  }
}
```

---

## 8. Search với debounce

```dart
@riverpod
class SearchQuery extends _$SearchQuery {
  Timer? _debounce;

  @override
  String build() => '';

  void update(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = query;
    });
  }
}

@riverpod
Future<List<Product>> searchResults(SearchResultsRef ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final result = await ref.read(productRepoProvider).search(query);
  return result.dataOrThrow;
}

// UI
TextField(
  onChanged: (v) => ref.read(searchQueryProvider.notifier).update(v),
)
```

---

## 9. Pagination với infinite scroll

```dart
@riverpod
class PaginatedOrders extends _$PaginatedOrders {
  int _page = 1;
  bool _hasMore = true;
  final List<Order> _allOrders = [];

  @override
  Future<List<Order>> build() async {
    return _loadInitial();
  }

  Future<List<Order>> _loadInitial() async {
    _page = 1;
    _allOrders.clear();
    final orders = await _fetchPage(1);
    _allOrders.addAll(orders);
    return _allOrders;
  }

  Future<List<Order>> _fetchPage(int page) async {
    final result = await ref.read(orderRepoProvider).getOrders(page: page);
    return result.dataOrThrow;
  }

  Future<void> loadMore() async {
    if (!_hasMore || state is AsyncLoading) return;

    final next = _page + 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newOrders = await _fetchPage(next);
      _hasMore = newOrders.isNotEmpty;
      _page = next;
      _allOrders.addAll(newOrders);
      return List.from(_allOrders);  // new list reference
    });
  }
}

// In UI
class OrdersList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(paginatedOrdersProvider);
    final scrollController = useScrollController();

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          ref.read(paginatedOrdersProvider.notifier).loadMore();
        }
      }
      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    return ordersAsync.when(...);
  }
}
```

---

## 10. Provider override cho testing

```dart
testWidgets('shows orders', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ordersNotifierProvider.overrideWith(() =>
          FakeOrdersNotifier([testOrder1, testOrder2])),
        authNotifierProvider.overrideWith(() =>
          FakeAuthNotifier(authenticatedWith: testUser)),
      ],
      child: const MaterialApp(home: OrdersScreen()),
    ),
  );

  expect(find.text('Order #001'), findsOneWidget);
  expect(find.text('Order #002'), findsOneWidget);
});
```

---

## ANTI-PATTERNS Riverpod

| ✗ | ✓ | Lý do |
|---|---|-------|
| `ref.read` trong `build()` | `ref.watch` | Won't rebuild on change |
| `ref.watch` trong callback | `ref.read` | Trigger unnecessary rebuilds |
| Provider trong widget local var | Provider top-level / generated | Lifecycle issue |
| `final myProvider = Provider...` (no codegen) | `@riverpod` annotation | Type-safety + tooling |
| `setState` mix với provider | Pure provider state | Confused source of truth |
| Async work in `build()` then `setState` | `AsyncNotifier` | Built-in loading/error |
| Multiple HTTP fetch in widget | Notifier orchestrate | Concerns separated |
| Forgot `autoDispose` | `@riverpod` (default autoDispose) | Memory leak |
