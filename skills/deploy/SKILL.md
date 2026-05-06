---
name: deploy
description: >
  Auto-trigger khi: "deploy", "push to production", "Railway", "Vercel", "Render",
  "Heroku", "VPS", "Hetzner", "Fly.io", "production environment", "env vars", "environment variables",
  ".env", "Dockerfile", "docker-compose", "CI/CD", "GitHub Actions", "port", "CORS production",
  "DATABASE_URL production", "build failed", "deployment failed", "502 Bad Gateway",
  "cold start", "health check", "rollback".
  Rule: KHÔNG deploy khi build fail local. KHÔNG hardcode secrets. Pre-deploy checklist mandatory.
---

# Deploy Skill — Production Deployment Patterns

> **Triết lý:** If it doesn't work locally, it won't work in production. Local build pass + env check + migration ready = minimum bar before touching production.
> **Source:** distilled từ Commerce Platform production patterns (Railway + Vercel + Neon).

---

## 1. AUTO-TRIGGER

```
DÙNG khi:
  ✓ User nói: deploy, release, ship, push to production, go live
  ✓ User mention platform: Railway, Vercel, Render, Heroku, Fly.io, Hetzner, VPS
  ✓ User mention artifact: Dockerfile, docker-compose.yml, .env, vercel.json
  ✓ User mention problem: "build failed", "deployment failed", "502", "cold start", "rollback"
  ✓ User mention config: DATABASE_URL, CORS production, environment variables, port conflict
  ✓ User nói: "CI/CD", "GitHub Actions", "health check", "env vars"

KHÔNG dùng khi:
  ✗ Chỉ local dev setup (dùng feature-dev skill)
  ✗ Code review (dùng code-review skill)
  ✗ Database schema design (dùng backend-fastapi skill)
```

---

## 2. Deploy Philosophy

**Nguyên tắc cốt lõi:**

```
LOCAL FIRST. ALWAYS.

Trước khi deploy bất cứ thứ gì:
  □ npm run build (hoặc tsc --noEmit) PASS
  □ python -m py_compile main.py PASS
  □ Alembic migration đã commit
  □ .env.example cập nhật
  □ CORS origins updated
  □ Health check endpoint hoạt động

"Works on my machine" không phải excuse. Fix local trước.
```

**Deploy = 3 gates:**

```
GATE 1: LOCAL BUILD PASS
  Backend: python -c "from app.api.v1 import api_router" + py_compile
  Admin:   cd web-admin && npm run build
  Store:   cd web-storefront && npm run build
  → Tất cả pass → mới được sang gate 2

GATE 2: ENV & CONFIG CHECK
  □ Tất cả env vars trong dashboard (Railway/Vercel)
  □ CORS_ORIGINS include production frontend URLs
  □ DATABASE_URL trỏ production (KHÔNG local)
  □ Secret keys là production values (không test keys)

GATE 3: MIGRATION READY
  □ alembic upgrade head chạy được
  □ Migration không phá data hiện tại
  □ Backup taken nếu migration có DROP/ALTER COLUMN
```

---

## 3. Environment Variables Rules

**NEVER hardcode. ALWAYS via env vars.**

```python
# SAI — hardcode secret
SECRET_KEY = "my-secret-key-123"
DATABASE_URL = "postgresql://user:pass@localhost/db"
GROQ_API_KEY = "gsk_abc123"

# ĐÚNG — Pydantic Settings pattern
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    SECRET_KEY: str
    DATABASE_URL: str
    REDIS_URL: str = "redis://localhost:6379"
    GROQ_API_KEY: str = ""
    GEMINI_API_KEY: str = ""
    CORS_ORIGINS: list[str] = ["http://localhost:3001"]

    model_config = SettingsConfig(env_file=".env")

settings = Settings()
```

**`.env.example` — document EVERYTHING:**

```bash
# Core
SECRET_KEY=your-secret-key-here-min-32-chars
DATABASE_URL=postgresql+asyncpg://user:pass@host:5432/dbname
DATABASE_URL_SYNC=postgresql://user:pass@host:5432/dbname

# Cache
REDIS_URL=redis://localhost:6379

# AI providers
GROQ_API_KEY=gsk_...
GEMINI_API_KEY=AIza...
DEEPSEEK_API_KEY=sk-...

# Storage
CLOUDINARY_CLOUD_NAME=your-cloud
CLOUDINARY_API_KEY=your-key
CLOUDINARY_API_SECRET=your-secret

# Payments
VNPAY_TMN_CODE=your-tmn
VNPAY_HASH_SECRET=your-secret
MOMO_PARTNER_CODE=your-code
MOMO_ACCESS_KEY=your-key
MOMO_SECRET_KEY=your-secret

# Shipping
GHN_TOKEN=your-token
GHN_SHOP_ID=your-shop-id

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your@email.com
SMTP_PASS=your-app-password

# CORS (comma-separated)
CORS_ORIGINS=https://sonhai-admin.vercel.app,https://sonhai-store.vercel.app
```

**Secrets rotation strategy:**

```
Khi nào rotate secrets:
  □ Developer rời team
  □ Suspected leak (check git history: git log --all -p | grep "SECRET")
  □ Platform breach notification
  □ Quarterly rotation cho payment secrets

Cách rotate không downtime:
  1. Tạo secret mới trong platform dashboard
  2. Update code để accept BOTH old + new (grace period)
  3. Deploy
  4. Revoke old secret
  5. Remove old secret fallback code
  6. Deploy lại
```

---

## 4. Port Management

**Commerce Platform port map (KHÔNG conflict):**

```
Dynamic Pricing (project khác):  8000  ← KHÔNG ĐƯỢC DÙNG
Commerce Backend (FastAPI):       8001
Commerce Admin (React):           3001
Commerce Storefront (React):      3002
MONII Backend:                    8002
MONII Frontend:                   3003
Vite default (tránh dùng):        5173
```

**Lý do quan trọng:**

```bash
# Chạy local đúng port
uvicorn main:app --reload --port 8001
npm run dev -- --port 3001   # web-admin
npm run dev -- --port 3002   # web-storefront

# Kiểm tra port có đang dùng không
lsof -i :8001
lsof -i :3001

# Kill process đang giữ port
kill -9 $(lsof -t -i:8001)
```

**Production không có port conflict** — Railway/Vercel tự assign từ `$PORT` env var:

```python
# Backend: dùng $PORT (Railway set tự động)
CMD = ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT}"]
```

---

## 5. Railway Deployment

**Setup lần đầu:**

```
1. railway.app → New Project → Deploy from GitHub
2. Connect repo → chọn branch main
3. Set Root Directory: backend
4. Add PostgreSQL plugin: + New → Database → Add PostgreSQL
5. Add Redis plugin: + New → Database → Add Redis
6. Set env vars (Variables tab):
   - DATABASE_URL → ${{Postgres.DATABASE_URL}} (internal, Railway injects)
   - DATABASE_URL_SYNC → dùng external URL cho Alembic
   - SECRET_KEY → generate: openssl rand -hex 32
   - REDIS_URL → ${{Redis.REDIS_URL}}
   - CORS_ORIGINS → https://sonhai-admin.vercel.app,https://sonhai-store.vercel.app
   - + tất cả AI keys, payment keys
7. Settings → Health Check Path: /health
8. Settings → Restart Policy: Always
```

**Dockerfile pattern cho Railway:**

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Railway injects $PORT
CMD sh -c "uvicorn main:app --host 0.0.0.0 --port ${PORT}"
```

**DATABASE_URL — internal vs external:**

```bash
# Internal (dùng trong Railway app — nhanh hơn, không tính bandwidth)
DATABASE_URL=postgresql+asyncpg://postgres:pass@postgres.railway.internal:5432/railway

# External (dùng local để chạy Alembic migration hoặc debug)
DATABASE_URL=postgresql+asyncpg://postgres:pass@roundhouse.proxy.rlwy.net:PORT/railway

# asyncpg (async SQLAlchemy) vs psycopg2 (sync Alembic)
# → asyncpg: postgresql+asyncpg://...
# → psycopg2/Alembic: postgresql://... (KHÔNG có +asyncpg)
# Set DATABASE_URL_SYNC riêng cho Alembic
```

**Connection pool settings cho Railway Postgres:**

```python
engine = create_async_engine(
    settings.DATABASE_URL,
    pool_size=5,
    max_overflow=10,
    pool_recycle=180,
    pool_pre_ping=True,
    connect_args={
        "statement_cache_size": 0,  # BẮT BUỘC cho Railway connection pooler
        "server_settings": {"application_name": "commerce-backend"},
    },
)
```

**Rollback Railway deployment:**

```
Railway dashboard → Deployments tab
→ Click deployment muốn rollback về
→ "Redeploy" button
→ Confirm
→ Previous deployment active trong ~30s
```

**Auto-deploy from GitHub:**

```
Railway tự deploy khi push to connected branch.
Để deploy manually: railway up (CLI)
Để deploy specific commit: không support — dùng git push với commit đó là HEAD
```

---

## 6. Vercel Deployment

**Setup lần đầu:**

```
1. vercel.com → New Project → Import Git Repository
2. Framework Preset: Vite
3. Root Directory: web-admin (hoặc web-storefront)
4. Build Command: npm run build
5. Output Directory: dist
6. Set env vars: VITE_API_URL=https://your-railway-backend.up.railway.app
7. Deploy
```

**`vercel.json` — bắt buộc cho SPA + API proxy:**

```json
{
  "rewrites": [
    {
      "source": "/api/:path*",
      "destination": "https://commerce-platform-production-f1e1.up.railway.app/api/:path*"
    },
    {
      "source": "/((?!api/).*)",
      "destination": "/index.html"
    }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" }
      ]
    }
  ]
}
```

**Deploy commands:**

```bash
# Preview deploy (không affect production)
npx vercel

# Production deploy
npx vercel --prod --yes

# Assign custom alias sau khi deploy
npx vercel alias <deployment-url> sonhai-admin.vercel.app
```

**Deployment Protection — phải disable nếu muốn public:**

```
Vercel Dashboard → Settings → Deployment Protection
→ Vercel Authentication: Disabled
→ Password Protection: Disabled
→ Save
```

**Env vars tại Vercel:**

```bash
# Không dùng .env trong Vercel — set trong dashboard hoặc CLI
vercel env add VITE_API_URL production
vercel env add VITE_API_URL preview

# Pull về local để debug
vercel env pull .env.local
```

---

## 7. Database Migrations on Deploy

**LUÔN LUÔN: migration TRƯỚC deploy, KHÔNG sau.**

```
Thứ tự bắt buộc:
  1. Deploy migration (alembic upgrade head)
  2. Verify migration thành công
  3. Deploy new application code
  4. Verify health check pass

Sai:
  1. Deploy new code  ← code mới expect column chưa có → 500 errors
  2. Run migration
```

**Tạo migration đúng cách:**

```bash
# Generate migration từ model changes
alembic revision --autogenerate -m "add shipping_tracking to orders"

# Kiểm tra migration file TRƯỚC khi commit
cat alembic/versions/<generated_file>.py

# Test locally
alembic upgrade head
alembic downgrade -1  # verify rollback works
alembic upgrade head  # go back up

# Commit migration file
git add alembic/versions/<file>.py
git commit -m "migration: add shipping_tracking to orders"
```

**2-step NOT NULL column pattern (KHÔNG phá production):**

```python
# SAIIII — phá migration nếu table có data
op.add_column('products', sa.Column('weight_kg', sa.Numeric(8,2), nullable=False))

# ĐÚNG — 2 bước
# Step 1: add nullable, với server_default
op.add_column('products', sa.Column('weight_kg', sa.Numeric(8,2), nullable=True, server_default='0'))
# Step 2 (migration riêng, sau khi deploy step 1):
op.alter_column('products', 'weight_kg', nullable=False)
op.alter_column('products', 'weight_kg', server_default=None)
```

**Chạy migration on Railway:**

```bash
# Cách 1: Railway CLI (recommended)
railway run alembic upgrade head

# Cách 2: Local với external DATABASE_URL
DATABASE_URL_SYNC=postgresql://user:pass@external-host:port/db alembic upgrade head

# Cách 3: Trong Dockerfile startup (rủi ro — nếu fail thì app không start)
CMD sh -c "alembic upgrade head && uvicorn main:app --host 0.0.0.0 --port ${PORT}"
```

---

## 8. CORS in Production

**Whitelist explicit origins. KHÔNG dùng `*` cho production.**

```python
# SAI — accept mọi origin
app.add_middleware(CORSMiddleware, allow_origins=["*"])

# ĐÚNG — explicit whitelist
from app.core.config import settings

origins = [origin.strip() for origin in settings.CORS_ORIGINS.split(",")]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Env var:**

```bash
# KHÔNG có trailing slash — common mistake!
CORS_ORIGINS=https://sonhai-admin.vercel.app,https://sonhai-store.vercel.app

# SAI — trailing slash gây CORS fail
CORS_ORIGINS=https://sonhai-admin.vercel.app/,https://sonhai-store.vercel.app/
```

**Checklist CORS:**

```
□ Admin frontend URL (web-admin Vercel deployment)
□ Storefront frontend URL (web-storefront Vercel deployment)
□ Mobile app (nếu có — thường không cần CORS cho native)
□ localhost:3001, localhost:3002 cho local dev (dev env only)
□ Staging URL nếu có (staging.sonhai-admin.vercel.app)
```

---

## 9. Health Checks

**Implement `/health` endpoint — Railway dùng nó để biết app ready:**

```python
from fastapi import APIRouter
from sqlalchemy import text

router = APIRouter()

@router.get("/health")
async def health_check(db: AsyncSession = Depends(get_db)):
    """Railway health check. Must return 200 for app to receive traffic."""
    try:
        # Check DB connectivity
        await db.execute(text("SELECT 1"))

        # Check Redis connectivity (optional)
        # await redis.ping()

        return {
            "status": "healthy",
            "db": "connected",
            "timestamp": datetime.utcnow().isoformat(),
        }
    except Exception as e:
        raise HTTPException(status_code=503, detail=f"Unhealthy: {str(e)}")


@router.get("/health/detailed")
async def health_detailed():
    """Detailed metrics — không expose tới public, dùng Railway internal."""
    return {
        "version": settings.APP_VERSION,
        "db_pool_size": engine.pool.size(),
        "db_checked_out": engine.pool.checkedout(),
        ...
    }
```

**Railway health check config:**

```
Railway Dashboard → Service Settings → Health Check
  Path: /health
  Timeout: 30s (đủ để DB connection khởi động)
  
Railway chờ 200 response trước khi route traffic sang deployment mới.
Nếu không config → Railway deploy ngay (risky khi DB chưa ready).
```

---

## 10. Zero-Downtime Deploy Pattern

**Railway làm gì khi deploy:**

```
1. Build new Docker image
2. Start new container (chạy song song với old)
3. Health check new container (GET /health → expect 200)
4. Khi new container healthy → route traffic sang
5. Send SIGTERM to old container (graceful shutdown)
6. Old container có 30s để finish in-flight requests
7. Old container killed
```

**SIGTERM handler — drain connections gracefully:**

```python
import signal
import asyncio

shutdown_event = asyncio.Event()

def handle_sigterm(signum, frame):
    """Railway sends SIGTERM before killing container."""
    shutdown_event.set()

signal.signal(signal.SIGTERM, handle_sigterm)

@app.on_event("shutdown")
async def shutdown():
    """Wait for in-flight requests before closing DB connections."""
    await asyncio.sleep(2)  # drain in-flight requests
    await engine.dispose()
```

**Connection draining:**

```python
# uvicorn timeout-graceful-shutdown (seconds)
# Set trong Railway: uvicorn --timeout-graceful-shutdown 30
CMD sh -c "uvicorn main:app --host 0.0.0.0 --port ${PORT} --timeout-graceful-shutdown 30"
```

---

## 11. Rollback

**Khi nào rollback ngay:**

```
□ Error rate > 5% sau deploy (Railway logs → filter 5xx)
□ Health check failing (app restart loop)
□ Auth endpoints returning 500
□ Payment endpoints broken (rollback NGAY, không chờ)
□ DB migration gây data corruption
```

**Rollback Railway (application):**

```
Railway Dashboard → Deployments tab
→ Tìm deployment trước đó (màu xanh = active)
→ Click previous successful deployment
→ "Redeploy" button
→ ~30s để route traffic sang
```

**Rollback DB migration:**

```bash
# Xem current revision
alembic current

# Xem history
alembic history --verbose

# Downgrade 1 step
alembic downgrade -1

# Downgrade về specific revision
alembic downgrade abc123de

# KHÔNG thể rollback nếu migration drop column + data đã mất
# → Đó là lý do phải backup trước mọi destructive migration
```

**Backup trước destructive migration:**

```bash
# Railway PostgreSQL backup
railway run pg_dump -Fc > backup_$(date +%Y%m%d_%H%M%S).dump

# Restore nếu cần
railway run pg_restore -d $DATABASE_URL backup_file.dump
```

---

## 12. Post-Deploy Verification

**Smoke test ngay sau deploy — không chờ user report:**

```
□ Open production URL → page load không trắng
□ Login với test account → success
□ List products → data hiện
□ Create test product → tạo được, hiện trong list
□ Create test order → tạo được
□ Health check URL trả 200: curl https://backend-url/health
□ Check Railway logs: không có ERROR 500
□ Check Vercel function logs: không có exception
```

**Monitor sau deploy:**

```bash
# Watch Railway logs real-time
railway logs --follow

# Filter chỉ errors
railway logs | grep -E "ERROR|Exception|Traceback"

# Check 5xx rate (Railway Metrics tab → HTTP → Status Codes)
# Nếu 5xx > 1% → investigate ngay
```

**Alert nếu 5xx spike:**

```python
# Middleware log 5xx với đủ context để debug
@app.middleware("http")
async def log_5xx(request: Request, call_next):
    response = await call_next(request)
    if response.status_code >= 500:
        logger.error(
            f"5xx: {request.method} {request.url.path} → {response.status_code}",
            extra={"shop_id": request.state.shop_id if hasattr(request.state, "shop_id") else None}
        )
    return response
```

---

## References

- `references/railway-vercel.md` — Railway + Vercel setup chi tiết
- `references/pre-deploy-checklist.md` — Checklist đầy đủ trước mỗi deploy
- Commerce Platform CLAUDE.md → PRODUCTION DEPLOYMENT section
- Railway docs: docs.railway.app
- Vercel docs: vercel.com/docs
