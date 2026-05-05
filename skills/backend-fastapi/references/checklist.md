# Pre-Commit Audit Checklist (Backend FastAPI)

Run TRƯỚC khi commit code backend. Mỗi checkbox FAIL = phải fix.

---

## 🔒 SECURITY (P0 — CRITICAL)

```
□ Mọi SELECT/UPDATE/DELETE có .where(Model.shop_id == current_shop.id)?
   Run: grep -rn "select(.*).where" backend/app/services | grep -v "shop_id"

□ KHÔNG có hardcoded secrets (JWT_SECRET, API keys, passwords)?
   Run: grep -rE '(secret|api_key|password)\s*=\s*["'\'']' backend/app | grep -v "settings\."

□ JWT verify trên mọi admin endpoint (Depends(get_current_user))?
   Run: grep -L "get_current_user\|get_current_shop" backend/app/api/v1/endpoints/*.py

□ Storefront public API KHÔNG trả cost_price/internal_note?
   Check schemas/storefront.py — PublicProductResponse exclude sensitive fields

□ SQL injection: KHÔNG dùng f-string SQL?
   Run: grep -rn 'execute(f"' backend/app/  → MUST use parameterized queries

□ Webhook signature verify (VNPay/MoMo HMAC)?
   Check payment_service.py — verify_signature() function called BEFORE update payment_status

□ CORS whitelist cụ thể, KHÔNG `*`?
   Check main.py CORSMiddleware allow_origins

□ Rate limiting trên auth endpoints (login/register)?
   Check decorator @limiter.limit("10/minute")
```

---

## 💰 MONEY PRECISION (P0)

```
□ Mọi cột tiền là Numeric(14, 2)?
   Run: grep -rn "Numeric\|Decimal\|Float" backend/app/models/*.py

□ Python: dùng Decimal, KHÔNG float?
   Run: grep -rEn "(price|amount|total|fee|discount)\s*=\s*[0-9]+\.[0-9]" backend/app/

□ VNPay amount: .quantize(Decimal("1")) trước int()?
   Check payment_service.py: int(order.total.quantize(Decimal("1")) * 100)

□ Subtotal = sum(item.price * item.quantity) — TẤT CẢ Decimal?
   Total = subtotal − discount + shipping

□ Tax/discount: Decimal arithmetic, NEVER float * Decimal?
```

---

## ⚡ ASYNC CORRECTNESS (P0)

```
□ Endpoint là `async def`?
   Run: grep -rn "^def " backend/app/api/v1/endpoints/*.py | grep -v "async def"

□ KHÔNG có `requests` library import?
   Run: grep -rn "^import requests\|^from requests" backend/app/

□ HTTP calls dùng httpx.AsyncClient?
   Run: grep -rn "httpx" backend/app/services/ — should appear

□ SMTP send qua run_in_executor (block-safe)?
   Check notification_service.py: loop.run_in_executor(None, smtplib_send, ...)

□ DB session là AsyncSession?
   Run: grep -rn "Session()" backend/app/  → should be AsyncSession only
```

---

## 🗄 DATA INTEGRITY (P0)

```
□ Inventory deduct qua atomic SQL (UPDATE WHERE stock >= n)?
   Run: grep -rn "stock\s*-=\|stock\s*+=" backend/app/  → ANY match = bug
   Should use: update(...).where(stock >= n).values(stock=stock - n).returning(stock)

□ Order status change qua validate_transition()?
   Run: grep -rn "order.status\s*=\s*" backend/app/  → must be after validate

□ OrderItem snapshot price/name (KHÔNG join product khi hiển thị)?
   Check models/order.py — OrderItem có product_name, variant_name, price columns

□ Foreign key cascade rules đúng?
   Order → CASCADE delete OrderItem (OK)
   Product → SET NULL category_id (KHÔNG cascade vì products không nên xoá category)
```

---

## 🔍 PERFORMANCE (P1)

```
□ KHÔNG có N+1 queries (lazy="select" default)?
   Run: grep -rn 'lazy="select"\|lazy="dynamic"' backend/app/models/  → bad
   Should use: lazy="noload" + explicit selectinload() ở endpoint

□ Endpoint trả relationship → có selectinload()?
   Pattern: select(Order).options(selectinload(Order.items)).where(...)

□ Pagination có total count optimized?
   Use select(func.count()).select_from(query.subquery()) — NOT len(all_results)

□ Index trên cột filter nhiều (shop_id, created_at, status)?
   Check models/*.py for index=True or composite Index('ix_...')

□ Connection pool đủ size?
   Check core/database.py: pool_size=5, max_overflow=10, pool_recycle=180
```

---

## 🔗 RELATIONSHIPS & MIGRATIONS

```
□ Mọi model (trừ User, Shop) có shop_id FK?
   Run: grep -rL "shop_id" backend/app/models/*.py | grep -v "user.py\|shop.py\|base.py"

□ Mọi model có created_at, updated_at (auto)?
   Check inheritance từ TimestampMixin hoặc tự define

□ Alembic migration đã review (KHÔNG blind autogen)?
   Run: cat alembic/versions/<latest>.py — verify ops match intent

□ NOT NULL column thêm vào table có data → 2-step?
   Step 1: add nullable + backfill
   Step 2: ALTER COLUMN SET NOT NULL

□ Index thêm trên large table → CREATE INDEX CONCURRENTLY?
   Edit migration: op.create_index(..., postgresql_concurrently=True)
```

---

## 🧪 ERROR HANDLING

```
□ KHÔNG có try/except: pass?
   Run: grep -rn "except.*:\s*pass" backend/app/  → fix log + raise

□ Error message tiếng Việt CÓ DẤU?
   Run: grep -rE "raise HTTPException\(.*detail=" backend/app/ | grep -vE "[àáảãạăắằẳẵặâấầẩẫậèéẻẽẹêếềểễệìíỉĩịòóỏõọôốồổỗộơớờởỡợùúủũụưứừửữựỳýỷỹỵđ]"

□ HTTP status codes đúng?
   400 = validation, 401 = no auth, 403 = no permission, 404 = not found, 409 = conflict

□ Logger configured đúng (KHÔNG print)?
   Run: grep -rn "print(" backend/app/  → fix dùng logger.info/warning/error

□ Production exception handler trả clean JSON (KHÔNG traceback)?
   Check main.py @app.exception_handler(Exception)
```

---

## 📤 RESPONSE QUALITY

```
□ Pydantic schema validate input/output?
   Mọi endpoint có response_model=

□ KHÔNG return DB model trực tiếp (dùng schema)?
   Reason: kiểm soát fields exposed

□ Datetime serialize timezone-aware (UTC)?
   Use: datetime.now(timezone.utc) — NOT datetime.utcnow() (deprecated)

□ Pagination format: {items, total, page, page_size, total_pages}?

□ Empty list return [] không null?
```

---

## 🎯 CELERY TASKS

```
□ Email/SMS/AI generation chạy qua Celery (không trong request)?
   Check: notification_service.py uses .delay() or .apply_async()

□ Task có max_retries với exponential backoff?
   @celery_app.task(bind=True, max_retries=3)
   self.retry(exc=exc, countdown=60 * (self.request.retries + 1))

□ Task idempotent (chạy 2 lần không double effect)?
   Check unique constraint trên log table (e.g., notification_logs.unique_key)
```

---

## 📦 IMPORT HYGIENE

```
□ KHÔNG `from x import *`?
   Run: grep -rn "import \*" backend/app/

□ Imports sorted (isort/ruff convention)?
   Run: ruff check backend/app/ --select I

□ KHÔNG unused imports?
   Run: ruff check backend/app/ --select F401
```

---

## 🚀 DEPLOY READY

```
□ Environment variables documented in .env.example?
□ Dockerfile builds successfully?
   Run: docker build -t test backend/

□ Health endpoint trả OK?
   GET /health → {"status": "ok", "timestamp": "..."}

□ Detailed health (DB, Redis) check passes?
   GET /health/detailed → all services healthy

□ requirements.txt pinned versions (==X.Y.Z, not >=)?
   Reason: reproducible builds
```

---

## QUICK GREP COMMANDS (run cùng lúc)

```bash
# Security audit (1 command)
grep -rn "select\|update\|delete" backend/app/services/*.py | grep -v "shop_id\|current_shop\|.where" | head -20

# Money precision audit
grep -rEn "float|\.0\s|\(price|amount|total\)\s*=\s*[0-9]+\." backend/app/ | head -20

# Async correctness
grep -rn "^def\s" backend/app/api/v1/endpoints/*.py | head -20

# Inventory race conditions
grep -rn "stock\s*[-+]=" backend/app/ && echo "BUG FOUND"

# Vietnamese diacritics audit (error messages)
grep -rE 'detail="[a-zA-Z ]+"' backend/app/ | head -20
```

Nếu mọi command đều CLEAN → safe to commit. Else fix trước.
