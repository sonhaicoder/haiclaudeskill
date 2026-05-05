---
name: backend-fastapi
description: |
  Backend FastAPI skill cho multi-tenant SaaS với SQLAlchemy 2.0 async + PostgreSQL + Alembic.
  AUTO-TRIGGER khi: chạm file backend/app/**/*.py, file có `from fastapi`, `from sqlalchemy`, file Alembic migration, hoặc user nói "viết API/endpoint/model/migration/service" + "backend/route/schema/repository".
  Force apply 7 luật cứng: shop_id filter mọi query, Decimal money KHÔNG float, async/httpx KHÔNG requests, atomic stock update, order state machine validate transitions, JWT auth + permission check, env vars qua settings KHÔNG hardcode.
  Distilled từ Commerce Platform production patterns (60K+ lines, 100 commits).
  KHÔNG dùng cho: Express/Node backend, Django, frontend, mobile, infra/docker.
---

# Backend FastAPI Skill — Multi-Tenant SaaS Patterns

> **Triết lý:** Backend không "đẹp" — backend đúng. Đúng nghĩa là: data isolation, money precision, race-condition-free, traceable error.
> **Source:** distilled từ Commerce Platform 60K+ lines production code.

---

## 1. AUTO-TRIGGER

```
DÙNG khi:
  ✓ Chạm file: backend/**/*.py, app/api/**, app/services/**, app/models/**, app/schemas/**
  ✓ File có import: from fastapi, from sqlalchemy, from pydantic, from alembic
  ✓ User nói "viết API/endpoint/route/model/migration/service/repository/schema"
  ✓ User nói "thêm field/relationship/query/transaction"
  ✓ Project có pyproject.toml hoặc requirements.txt với fastapi+sqlalchemy

KHÔNG dùng khi:
  ✗ Express/Node/Django backend
  ✗ Frontend (.tsx/.jsx) — dùng web-taste
  ✗ Mobile (.dart/.swift) — dùng mobile-design
  ✗ Infra (docker/CI) — không UI/business logic
```

---

## 2. BẢY LUẬT CỨNG (KHÔNG ĐƯỢC PHÁ)

### LUẬT 1 — Multi-tenant: MỌI query có `shop_id` filter

```python
# ✗ SAI — lộ data shop khác
products = await db.execute(select(Product))

# ✓ ĐÚNG — luôn filter
products = await db.execute(
    select(Product).where(Product.shop_id == current_shop.id)
)
```

**Rules:**
- Mọi `select/update/delete` PHẢI có `where(Model.shop_id == current_shop.id)`
- Return **404** nếu resource không thuộc shop (KHÔNG 403 — tránh lộ existence)
- User có thể own nhiều Shop — Shop là tenant chính, KHÔNG phải User
- Composite query: filter shop_id ở MỌI table joined

```python
# Composite query
result = await db.execute(
    select(Order)
    .join(Customer)
    .where(
        Order.shop_id == current_shop.id,
        Customer.shop_id == current_shop.id,  # PHẢI filter cả join table
        Order.id == order_id,
    )
)
```

### LUẬT 2 — Tiền: `Decimal` + `Numeric(14,2)`, KHÔNG `float`

```python
# ✗ SAI — float = sai số tích lũy
price = 250000.0 * 0.9  # 225000.00000000003

# ✓ ĐÚNG — Decimal precision
from decimal import Decimal
price = Decimal("250000") * Decimal("0.9")  # 225000.0
```

**Rules:**
- Database column: `Numeric(14, 2)` cho mọi cột tiền
- Python: `decimal.Decimal` mọi tính toán
- VNPay amount precision: dùng `.quantize(Decimal("1"))` trước `int()`
- Order total = subtotal − discount + shipping (TẤT CẢ Decimal)

```python
# VNPay amount fix (bug đã gặp)
amount_vnp = int(order.total.quantize(Decimal("1")) * 100)
```

### LUẬT 3 — Async everywhere, `httpx` KHÔNG `requests`

```python
# ✗ SAI — block async event loop
import requests
result = requests.get(url)

# ✓ ĐÚNG — async
import httpx
async with httpx.AsyncClient() as client:
    result = await client.get(url)
```

**Rules:**
- Backend 100% async (asyncpg, httpx, aiofiles)
- KHÔNG import `requests`
- SMTP blocking → `await loop.run_in_executor(None, smtplib_send, msg)`
- Database session: `AsyncSession` từ SQLAlchemy 2.0
- Endpoint: `async def` luôn

### LUẬT 4 — Inventory: atomic SQL, KHÔNG read-then-write

```python
# ✗ SAI — race condition
product.stock -= quantity
await db.commit()

# ✓ ĐÚNG — atomic update với optimistic lock
result = await db.execute(
    update(ProductVariant)
    .where(
        ProductVariant.id == variant_id,
        ProductVariant.stock >= quantity,  # CHECK trong query
    )
    .values(stock=ProductVariant.stock - quantity)
    .returning(ProductVariant.stock)
)
if result.rowcount == 0:
    raise HTTPException(400, "Không đủ hàng trong kho")
```

**Rules:**
- Trừ kho bằng atomic SQL với `>=` check → `rowcount == 0` = không đủ
- Cộng kho khi cancel/return (atomic + log)
- Log mọi thay đổi vào `inventory_logs` (who, when, why)
- KHÔNG `product.stock -= n` rồi commit

### LUẬT 5 — Order state machine: KHÔNG nhảy trạng thái

```python
VALID_TRANSITIONS = {
    "pending":    ["confirmed", "cancelled"],
    "confirmed":  ["packing", "cancelled"],
    "packing":    ["shipping", "cancelled"],
    "shipping":   ["delivered", "returned"],
    "delivered":  ["completed", "returned"],
    "completed":  [],          # terminal
    "returned":   ["refunded"],
    "refunded":   [],          # terminal
    "cancelled":  [],          # terminal
}

def validate_transition(current: str, next_status: str) -> bool:
    return next_status in VALID_TRANSITIONS.get(current, [])

# Sử dụng
if not validate_transition(order.status, new_status):
    raise HTTPException(400, f"Không thể chuyển từ {order.status} sang {new_status}")
```

**Rules:**
- Mọi thay đổi status PHẢI qua `validate_transition()`
- Log vào `order_status_logs` (who, when, from, to, note)
- KHÔNG bao giờ update status bằng raw SQL bypass
- Trigger notifications (email/SMS) sau khi log thành công

### LUẬT 6 — Auth: JWT + shop ownership + role check

```python
@router.get("/shops/{shop_id}/products")
async def list_products(
    shop_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),     # JWT decode
    shop: Shop = Depends(get_current_shop),              # ownership verify
):
    # shop.id == shop_id và user.id has access đã được verified
    ...
```

**Rules:**
- Mọi admin endpoint: 3-layer guard (JWT + shop ownership + role)
- Return **404** thay vì 403 cho not-owned resource
- Public storefront API: NO auth nhưng GIỚI HẠN data (không trả `cost_price`, `internal_note`)
- Customer auth khác seller auth — endpoint khác `/customer/auth/*`

### LUẬT 7 — Env vars qua `Settings`, KHÔNG hardcode

```python
# ✗ SAI
JWT_SECRET = "hardcoded-secret-123"

# ✓ ĐÚNG — pydantic Settings
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    JWT_SECRET: str
    DATABASE_URL: str
    GROQ_API_KEY: str = ""

    model_config = {"env_file": ".env", "case_sensitive": True}

settings = Settings()  # raise if missing
```

**Rules:**
- Mọi secret/config qua `settings`
- `.env` trong `.gitignore`
- Production secrets: env vars trên Railway/Vercel UI, không commit
- Default values: chỉ cho non-secret (port, log level)

---

## 3. PATTERNS BẮT BUỘC

### Lazy loading: prevent N+1

```python
# ✗ SAI — N+1 queries
products = await db.execute(select(Product).where(...))
for p in products.scalars():
    print(p.variants)  # mỗi access = 1 query mới!

# ✓ ĐÚNG — eager load
products = await db.execute(
    select(Product)
    .options(selectinload(Product.variants))   # 1 extra query cho ALL variants
    .where(...)
)
```

**Rules:**
- Default lazy strategy: `lazy="noload"` ở model (PHÒNG NGỪA accidental N+1)
- Endpoint nào cần relationship → explicit `selectinload(...)` hoặc `joinedload(...)`
- KHÔNG `lazy="select"` (default) — dễ tạo N+1 silent
- 1-many: `selectinload` (2 queries, fast)
- 1-1: `joinedload` (1 query với JOIN)

### Snapshot pattern (OrderItem giữ giá tại thời điểm)

```python
class OrderItem(Base):
    order_id: Mapped[int] = mapped_column(ForeignKey("orders.id"))
    product_id: Mapped[int] = mapped_column(ForeignKey("products.id"))
    variant_id: Mapped[int | None] = mapped_column(ForeignKey("product_variants.id"))

    # Snapshot fields — KHÔNG join product để lấy
    product_name: Mapped[str] = mapped_column(String(500))
    variant_name: Mapped[str | None] = mapped_column(String(255))
    price: Mapped[Decimal] = mapped_column(Numeric(14, 2))  # giá tại thời điểm đặt
    quantity: Mapped[int] = mapped_column(Integer)
    total: Mapped[Decimal] = mapped_column(Numeric(14, 2))  # price * quantity
```

**Tại sao:** Product giá thay đổi sau khi đặt → join product = sai lịch sử. Snapshot = source of truth.

### Pagination chuẩn

```python
@router.get("/products")
async def list_products(
    page: int = 1,
    page_size: int = 20,
    search: str | None = None,
    sort_by: str = "created_at",
    sort_order: str = "desc",
    ...
):
    query = select(Product).where(Product.shop_id == shop.id)
    if search:
        query = query.where(Product.name.ilike(f"%{search}%"))

    total = await db.scalar(select(func.count()).select_from(query.subquery()))

    sort_col = getattr(Product, sort_by)
    if sort_order == "desc":
        sort_col = sort_col.desc()

    query = query.order_by(sort_col).offset((page - 1) * page_size).limit(page_size)
    items = (await db.execute(query)).scalars().all()

    return {
        "items": items,
        "total": total,
        "page": page,
        "page_size": page_size,
        "total_pages": (total + page_size - 1) // page_size,
    }
```

### Error handling: clean JSON, no traceback leak

```python
# Custom error handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    logger.error(f"Unhandled: {exc}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"detail": "Lỗi hệ thống. Vui lòng thử lại sau."},
    )
```

**Rules:**
- Production NEVER trả traceback ra response
- Log full traceback với `logger.error(..., exc_info=True)`
- User-facing message: tiếng Việt CÓ DẤU
- Status codes chính xác: 400 (validation), 401 (auth), 403 (permission), 404 (not found), 409 (conflict), 500 (server)

---

## 4. ALEMBIC MIGRATION SAFETY

```bash
# Generate migration
alembic revision --autogenerate -m "add new_field to products"

# REVIEW migration trước khi apply (tự động generate có thể sai!)
# Chú ý: data migrations PHẢI viết tay — autogenerate KHÔNG tạo data ops

# Apply
alembic upgrade head

# Rollback (nếu cần)
alembic downgrade -1
```

**Rules:**
- LUÔN review autogen migration trước khi commit
- NOT NULL column thêm vào table có data → 2-step (add nullable → backfill → set NOT NULL)
- Add index trên large table → `CREATE INDEX CONCURRENTLY` (PostgreSQL)
- Drop column → 2-step (deploy code không dùng → drop column ở migration sau)
- Test migration trên staging clone DB trước production

---

## 5. AI INTEGRATION (9router pattern)

```python
# ai_gateway.py — multi-provider fallback
class AIGateway:
    async def chat_completion(self, messages, **kwargs):
        # Try Groq first (free, fast)
        try:
            return await self._call_groq(messages, **kwargs)
        except RateLimitError:
            pass

        # Fallback Gemini
        try:
            return await self._call_gemini(messages, **kwargs)
        except RateLimitError:
            pass

        # Fallback DeepSeek
        return await self._call_deepseek(messages, **kwargs)
```

**Rules:**
- KHÔNG gọi trực tiếp 1 AI provider trong service code
- Luôn qua gateway (fallback + cache + log)
- Log usage vào `ai_usage_logs` (shop_id, feature, tokens, cost, provider)
- Rate limit theo subscription tier (free: 10/day, starter: 100, pro: 1000)
- Parse JSON response defensively (`_parse_json_from_response()` với try/except)

---

## 6. CELERY BACKGROUND TASKS

```python
# tasks/email_tasks.py
@celery_app.task(bind=True, max_retries=3)
def send_order_email_task(self, order_id: int):
    try:
        # email logic
        ...
    except SMTPException as exc:
        raise self.retry(exc=exc, countdown=60 * (self.request.retries + 1))
```

**Rules:**
- Đừng làm những thứ này TRONG request — dùng Celery:
  - Email sending (smtplib blocks)
  - AI generation (1-30s latency)
  - Excel export (memory heavy)
  - Analytics aggregation
- Retry với exponential backoff
- Idempotent task design (chạy 2 lần không tạo 2 emails)

---

## 7. ANTI-PATTERNS — KHÔNG ĐƯỢC LÀM

| ✗ Sai | ✓ Đúng | Lý do |
|------|--------|-------|
| `float` cho tiền | `Decimal` / `Numeric(14,2)` | Sai số tích lũy |
| Query không có shop_id | Luôn filter | Lộ data shop khác |
| Nhảy order status | VALID_TRANSITIONS | Data inconsistent |
| `stock -= n` rồi commit | Atomic UPDATE với check | Race condition |
| `requests.get()` | `httpx.AsyncClient()` | Block event loop |
| Gọi AI provider trực tiếp | Qua AIGateway | Không có fallback/cache |
| `lazy="select"` mặc định | `selectinload` explicit | N+1 queries silent |
| Hardcode secret | `settings` | Security |
| `try/except: pass` | Log + raise | Nuốt bug |
| Return 403 cho not-found | Return 404 | Lộ existence |
| Lưu giá trực tiếp OrderItem | Snapshot price tại thời điểm | Giá đổi = sai lịch sử |
| Email/SMS trong request | Celery task | Request timeout |
| Migration autogen không review | Review trước apply | Generated SQL có thể sai |

---

## 8. TỰ KIỂM TRA SAU KHI VIẾT

```
□ python -m py_compile <file.py> pass?
□ Mọi query có shop_id filter?
□ Tiền dùng Decimal, KHÔNG float?
□ async/await đúng (không có sync trong async)?
□ Order status transition validate?
□ Inventory atomic update?
□ Endpoint có Depends(get_current_user)?
□ Storefront public API không lộ cost_price/internal_note?
□ Error message tiếng Việt CÓ DẤU?
□ AI gọi qua gateway (có fallback)?
□ Background task qua Celery (không trong request)?
□ Migration đã review (không autogen blind)?
```

**Bất kỳ ✗ → fix trước khi commit.**

---

## 9. REFERENCE FILES

| File | Khi nào đọc |
|------|-------------|
| `references/checklist.md` | Trước khi commit — full audit checklist |
| `references/migration-recipes.md` | Khi viết Alembic migration phức tạp (NOT NULL backfill, index concurrently, data migration) |

---

## 10. PROJECT-SPECIFIC NOTES

### Commerce Platform (60K+ lines)

- Backend: `backend/app/`
- Models: 23 (Shop, Product, Order, Customer, ...)
- Endpoints: 29 routers, 90+ endpoints
- Services: 35 (order_service, ai_service, payment_service, ...)
- Port: **8001** (tránh conflict với Dynamic Pricing port 8000)
- Production: Railway Singapore

### Common imports

```python
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, delete, func
from sqlalchemy.orm import selectinload, joinedload
from decimal import Decimal
from datetime import datetime, timezone
import httpx

from app.core.database import get_db
from app.core.security import get_current_user
from app.core.permissions import get_current_shop, require_role
from app.models import Shop, Product, Order, Customer
from app.schemas.product import ProductCreate, ProductResponse
```
