# Pre-Deploy Checklist

> Mandatory trước mọi deploy lên production.
> Copy → paste → check từng ô. Không skip. Không "chắc là ổn".
> Nếu bất kỳ ô nào fail → FIX trước, không deploy.

---

## Code Quality

**Backend (FastAPI/Python)**

- [ ] `python -m py_compile backend/main.py` pass — không syntax error
- [ ] `python -c "from app.api.v1 import api_router"` pass — imports OK
- [ ] Không còn `print()` debug (kiểm tra: `grep -r "^print(" backend/app/`)
- [ ] Không còn `# TODO:` hoặc `# FIXME:` trong code sẽ deploy
- [ ] Không có `requests.get()` — phải là `httpx.AsyncClient()` (kiểm tra: `grep -r "import requests" backend/`)
- [ ] Không có `float` cho tính tiền — phải là `Decimal` (kiểm tra: `grep -rn "float(" backend/app/services/`)
- [ ] Mọi query SELECT/UPDATE/DELETE có filter `shop_id` (multi-tenant)
- [ ] Mọi admin endpoint có `Depends(get_current_user)`
- [ ] Error messages tiếng Việt có dấu đầy đủ

**Frontend (React/TypeScript)**

- [ ] `cd web-admin && npm run build` pass — không TypeScript error, không build error
- [ ] `cd web-storefront && npm run build` pass
- [ ] Không còn `console.log()` debug (kiểm tra: `grep -r "console\.log" web-admin/src/`)
- [ ] Không hardcode `localhost` URLs trong source (kiểm tra: `grep -r "localhost:8001" web-admin/src/`)
- [ ] Không hardcode secrets hoặc API keys trong JavaScript
- [ ] `VITE_API_URL` và các VITE_ vars dùng env var, không hardcode
- [ ] Loading / Empty / Error states có đủ (không trang trắng)
- [ ] Text tiếng Việt có dấu đầy đủ trong i18n files

---

## Environment Variables

**Local `.env` (không commit)**

- [ ] `.env` có trong `.gitignore` — kiểm tra: `grep "^\.env$" .gitignore`
- [ ] `git status` không show `.env` là staged file
- [ ] `git log --all -- .env` không có commit nào contain `.env`

**`.env.example` (phải commit)**

- [ ] `.env.example` updated với mọi env var mới thêm
- [ ] Values trong `.env.example` là placeholder, không phải real credentials
- [ ] `.env.example` committed: `git status backend/.env.example` = clean

**Railway Dashboard**

- [ ] `DATABASE_URL` → trỏ Railway PostgreSQL internal URL (không phải localhost)
- [ ] `DATABASE_URL_SYNC` → Railway PostgreSQL (psycopg2 format, không có +asyncpg)
- [ ] `SECRET_KEY` → đủ dài (min 32 chars), không phải test key
- [ ] `REDIS_URL` → Railway Redis internal URL
- [ ] `CORS_ORIGINS` → include tất cả production frontend URLs (KHÔNG trailing slash)
- [ ] `ENVIRONMENT=production` → không phải `development`
- [ ] `DEBUG=false` → tắt debug mode
- [ ] AI keys (GROQ_API_KEY, GEMINI_API_KEY, DEEPSEEK_API_KEY) → production keys
- [ ] Payment keys (VNPAY_HASH_SECRET, MOMO_SECRET_KEY) → production credentials
- [ ] Storage keys (CLOUDINARY_*) → production credentials
- [ ] Shipping keys (GHN_TOKEN, GHN_SHOP_ID) → production credentials
- [ ] Email config (SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS) → working SMTP

**Vercel Dashboard**

- [ ] `VITE_API_URL` → Railway production backend URL (https://, không phải localhost)
- [ ] Scope đúng: Production (không phải chỉ Preview)

---

## Database

**Migration**

- [ ] `alembic revision --autogenerate` đã chạy nếu có model changes
- [ ] Migration file committed: `git status alembic/versions/` = clean
- [ ] Migration không có `op.drop_column()` hoặc `op.drop_table()` mà không backup
- [ ] Migration không add NOT NULL column mà không có default value
- [ ] `alembic upgrade head` đã test locally (hoặc trên staging)
- [ ] `alembic downgrade -1` + `alembic upgrade head` cycle đã test (rollback works)

**Backup (bắt buộc nếu migration có DROP hoặc ALTER COLUMN)**

- [ ] Backup taken: `railway run pg_dump -Fc > backup_$(date +%Y%m%d_%H%M%S).dump`
- [ ] Backup file lưu ở nơi an toàn (không trong repo)
- [ ] Test restore từ backup (ít nhất 1 lần mỗi tháng)

**Thứ tự deploy**

- [ ] Plan: migration TRƯỚC, app code SAU
- [ ] Migration step: `railway run alembic upgrade head`
- [ ] Verify migration: `railway run alembic current` → show head revision
- [ ] Deploy app code: push to GitHub → Railway auto-deploy

---

## API & Backend

**Health Check**

- [ ] `/health` endpoint trả 200 với `{"status": "healthy"}`
- [ ] Health check config trong Railway: Path=/health, Timeout=30s
- [ ] `curl https://your-backend.up.railway.app/health` → 200

**Auth**

- [ ] `POST /api/v1/auth/login` test với test credentials → trả JWT
- [ ] JWT có đủ claims: user_id, shop_id, exp
- [ ] Token expiry phù hợp (không quá ngắn — frustrating, không quá dài — security risk)

**CORS**

- [ ] CORS_ORIGINS trong Railway include: `https://sonhai-admin.vercel.app`
- [ ] CORS_ORIGINS include: `https://sonhai-store.vercel.app`
- [ ] KHÔNG có trailing slash trong URLs
- [ ] Test: `curl -H "Origin: https://sonhai-admin.vercel.app" https://backend/api/v1/health` → có `Access-Control-Allow-Origin` header

**Rate Limiting**

- [ ] Rate limit config không quá strict cho production traffic
- [ ] Auth endpoints: 10/min (OK)
- [ ] Public API: 60/min (OK)
- [ ] Authenticated: 120/min (OK)

---

## Frontend

**Build Output**

- [ ] `web-admin/dist/` có `index.html` + `assets/` folder
- [ ] `web-storefront/dist/` có `index.html` + `assets/` folder
- [ ] Build size reasonable (< 2MB gzipped — nếu lớn hơn, check bundle analyzer)

**API Endpoints**

- [ ] `src/api/*.ts` files dùng `VITE_API_URL` env var (không hardcode URL)
- [ ] Axios baseURL: `import.meta.env.VITE_API_URL`
- [ ] Tất cả API calls có error handling (không crash silently)

**vercel.json**

- [ ] SPA rewrite có: `"source": "/((?!api/).*)"` → `"/index.html"`
- [ ] API proxy có nếu cần (hoặc frontend gọi trực tiếp Railway URL)
- [ ] Security headers present

**PWA (nếu có)**

- [ ] `manifest.json` → `start_url` trỏ production domain, không localhost
- [ ] `scope` trong manifest đúng với production domain
- [ ] Service worker cache version đã tăng (để user nhận bản mới)

**Localization**

- [ ] `vi.json` có tất cả translation keys mới thêm
- [ ] `en.json` có tất cả translation keys mới thêm
- [ ] Không có `undefined` key (kiểm tra với `t('missing.key')` in browser console)

---

## Security

- [ ] Không có hardcoded credentials trong source code (cả test/dev hardcodes)
- [ ] Payment endpoints verify signatures (VNPay HMAC, MoMo HMAC)
- [ ] Order endpoints validate status transitions (VALID_TRANSITIONS)
- [ ] Stock updates dùng atomic SQL (không read-then-write)
- [ ] Admin endpoints không leak cost_price, internal notes ra public API
- [ ] `X-Frame-Options: DENY` header present
- [ ] `Content-Security-Policy` header present
- [ ] HTTPS only (Railway + Vercel đều enforce HTTPS)

---

## Post-Deploy Verification

**Ngay sau deploy (< 5 phút)**

- [ ] Mở production URL trong browser → page load (không trắng, không 404)
- [ ] Login: vào trang login, nhập credentials → redirect vào dashboard
- [ ] Dashboard load: stats hiện, không có "Error loading data"
- [ ] Products list: hiện danh sách (hoặc empty state nếu chưa có)
- [ ] Health check: `curl https://backend-url/health` → `{"status": "healthy"}`
- [ ] Railway logs: không có `ERROR` hoặc `Exception` trong 2 phút đầu
- [ ] Vercel deployment: status = "Ready" (không phải "Error")

**Core User Flows (10 phút)**

- [ ] Tạo sản phẩm mới → save → hiện trong list
- [ ] Tạo đơn hàng từ admin → status = pending
- [ ] Chuyển đơn hàng: pending → confirmed → packing
- [ ] Storefront: mở shop URL → sản phẩm hiện
- [ ] Storefront: add to cart → checkout form → submit (COD)
- [ ] Notification bell: click → dropdown mở

**Monitoring (30 phút sau deploy)**

- [ ] Railway Metrics → HTTP Status Codes → 5xx < 1%
- [ ] Railway Metrics → Response Time → p99 < 2s
- [ ] Railway logs: không có error spike
- [ ] Nếu có Sentry: error rate không tăng

---

## Rollback Decision Tree

```
Sau deploy, có vấn đề?
  │
  ├── 5xx rate > 5%?
  │     → ROLLBACK NGAY (Railway Deployments → Redeploy previous)
  │
  ├── Login broken?
  │     → ROLLBACK NGAY
  │
  ├── Payment endpoints broken?
  │     → ROLLBACK NGAY (mất tiền là mất tất)
  │
  ├── DB migration broke data?
  │     → ROLLBACK NGAY + restore backup
  │
  ├── Một feature nhỏ bị lỗi, core flow ok?
  │     → Investigate, fix forward (không cần rollback)
  │
  └── Chỉ UI glitch nhỏ?
        → Fix forward với hotfix deploy
```

---

## Quick Commands Reference

```bash
# === TRƯỚC KHI DEPLOY ===

# Build check
cd web-admin && npm run build && echo "Admin build OK"
cd web-storefront && npm run build && echo "Store build OK"
python -m py_compile backend/main.py && echo "Backend syntax OK"

# Tìm debug leftovers
grep -r "console\.log" web-admin/src/ --include="*.ts" --include="*.tsx" | grep -v node_modules
grep -r "^print(" backend/app/ --include="*.py"
grep -r "localhost" web-admin/src/ --include="*.ts" --include="*.tsx" | grep -v ".env"

# Check .env not staged
git status | grep ".env"

# === KHI DEPLOY ===

# Railway migration
railway run alembic upgrade head
railway run alembic current

# Vercel deploy
cd web-admin && vercel --prod --yes
cd web-storefront && vercel --prod --yes

# === SAU KHI DEPLOY ===

# Health check
curl -s https://your-backend.up.railway.app/health | python3 -m json.tool

# Watch logs
railway logs --follow

# Filter errors only
railway logs | grep -E "ERROR|Exception|500|502|503"
```
