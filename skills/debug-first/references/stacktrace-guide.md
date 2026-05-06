# Stacktrace Guide — Đọc Error Như Pro

> Mục tiêu: Nhìn vào stacktrace 5 giây → biết chính xác bug ở đâu, là gì.

---

## 1. Python Traceback — Full Anatomy

```
Traceback (most recent call last):          [A] Header — luôn là dòng này
  File "main.py", line 1, in <module>       [B] Outermost frame — entry point
    app = create_app()
  File "app/factory.py", line 23, in create_app
    db.init_app(app)
  File "app/extensions.py", line 11, in init_app   [C] Middle frames — call chain
    engine = create_engine(config.DATABASE_URL)
  File "sqlalchemy/engine/create.py", line 601, in create_engine
    return dialect_cls.dbapi()
  File "psycopg2/__init__.py", line 122, in connect  [D] Library frame (ít quan trọng hơn)
    conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
psycopg2.OperationalError: could not connect to server [E] Error type + message
```

### Labels giải thích:

| Label | Ý nghĩa | Ưu tiên đọc |
|-------|---------|-------------|
| **[A]** Header | Luôn là "Traceback (most recent call last)" | Bỏ qua |
| **[B]** Outermost | Nơi chương trình bắt đầu (thường main.py) | Thấp |
| **[C]** Middle frames | Call chain — giúp hiểu context | Trung bình |
| **[D]** Library frames | Code của library (sqlalchemy, requests...) | Thấp — ít khi fix ở đây |
| **[E]** Error line | Error type + message cụ thể | **CAO NHẤT — đọc đây trước** |

### Chiến lược đọc:

```
1. Đọc [E] trước — error type + message nói gì?
2. Tìm frame [C] cuối cùng trong CODE CỦA MÌNH (không phải library)
   → Đó là chỗ gây ra lỗi
3. Đọc [B] nếu cần hiểu entry point
```

**Cách nhận biết "code của mình" vs library:**
- Code của mình: path có tên project (`app/`, `services/`, `models/`)
- Library: path trong `site-packages/` hoặc tên library (`sqlalchemy/`, `fastapi/`, `pydantic/`)

---

## 2. JavaScript/Node.js Error — Full Anatomy

```
TypeError: Cannot read properties of undefined (reading 'items')   [A] Error type + message
    at processOrder (/app/services/order.js:42:28)                  [B] Innermost (gần lỗi nhất)
    at async OrderController.create (/app/controllers/order.js:18:5)
    at async Layer.handle [as handle_request] (/node_modules/express/lib/router/layer.js:95:5)  [C] Framework
    at next (/node_modules/express/lib/router/route.js:137:13)
    at Route.dispatch (/node_modules/express/lib/router/route.js:112:3)
    at async Server.handleRequest (/node_modules/express/lib/server.js:73:5)  [D] Framework
```

**Khác Python:** JS stack trace đọc từ TRÊN xuống (không phải dưới lên).
- Dòng đầu = error
- Dòng thứ 2 = chỗ xảy ra lỗi gần nhất

### Đọc frame:

```
at processOrder (/app/services/order.js:42:28)
   ↑ function name    ↑ file path        ↑ line:column
```

- **line:column** → mở file, đến line 42, column 28
- `column 28` = character thứ 28 trên dòng đó (thường trỏ đến property access sai)

### Browser vs Node.js:

```
# Browser (Chrome DevTools):
TypeError: Cannot read properties of undefined (reading 'map')
    at ProductList (ProductList.tsx:23:15)   ← Click vào link này trong DevTools

# Node.js (terminal):
Không có clickable link → copy path + line vào editor thủ công
```

---

## 3. FastAPI 422 Error — Parse chi tiết

422 Unprocessable Entity = Pydantic validation fail. Response body luôn có structure sau:

```json
{
    "detail": [
        {
            "type": "missing",
            "loc": ["body", "email"],
            "msg": "Field required",
            "input": {
                "name": "Test User"
            },
            "url": "https://errors.pydantic.dev/..."
        },
        {
            "type": "int_parsing",
            "loc": ["body", "age"],
            "msg": "Input should be a valid integer, unable to parse string as an integer",
            "input": "twenty",
            "url": "https://errors.pydantic.dev/..."
        }
    ]
}
```

### Parse từng field:

| Field | Giải thích | Ví dụ |
|-------|-----------|-------|
| `type` | Loại validation error | `"missing"`, `"string_type"`, `"int_parsing"` |
| `loc` | Path đến field bị lỗi | `["body", "email"]` = field "email" trong request body |
| `msg` | Human-readable error | `"Field required"` |
| `input` | Giá trị thực tế được gửi | `"twenty"` (đã gửi string thay int) |

### `loc` path meanings:

```
["body", "field"]        → request body JSON field
["query", "page"]        → query string param ?page=
["path", "shop_id"]      → URL path param /shops/{shop_id}
["body", "items", 0, "qty"]  → nested: body.items[0].qty
```

### Common 422 causes:

| `type` value | Nghĩa | Fix |
|-------------|-------|-----|
| `missing` | Field bắt buộc không có | Thêm field vào request |
| `string_type` | Cần string, gửi số/null | Gửi đúng kiểu |
| `int_parsing` | Cần int, gửi string không parse được | Gửi số, không phải "abc" |
| `bool_parsing` | Cần bool, gửi string "true"/"false" | Gửi `true`/`false` (JSON boolean) |
| `datetime_parsing` | Datetime format sai | Dùng ISO 8601: `"2026-05-06T10:00:00Z"` |
| `value_error` | Custom validator fail | Đọc `msg` để biết rule bị vi phạm |

---

## 4. Common Error Patterns Table

| Error message (substring) | Root cause | Immediate fix |
|--------------------------|-----------|---------------|
| `NoneType object has no attribute` | Biến là None, gọi method trên None | Tìm chỗ trả None, thêm null check |
| `object is not subscriptable` | Dùng `obj[0]` hoặc `obj['key']` trên non-list/non-dict | `print(type(obj))` → xem thực sự là gì |
| `list index out of range` | `list[i]` với i >= len(list) | Check `len(list)` trước khi index |
| `dict has no key` / `KeyError` | Key không tồn tại trong dict | Dùng `.get(key)` hoặc kiểm tra `key in dict` |
| `cannot import name X from Y` | X không export từ module Y, hoặc circular import | Kiểm tra `__init__.py`, tìm circular dependency |
| `module not found` | Package chưa install hoặc tên sai | `pip install <package>`, kiểm tra typo |
| `greenlet_spawn` / `MissingGreenlet` | SQLAlchemy lazy load trong async context | Thêm `selectinload()` vào query |
| `coroutine was never awaited` | Quên `await` trước async function | Thêm `await` |
| `This event loop is already running` | `asyncio.run()` trong async context | Xóa `asyncio.run()`, dùng `await` trực tiếp |
| `Access-Control-Allow-Origin` | CORS không được cấu hình | Add CORS middleware, whitelist origin |
| `Cannot read properties of undefined` | JS: truy cập property trên undefined | Optional chaining `?.`, null check |
| `setState called after dispose` | Flutter: async về sau khi widget unmount | Check `if (mounted)` trước setState |
| `LateInitializationError` | Dart: `late` var dùng trước khi gán | Init trong `initState()` |
| `ProviderNotFoundException` | Riverpod: thiếu ProviderScope | Wrap root với `ProviderScope` |
| `Field required` (FastAPI 422) | Request thiếu required field | Thêm field vào request body |
| `UNIQUE constraint failed` | Insert duplicate primary/unique key | Check exists trước khi insert, dùng `ON CONFLICT` |
| `Connection refused` | Service target không chạy hoặc port sai | `netstat -an \| grep <port>`, kiểm tra URL config |
| `SSL: CERTIFICATE_VERIFY_FAILED` | Certificate hết hạn hoặc self-signed | Kiểm tra cert, thêm CA bundle |

---

## 5. Error Fingerprinting

Một số phrases trong error message NGAY LẬP TỨC tiết lộ bug — không cần đọc context:

| Phrase (xuất hiện trong error) | Bug ngay lập tức | Action |
|-------------------------------|-----------------|--------|
| `"NoneType" object` | Biến None được dùng như object | Tìm chỗ return None thay vì object |
| `is not subscriptable` | Dùng `[]` trên object không hỗ trợ | `type(obj)` ngay tại dòng đó |
| `was never awaited` | Thiếu `await` | Grep toàn file tìm function đó, thêm await |
| `greenlet_spawn` | SQLAlchemy lazy load async | Thêm selectinload vào query |
| `Access-Control-Allow-Origin` | CORS | Config CORS middleware phía server |
| `UNIQUE constraint` | Duplicate insert | Thêm exists check hoặc ON CONFLICT DO NOTHING |
| `No module named` | Package chưa install hoặc typo | pip install / kiểm tra tên |
| `circular import` | Import vòng tròn | Restructure imports, dùng TYPE_CHECKING |
| `Cannot read properties of undefined` (JS) | Async data chưa về mà đã access | Optional chaining hoặc loading guard |
| `Field required` (Pydantic) | Request body thiếu field | Xem `loc` trong 422 response |
| `Connection refused` | Target service down | Kiểm tra service đang chạy, port đúng |
| `SSL CERTIFICATE_VERIFY_FAILED` | Certificate problem | Verify cert chain |
| `jwt malformed` / `invalid signature` | Token corrupt hoặc wrong secret | Check SECRET_KEY, regenerate token |

---

## 6. Async/Coroutine Errors

Async errors thường bị bỏ qua vì không crash ngay — chúng fail silently. Các pattern hay gặp:

### RuntimeWarning: coroutine was never awaited

```python
# Symptom:
RuntimeWarning: coroutine 'fetch_products' was never awaited

# Cause: Gọi async function mà quên await
products = fetch_products(shop_id)   # SAI — trả về coroutine object
products = await fetch_products(shop_id)  # ĐÚNG

# Detect: Python print coroutine object thay vì result
print(products)  # <coroutine object fetch_products at 0x...> ← đây rồi
```

### Task Exception Was Never Retrieved

```python
# Symptom: Trong logs:
Task exception was never retrieved
future: <Task finished name='Task-3' coro=<send_email() done, defined at ...>
Exception: SMTPConnectError(...)

# Cause: asyncio.create_task() tạo task nhưng không await result
task = asyncio.create_task(send_email(order))  # Exception bị nuốt

# Fix: Await task hoặc add done callback
task = asyncio.create_task(send_email(order))
task.add_done_callback(lambda t: t.exception() and logger.error(t.exception()))
```

### Blocking Call in Async Context

```python
# Symptom: Event loop bị block, requests khác timeout

# Cause: Gọi blocking operation trong async function
async def get_data():
    response = requests.get(url)  # BLOCKING — blocks entire event loop!

# Fix: Dùng async library
async def get_data():
    async with httpx.AsyncClient() as client:
        response = await client.get(url)

# Hoặc nếu phải dùng blocking call (ví dụ smtplib):
import asyncio
loop = asyncio.get_event_loop()
result = await loop.run_in_executor(None, blocking_function, arg1, arg2)
```

### SQLAlchemy Async Session Gotchas

```python
# Symptom:
sqlalchemy.exc.InvalidRequestError: Session is already flushing

# Cause: Gọi db.flush() trong session đang flush
# Fix: Không manually flush — để SQLAlchemy tự quản lý

# Symptom:
DetachedInstanceError: Instance <Model> is not bound to a Session

# Cause: Dùng model object SAU KHI session đóng
# Fix: Load tất cả data cần thiết TRƯỚC khi đóng session
async with AsyncSession(engine) as session:
    user = await session.get(User, user_id)
    name = user.name   # OK — trong session
# Session đóng ở đây

# SAI: dùng user sau session
print(user.orders)  # CRASH — lazy load sau khi session đóng

# ĐÚNG: load trước
async with AsyncSession(engine) as session:
    user = await session.execute(
        select(User).where(User.id == user_id).options(selectinload(User.orders))
    )
    user = result.scalar_one()
    # Trả về data primitive, không phải ORM object
    return {"name": user.name, "orders": [o.id for o in user.orders]}
```
