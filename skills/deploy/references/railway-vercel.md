# Railway + Vercel Deployment Reference

> Commerce Platform deployment stack: Railway (backend + DB + Redis) + Vercel (2 frontends).
> Đây là guide thực chiến — không phải copy từ docs, là learnings từ production đã chạy thật.

---

## Railway — Backend + Database

### New Project Setup

```
1. railway.app → Login with GitHub
2. New Project → Deploy from GitHub repo
3. Select repo: COMMERCE-PLATFORM
4. Set Root Directory: backend
   (Railway sẽ build từ backend/ folder, KHÔNG phải root)
5. Railway auto-detect Dockerfile nếu có → dùng Dockerfile
   Không có Dockerfile → Nixpacks (thường fail với complex deps → nên có Dockerfile)
6. Add plugins:
   + New → Database → Add PostgreSQL
   + New → Database → Add Redis
```

### Railway Environment Variables (Variables tab)

```bash
# Database — Railway inject từ plugin (reference variable)
DATABASE_URL=${{Postgres.DATABASE_URL}}      # asyncpg format auto
DATABASE_URL_SYNC=${{Postgres.DATABASE_URL}} # nhưng replace asyncpg → psycopg2

# Cách an toàn hơn: set manual với internal hostname
DATABASE_URL=postgresql+asyncpg://postgres:PASSWORD@postgres.railway.internal:5432/railway
DATABASE_URL_SYNC=postgresql://postgres:PASSWORD@postgres.railway.internal:5432/railway

# Core
SECRET_KEY=<openssl rand -hex 32>
ENVIRONMENT=production
DEBUG=false

# Redis
REDIS_URL=${{Redis.REDIS_URL}}

# CORS — KHÔNG có trailing slash
CORS_ORIGINS=https://sonhai-admin.vercel.app,https://sonhai-store.vercel.app

# AI Keys
GROQ_API_KEY=gsk_...
GEMINI_API_KEY=AIza...
DEEPSEEK_API_KEY=sk-...

# Storage
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...

# Payments
VNPAY_TMN_CODE=...
VNPAY_HASH_SECRET=...
MOMO_PARTNER_CODE=...
MOMO_ACCESS_KEY=...
MOMO_SECRET_KEY=...

# Shipping
GHN_TOKEN=...
GHN_SHOP_ID=...

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=...
SMTP_PASS=...
```

### Railway PostgreSQL — asyncpg vs psycopg2

```bash
# asyncpg format (cho SQLAlchemy async + FastAPI)
postgresql+asyncpg://user:pass@host:port/dbname

# psycopg2 format (cho Alembic migrations — sync)
postgresql://user:pass@host:port/dbname
# hoặc explicit:
postgresql+psycopg2://user:pass@host:port/dbname

# KHÔNG dùng asyncpg cho Alembic → hung forever
```

### Railway PostgreSQL — Internal vs External URL

```bash
# Internal (dùng trong Railway service — NHANH HƠN, không tính bandwidth)
host: postgres.railway.internal
port: 5432

# External (dùng local dev, Alembic từ laptop, DB GUI tools)
host: roundhouse.proxy.rlwy.net  # hoặc similar
port: <PORT được assign bởi Railway>
# Lấy từ: Railway Dashboard → Postgres plugin → Connect tab → External URL
```

### Connection Pool Config — BẮT BUỘC cho Railway

```python
engine = create_async_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG,
    pool_size=5,           # Railway free tier: max 10 connections
    max_overflow=10,
    pool_recycle=180,      # recycle trước khi Railway kill idle connection (300s)
    pool_pre_ping=True,    # verify connection còn sống trước khi dùng
    connect_args={
        "statement_cache_size": 0,  # BẮT BUỘC cho pgBouncer/Railway pooler
        # Thiếu cái này → "prepared statement does not exist" error
    },
)
```

### Dockerfile cho Railway

```dockerfile
FROM python:3.11-slim

# Không cần đặt WORKDIR phức tạp
WORKDIR /app

# Install deps trước (Docker layer cache)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source
COPY . .

# Railway set $PORT env var tự động (thường 8080)
# KHÔNG hardcode port
CMD sh -c "uvicorn main:app --host 0.0.0.0 --port ${PORT} --timeout-graceful-shutdown 30"
```

### Health Check Config

```
Railway Dashboard → Service Settings → Health Check
  Path: /health
  Timeout: 30 (seconds)
  Initial Delay: 5 (seconds — chờ app khởi động)

Response phải trả 200 trong timeout:
  {"status": "healthy", "db": "connected"}
  
Nếu không config health check → Railway deploy ngay mà không kiểm tra
→ Traffic bị route vào app chưa ready → 502 errors
```

### Common Railway Errors

```
"Application failed to respond"
  → Health check timeout
  → Fix: Tăng health check timeout, hoặc optimize startup time
  → Check: uvicorn startup logs trong Railway Deployments

"Nixpacks build failed: could not detect Python version"
  → Thêm Dockerfile vào root (hoặc backend/)
  → Hoặc thêm .python-version file: echo "3.11" > .python-version

"FATAL: prepared statement 'xxx' does not exist"
  → Thiếu statement_cache_size=0 trong connect_args
  → Fix: thêm connect_args={"statement_cache_size": 0}

"connection pool timeout" (sau giờ cao điểm)
  → pool_size quá nhỏ
  → Fix: tăng pool_size=10, max_overflow=20 (nếu Railway plan cho phép)

"502 Bad Gateway" sau fresh deploy
  → App chưa start xong mà Railway đã route traffic
  → Fix: config health check với initial delay

"CORS error" từ frontend
  → CORS_ORIGINS chưa include production frontend URL
  → Fix: update CORS_ORIGINS trong Railway Variables, redeploy
```

### Auto-Deploy Settings

```
Railway → Service Settings → Source → Branch: main
→ Auto-deploy: Enabled
→ Mỗi git push to main → Railway tự deploy

Disable auto-deploy khi:
  □ Đang experiment với breaking changes
  □ Migration chưa chạy (deploy code mới trước migration)
  □ Cần test manually trước
```

---

## Vercel — Admin + Storefront Frontends

### New Project Setup

```
1. vercel.com → Add New Project → Import Git Repository
2. Select repo → configure:
   Framework Preset: Vite
   Root Directory:   web-admin   (hoặc web-storefront)
   Build Command:    npm run build
   Output Directory: dist
3. Environment Variables:
   VITE_API_URL = https://commerce-platform-production-f1e1.up.railway.app
4. Deploy
```

### vercel.json — SPA Routing + API Proxy

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
      "source": "/assets/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    },
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-XSS-Protection", "value": "1; mode=block" }
      ]
    }
  ]
}
```

**Giải thích regex:**

```
/api/:path*            → proxy sang Railway (backend handles /api/v1/*)
/((?!api/).*)          → mọi path KHÔNG bắt đầu bằng "api/" → index.html (SPA)
/assets/(.*)           → static files → cache 1 năm (Vite content hash)
```

### Vercel Environment Variables

```bash
# Trong Vercel Dashboard → Project → Settings → Environment Variables

# Scope: Production + Preview + Development (hoặc chỉ Production)
VITE_API_URL=https://commerce-platform-production-f1e1.up.railway.app

# Pull về local để dev (cần vercel login trước)
vercel env pull .env.local

# Set via CLI
vercel env add VITE_API_URL production
# → prompt nhập value
```

### Deploy Commands

```bash
# Cài vercel CLI
npm i -g vercel

# Login
vercel login

# Preview deploy (test trước khi prod)
cd web-admin
vercel
# → tạo preview URL: web-admin-xxxxx.vercel.app

# Production deploy
vercel --prod --yes

# Deploy + gán alias ngay
vercel --prod --yes && vercel alias $(vercel --prod --yes 2>&1 | grep -o 'https://[^ ]*') sonhai-admin.vercel.app
```

### Deployment Protection — Disable cho Public Access

```
Vercel Dashboard → Project → Settings → Deployment Protection

Vercel Authentication:
  □ Disabled  ← public access, không cần login Vercel

Password Protection:
  □ Disabled  ← nếu muốn public (disable luôn)

Trusted IPs:
  □ Leave empty (không restrict IP)
  
Save → Redeploy để áp dụng
```

### Custom Domain

```
Vercel Dashboard → Project → Settings → Domains → Add

Add domain: yourdomain.com
→ Vercel shows DNS records to add

DNS records:
  Type A:     76.76.21.21         (Vercel IP)
  Type CNAME: cname.vercel-dns.com (subdomain)

Propagation: 5-30 phút (đôi khi 24h nếu TTL cao)
SSL: Vercel auto provision Let's Encrypt
```

### Common Vercel Errors

```
"404 on page refresh" (React Router)
  → SPA rewrite missing trong vercel.json
  → Fix: thêm rewrite /((?!api/).*) → /index.html

"Failed to fetch" / CORS error từ frontend
  → VITE_API_URL sai hoặc backend CORS chưa include Vercel URL
  → Fix: check Network tab, verify URL, update CORS_ORIGINS in Railway

"Build failed: Cannot find module"
  → Dependency trong devDependencies nhưng cần ở runtime
  → Fix: move to dependencies trong package.json

"Function timeout" khi API proxy
  → Vercel function timeout 10s (Hobby) / 60s (Pro)
  → Fix: heavy operations → xử lý ở Railway, không proxy qua Vercel function
  → Hoặc dùng rewrite (không phải function) → không có timeout limit

"Environment variable not found"
  → VITE_API_URL chưa set trong Vercel dashboard
  → Hoặc set scope sai (Preview only nhưng đang deploy Production)
```

---

## Hetzner VPS — Future Option

Khi có revenue thật, chuyển sang Hetzner VPS €4/tháng cho toàn bộ stack:

### Sơ đồ

```
Hetzner VPS CX21 (€5/tháng, Singapore)
├── Nginx (reverse proxy + SSL termination)
│   ├── api.yourdomain.com → FastAPI :8001
│   ├── admin.yourdomain.com → React build (static)
│   └── store.yourdomain.com → React build (static)
├── PostgreSQL (local, no network latency)
├── Redis (local)
└── Certbot (Let's Encrypt SSL auto-renew)
```

### docker-compose.yml (brief)

```yaml
version: "3.9"
services:
  backend:
    build: ./backend
    env_file: .env
    ports: ["8001:8001"]
    depends_on: [postgres, redis]

  postgres:
    image: postgres:15-alpine
    volumes: ["pgdata:/var/lib/postgresql/data"]
    env_file: .env

  redis:
    image: redis:7-alpine
    volumes: ["redisdata:/data"]

  nginx:
    image: nginx:alpine
    ports: ["80:80", "443:443"]
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./certbot/conf:/etc/letsencrypt
      - ./web-admin/dist:/usr/share/nginx/admin
      - ./web-storefront/dist:/usr/share/nginx/store

volumes:
  pgdata:
  redisdata:
```

### Certbot SSL (Let's Encrypt)

```bash
# Install
apt install certbot python3-certbot-nginx

# Get certificate
certbot --nginx -d api.yourdomain.com -d admin.yourdomain.com -d store.yourdomain.com

# Auto-renew (add to crontab)
0 12 * * * certbot renew --quiet
```

**Ưu điểm Hetzner vs Railway/Vercel:**
- €5/tháng tất tần tật vs $20-30/tháng Railway + Vercel Pro
- Latency DB → backend = 0ms (cùng máy)
- Không bị cold start
- Full control

**Nhược điểm:**
- Phải tự manage server, backup, updates
- Không có auto-scaling
- Setup phức tạp hơn (1-2 ngày)
