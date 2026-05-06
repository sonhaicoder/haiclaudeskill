---
name: debug-first
description: >
  Auto-trigger khi gặp error, bug, exception, traceback, "không chạy", "bị lỗi", "sao lại",
  "why is", "crash", "undefined", "TypeError", "KeyError", "AttributeError", "ImportError",
  "ModuleNotFoundError", "FAILED", "AssertionError", "500 Internal Server Error", "CORS",
  "Cannot read properties", "null reference", "Stack trace", "Traceback (most recent call last)",
  paste error message, screenshot lỗi.
  Rule: ĐỌC ERROR MESSAGE TRƯỚC — 80% bugs nằm ngay trong error message. Không đoán, không Google ngay.
---

# Debug-First Skill

> "The most effective debugging tool is still careful thought, coupled with judiciously placed print statements."
> — Brian Kernighan

**Core mandate:** Đọc error message TRƯỚC. Không đoán. Không Google ngay. Không refactor để tránh bug.

---

## 1. Core Philosophy

### Karpathy Rule: Read the Error

80% bugs tự giải thích trong error message. Developer bỏ qua error message là nguyên nhân #1 gây tốn thời gian debug không cần thiết.

```
SAI (tuyệt đối):
  ✗ Thấy đỏ → Google "[error name] fix stackoverflow"
  ✗ Đoán nguyên nhân → sửa code → chạy thử
  ✗ Refactor cả file vì nghĩ "code cũ gây ra"
  ✗ Copy-paste error vào ChatGPT trước khi TỰ đọc

ĐÚNG (bắt buộc):
  ✓ Đọc toàn bộ error message, từ đầu đến cuối
  ✓ Tìm file:line number → mở file đó
  ✓ Đọc code tại dòng đó + 10 dòng xung quanh
  ✓ Reproduce lỗi isolated trước khi fix
```

### Debug Stack (thứ tự bắt buộc)

```
1. READ ERROR     — đọc toàn bộ traceback/stack trace
        ↓
2. LOCATE         — tìm file:line number chính xác
        ↓
3. REPRODUCE      — tạo test case nhỏ nhất có thể reproduce
        ↓
4. HYPOTHESIZE    — đưa ra 1-2 giả thuyết cụ thể (không phải "mọi thứ sai")
        ↓
5. FIX            — thay đổi 1 thứ duy nhất
        ↓
6. VERIFY         — chạy lại, kiểm tra đúng case + không break case khác
```

Nếu skip bước nào → có nguy cơ "fix" sai chỗ, tạo bug mới.

---

## 2. Error Reading Protocol

### 3 Layers của mọi error

| Layer | Câu hỏi | Tìm ở đâu |
|-------|---------|-----------|
| **Type (What)** | Lỗi gì? | Dòng đầu tiên: `TypeError`, `KeyError`, ... |
| **Location (Where)** | Ở đâu? | `File "...", line N, in function_name` |
| **Context (When/How)** | Khi nào xảy ra? | Stack frames phía trên location |

Đọc theo thứ tự: **từ dưới lên**. Dòng cuối cùng = lỗi cụ thể nhất. Dòng đầu = entry point.

### Common Error Types — Python

| Error Type | Meaning | First thing to check |
|------------|---------|---------------------|
| `TypeError` | Sai kiểu dữ liệu (str thay int, None thay object) | In type() của biến đang dùng |
| `KeyError: 'x'` | Dict không có key 'x' | Print dict, dùng `.get('x')` |
| `AttributeError: 'NoneType' object has no attribute 'y'` | Gọi method trên None | Tìm chỗ function trả về None thay vì object |
| `ImportError` / `ModuleNotFoundError` | Module không tồn tại hoặc path sai | `pip list \| grep <name>`, kiểm tra circular import |
| `ValueError` | Giá trị không hợp lệ cho operation | Check input trước khi pass vào function |
| `IndexError` | List index out of range | Check `len(list)` và logic loop |
| `RecursionError` | Stack overflow | Tìm base case bị thiếu trong recursion |
| `RuntimeError: asyncio.run() cannot be called` | Gọi asyncio.run() trong async context | Dùng `await` thay vì `asyncio.run()` |
| `sqlalchemy.exc.MissingGreenlet` | Lazy load trong async context | Thêm `selectinload()` trong query |

### Common Error Types — JavaScript/TypeScript

| Error Type | Meaning | First thing to check |
|------------|---------|---------------------|
| `TypeError: Cannot read properties of undefined` | Truy cập property trên undefined | Optional chaining: `obj?.prop` |
| `TypeError: Cannot read properties of null` | Truy cập property trên null | Null check trước khi access |
| `ReferenceError: x is not defined` | Biến chưa được khai báo | Kiểm tra scope, typo, import |
| `SyntaxError` | Code không parse được | Kiểm tra dấu ngoặc, dấu phẩy |
| `UnhandledPromiseRejection` | Promise bị reject không có catch | Thêm `.catch()` hoặc `try/catch` trong async |
| `CORS error` | Cross-origin request bị block | Server chưa set CORS header đúng |
| `[object Object]` trong string | Quên stringify object | Dùng `JSON.stringify(obj)` |
| `NaN` trong tính toán | Cộng/trừ/nhân undefined hoặc string | Check type trước khi tính |

### Common Error Types — Dart/Flutter

| Error Type | Meaning | First thing to check |
|------------|---------|---------------------|
| `LateInitializationError` | `late` variable chưa được gán | Kiểm tra init flow, dùng nullable thay late |
| `setState() called after dispose()` | Set state sau khi widget bị unmount | Check `if (mounted)` trước setState |
| `type 'Null' is not a subtype of type 'X'` | Null safety violation | Thêm null check hoặc `!` |
| `RenderFlex overflowed` | UI overflow | Dùng `Flexible`, `Expanded`, hoặc `SingleChildScrollView` |
| `ProviderScope not found` | Riverpod provider không có scope | Wrap root widget với `ProviderScope` |

---

## 3. Python Errors — Deep Dive

### Traceback Anatomy

```
Traceback (most recent call last):          ← Bắt đầu traceback
  File "main.py", line 42, in <module>      ← Entry point (cao nhất = xa nhất)
    result = process_order(order_id)
  File "services/order.py", line 18, in process_order
    customer = get_customer(order.customer_id)
  File "services/customer.py", line 7, in get_customer
    return db.query(Customer).filter_by(id=cid).one()  ← Gần nhất
  File "sqlalchemy/orm/query.py", line 1234, in one
    raise NoResultFound(...)
sqlalchemy.orm.exc.NoResultFound: No row found  ← LỖI THỰC SỰ
```

**Đọc từ dưới lên:**
- Dòng cuối = error type + message cụ thể
- Dòng `File "...", line N` ngay trên cuối = chỗ gây ra lỗi trong CODE CỦA MÌNH
- Các dòng trên là call stack (context)

### ImportError — Circular Import Pattern

```python
# Symptom:
ImportError: cannot import name 'UserService' from partially initialized module 'app.services.user'

# Root cause: A imports B, B imports A
# app/services/user.py imports from app/services/order.py
# app/services/order.py imports from app/services/user.py

# Fix: Move shared dependency to third module, or use TYPE_CHECKING
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from app.services.user import UserService
```

### AttributeError: 'NoneType'

```python
# Symptom:
AttributeError: 'NoneType' object has no attribute 'email'

# Means: Biến bị None, không phải object bạn expect
# Tìm chỗ gán biến đó:
user = get_user(id)   # ← get_user() trả None khi không tìm thấy

# Fix 1: Check None trước khi dùng
if user is None:
    raise HTTPException(404, "Không tìm thấy user")

# Fix 2: Query trả về None thay vì raise → fix ở service layer
def get_user(id: int) -> User:
    user = db.get(User, id)
    if not user:
        raise NotFoundError(f"User {id} không tồn tại")
    return user
```

### asyncio.CancelledError / Event Loop Issues

```python
# Symptom 1:
RuntimeError: This event loop is already running.

# Cause: Gọi asyncio.run() bên trong async function đang chạy
# Fix: Dùng await trực tiếp
result = await async_function()  # ĐÚNG
result = asyncio.run(async_function())  # SAI nếu đang trong async context

# Symptom 2:
RuntimeWarning: coroutine 'fetch_data' was never awaited

# Cause: Quên await
data = fetch_data()    # SAI — trả về coroutine object, không run
data = await fetch_data()  # ĐÚNG
```

### SQLAlchemy Lazy Loading trong Async

```python
# Symptom:
sqlalchemy.exc.MissingGreenlet: greenlet_spawn has not been called
# hoặc:
greenlet.error: cannot switch to a different thread

# Cause: Truy cập relationship (lazy loaded) sau khi session đóng,
# hoặc trong async context mà không dùng selectinload

# Fix:
from sqlalchemy.orm import selectinload

# ĐÚNG — eager load relationship cần dùng
result = await db.execute(
    select(Order)
    .where(Order.id == order_id)
    .options(selectinload(Order.items))  ← load trước
)
order = result.scalar_one()
print(order.items)  # OK — đã load sẵn
```

### Pydantic ValidationError

```python
# Symptom (FastAPI 422 response body):
{
  "detail": [
    {
      "type": "missing",
      "loc": ["body", "email"],      ← field nào bị lỗi
      "msg": "Field required",
      "input": {...}
    }
  ]
}

# Đọc "loc": ["body", "field_name"] → biết ngay field nào thiếu/sai
# Đọc "type" → biết lỗi gì: "missing", "string_type", "int_parsing", ...
# Đọc "msg" → human-readable message
```

---

## 4. JavaScript/TypeScript Errors — Deep Dive

### Cannot read properties of undefined/null

```javascript
// Lỗi phổ biến nhất JS — 90% có cùng pattern:
TypeError: Cannot read properties of undefined (reading 'name')

// Diagnose trong 10 giây:
console.log(typeof user);    // "undefined" → user chưa được set
console.log(user);           // undefined → API chưa trả về, hay response structure sai

// Fixes:
user?.name                    // optional chaining — undefined thay vì crash
user?.name ?? 'Unknown'       // nullish coalescing — default value
if (!user) return null        // early return
```

### Type Narrowing Failures

```typescript
// Symptom:
Argument of type 'string | undefined' is not assignable to parameter of type 'string'

// Cause: TypeScript biết variable có thể undefined, function không nhận undefined
function greet(name: string) { ... }
greet(user.name)  // SAI nếu user.name là string | undefined

// Fix 1: Guard trước khi call
if (user.name) greet(user.name)

// Fix 2: Non-null assertion (chỉ dùng khi CHẮC CHẮN không null)
greet(user.name!)

// Fix 3: Default value
greet(user.name ?? 'Guest')
```

### Async/Await Unhandled Rejection

```javascript
// Symptom:
UnhandledPromiseRejectionWarning: Error: Network request failed

// Cause: Async function throw mà không có try/catch
async function loadData() {
    const data = await fetchAPI()  // Nếu fetchAPI() throw → unhandled
    return data
}

// Fix: Wrap trong try/catch
async function loadData() {
    try {
        const data = await fetchAPI()
        return data
    } catch (error) {
        console.error('loadData failed:', error)
        throw error  // re-throw nếu caller cần handle
    }
}
```

### React Hooks Rules Violation

```javascript
// Symptom:
React Hook "useState" is called conditionally. Hooks must be called in the same order every render.

// Cause: Hook trong if/loop/nested function
function Component({ show }) {
    if (show) {
        const [count, setCount] = useState(0)  // SAI — conditionally called
    }
}

// Fix: Hooks luôn ở top level
function Component({ show }) {
    const [count, setCount] = useState(0)  // ĐÚNG — luôn gọi
    if (!show) return null
}
```

---

## 5. Flutter/Dart Errors — Deep Dive

### setState on Disposed Widget

```dart
// Symptom:
FlutterError (setState() called after dispose())

// Cause: Async operation hoàn thành sau khi widget đã bị unmount
Future<void> loadData() async {
    final data = await api.fetch();
    setState(() { this.data = data; });  // CRASH nếu widget đã dispose
}

// Fix:
Future<void> loadData() async {
    final data = await api.fetch();
    if (!mounted) return;  // ← check trước setState
    setState(() { this.data = data; });
}
```

### LateInitializationError

```dart
// Symptom:
LateInitializationError: Field 'controller' has not been initialized.

// Cause: `late` variable được truy cập trước khi gán
class MyWidget extends StatefulWidget { ... }
class _MyWidgetState extends State<MyWidget> {
    late TextEditingController controller;

    @override
    void build(BuildContext context) {
        return TextField(controller: controller);  // CRASH nếu initState chưa chạy
    }
    // Quên initState!
}

// Fix: Luôn init trong initState
@override
void initState() {
    super.initState();
    controller = TextEditingController();
}

@override
void dispose() {
    controller.dispose();  // Và dispose trong dispose()
    super.dispose();
}
```

### Riverpod ProviderScope Missing

```dart
// Symptom:
ProviderNotFoundException: Tried to read a provider in a widget that is not a descendant of ProviderScope.

// Fix: Wrap root widget
void main() {
    runApp(
        ProviderScope(  // ← BẮT BUỘC bao ngoài MaterialApp
            child: MyApp(),
        ),
    );
}
```

---

## 6. FastAPI/HTTP Errors — Deep Dive

### 422 Unprocessable Entity

```
# Pydantic validation fail — request body/params không đúng schema
# Response body có "detail" array — ĐỌC NÓ:

{
    "detail": [
        {
            "type": "missing",
            "loc": ["body", "price"],    ← field "price" trong body bị thiếu
            "msg": "Field required",
            "input": {"name": "Áo thun"}
        },
        {
            "type": "int_parsing",
            "loc": ["body", "quantity"],  ← field "quantity" parse thành int thất bại
            "msg": "Input should be a valid integer",
            "input": "abc"
        }
    ]
}

# "loc" path: ["body", "field"] → request body
#             ["query", "field"] → query param
#             ["path", "shop_id"] → path param
```

### 401 vs 403

```
401 Unauthorized  = Chưa xác thực (token thiếu hoặc invalid)
                    Fix: Gửi Authorization header đúng

403 Forbidden     = Đã xác thực nhưng không có quyền
                    Fix: Kiểm tra user role/permissions

Lưu ý: Trả 404 cho "resource không thuộc shop" thay vì 403 (tránh lộ existence)
```

### 500 Internal Server Error

```python
# Production: response chỉ trả {"detail": "Internal server error"} — không lộ traceback
# Debug: kiểm tra SERVER LOGS, không phải response body

# Trong FastAPI dev mode, dùng:
uvicorn main:app --reload  # sẽ in traceback ra terminal

# Luôn wrap business logic để có meaningful error:
try:
    result = await order_service.create(data)
except InsufficientStockError as e:
    raise HTTPException(400, str(e))
except Exception as e:
    logger.error(f"Unexpected error creating order: {e}", exc_info=True)
    raise HTTPException(500, "Lỗi hệ thống, vui lòng thử lại")
```

### CORS Error

```
Access to fetch at 'http://api.example.com' from origin 'http://localhost:3001'
has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present

# Đây là LỖI BACKEND (server chưa set CORS), không phải frontend
# Fix trong FastAPI:
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3001", "https://your-domain.com"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Common mistake: OPTIONS request bị block → thêm allow_methods=["OPTIONS", ...]
```

---

## 7. The 10-Second Debug Rule

**Trước khi chạm vào code, làm 3 bước này trong 10 giây:**

```
Step 1: Đọc toàn bộ error message (đừng scan, ĐỌC)
        → Ghi ra: Error type là gì? Ở file nào? Line mấy?

Step 2: Mở file đó, đến đúng line đó
        → Đọc 10 dòng trên và dưới — không được sửa gì

Step 3: Thêm 1 print/log ngay tại line đó để xem data thực tế
        print(f"DEBUG: var = {var}, type = {type(var)}")
        → Chạy lại, đọc output
```

Sau 3 bước này, trong 90% trường hợp bạn đã biết fix cái gì.

**Nếu sau 10 giây vẫn không hiểu:** mới được Google, và Google với từ khóa CỤ THỂ (error type + context), không phải "how to fix error in python".

---

## 8. When Googling is OK

**OK khi:**
- Bạn đã hiểu WHAT error là (error type, tại file:line nào)
- Bạn biết HYPOTHESIS của mình nhưng muốn confirm syntax/API
- Error từ third-party library mà bạn không có source code

**Không OK khi:**
- Chưa đọc hết error message
- Google để tránh phải hiểu root cause
- Copy-paste fix mà không hiểu fix làm gì

**Google đúng cách:**
```
SAI:  "cannot read properties of undefined fix"
ĐÚNG: "TypeError cannot read properties undefined reading 'items' react useEffect"
                                                           ↑ context cụ thể

SAI:  "sqlalchemy error python fix"
ĐÚNG: "sqlalchemy MissingGreenlet async selectinload"
                   ↑ exact error name
```

---

## 9. Quick Fix Checklist

Trước khi commit fix, tự hỏi:

```
□ Đã đọc TOÀN BỘ traceback (không chỉ dòng cuối)?
□ Đã tìm chính xác file:line gây lỗi?
□ Đã reproduce lỗi trong môi trường isolated?
□ Chỉ thay đổi 1 thứ duy nhất?
□ Đã verify lỗi không còn xuất hiện?
□ Đã kiểm tra không break case khác (regression)?
□ Nếu fix là workaround → đã ghi lại TODO/comment giải thích?
□ Fix có áp dụng được cho pattern tương tự ở chỗ khác không?
```

**Nếu fail bất kỳ checkbox nào → chưa được commit.**

---

## References

- `references/stacktrace-guide.md` — Anatomy chi tiết của Python traceback + JS stack trace + FastAPI 422 parse
- `references/git-bisect.md` — Git bisect workflow khi lỗi xuất hiện sau nhiều commits
