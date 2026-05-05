# Security Checklist — OWASP Top 10 Mapped

> Deep security audit. Run khi review payment, auth, admin endpoint, hoặc trước public release.

---

## A01 — Broken Access Control

```
□ Endpoint có Depends(get_current_user)?
□ Resource ownership check qua Depends(get_current_shop)?
□ Path parameter shop_id verified match user's owned shops?
□ Role-based access (owner/staff/viewer) enforced?
□ Admin endpoint return 404 not 403 (avoid existence leak)?
□ Storefront API NO sensitive fields (cost_price, internal_note)?
□ Customer endpoint khác seller endpoint (different auth path)?
□ File upload path KHÔNG cho user control (avoid path traversal)?
```

**Common bugs:**
- `/shops/{shop_id}/orders/{id}` → user A access `/shops/B-shop-id/orders/C-order` returns C's data
- `GET /admin/users` accessible với regular user JWT
- File upload `name` parameter dùng làm filename → `../../../etc/passwd`

**Fix:** Always: JWT decode → load user → verify ownership → load resource (filtered by shop_id).

---

## A02 — Cryptographic Failures

```
□ JWT_SECRET ≥ 32 chars random?
□ JWT có expiry (exp claim, e.g., 24h)?
□ Password hashing dùng bcrypt cost ≥ 12 (NOT MD5/SHA1)?
□ Sensitive data encrypted at rest (DB column encryption nếu cần)?
□ HTTPS enforced (HSTS header)?
□ Cookie flags: HttpOnly, Secure, SameSite=Lax?
□ KHÔNG log sensitive data (password, JWT, full credit card)?
□ TLS version ≥ 1.2?
```

**Common bugs:**
- JWT decode without verify_signature
- Password hash MD5 → rainbow table crack
- API responses include password_hash field

---

## A03 — Injection

### SQL Injection

```
□ KHÔNG f-string SQL:
   ✗ db.execute(f"SELECT * FROM users WHERE id = {user_id}")
   ✓ db.execute(text("SELECT * FROM users WHERE id = :id"), {"id": user_id})

□ ORM query: param qua keyword args, KHÔNG concatenate string
   ✗ Order.where(f"shop_id = {shop_id}")
   ✓ Order.where(Order.shop_id == shop_id)
```

### XSS (frontend)

```
□ KHÔNG dangerouslySetInnerHTML với user input?
□ User-generated HTML qua DOMPurify trước render?
□ URL params escape (URL encoding)?
□ CSP header set (script-src 'self')?
```

### Command Injection

```
□ KHÔNG subprocess.run(f"... {user_input}")
   ✓ subprocess.run(["cmd", user_input], shell=False)
```

### Header Injection

```
□ User input trong response headers escaped?
   ✗ Set-Cookie based on user input → newline injection
```

---

## A04 — Insecure Design

```
□ Rate limiting trên: login, register, password reset, payment callback?
□ Email verification trước activate account?
□ Captcha trên signup (chống bot)?
□ 2FA option cho high-value accounts?
□ Account lockout sau N failed login attempts?
□ Password reset token có expiry (≤ 1h) + single-use?
□ Webhook signature verify (NOT just IP whitelist)?
□ Multi-step transaction: idempotency key (avoid double charge)?
```

---

## A05 — Security Misconfiguration

```
□ Production NEVER exposes traceback (FastAPI debug=False)?
□ Default credentials changed (admin/admin → strong password)?
□ Unused services disabled (e.g., admin endpoints in storefront)?
□ DEBUG=False trong production?
□ /docs and /redoc disabled hoặc behind auth in production?
□ Error messages KHÔNG leak internal info (stack trace, table names)?
□ Server header KHÔNG reveal version (FastAPI/0.110.0 → just FastAPI)?
□ Database credentials qua env vars, NOT in code?
```

**Common bugs:**
- Production có `?debug=true` query param expose traceback
- `/admin` accessible from public storefront domain
- Error trả về SQL error: `relation "users" does not exist`

---

## A06 — Vulnerable Components

```bash
# Check Python deps
pip-audit

# Check npm deps
npm audit
npm audit fix --force  # careful, may break

# Check Docker image
docker scan <image>

# Outdated deps
pip list --outdated
npm outdated
```

```
□ Run pip-audit ≥ monthly?
□ Run npm audit ≥ monthly?
□ Pinned versions trong requirements.txt (==X.Y.Z)?
□ Dependabot enabled trên GitHub?
□ Security alerts configured?
```

---

## A07 — Authentication Failures

```
□ Password requirements: min 8 chars, mixed case, number?
□ Common password list blocked (top 1000 passwords)?
□ Username enumeration prevented?
   ✗ "User not found" vs "Wrong password" → reveals user existence
   ✓ "Invalid credentials" cho cả 2 cases
□ Session timeout (e.g., 24h JWT exp)?
□ Logout invalidates token (token blacklist trong Redis)?
□ Concurrent session limit (optional)?
□ Magic link / OTP có TTL ngắn (≤ 10 min)?
```

---

## A08 — Data Integrity

```
□ JWT signed với strong algorithm (HS256+ hoặc RS256)?
□ Webhook payload signature verified (HMAC SHA256+)?
□ File upload validate magic bytes (NOT just extension)?
   PDF starts with %PDF-
   PNG starts with \x89PNG
□ Deserialization safe (NOT pickle untrusted data)?
□ JSON parsing có size limit (avoid DoS via huge JSON)?
□ Cross-site Request Forgery (CSRF) tokens for state-changing operations?
   - SameSite=Lax cookie OR explicit CSRF token
```

---

## A09 — Logging & Monitoring

```
□ Failed login attempts logged?
□ Suspicious activity alerts (e.g., 100 requests/min from 1 IP)?
□ Audit trail cho sensitive operations (admin actions, money transfers)?
□ Logs KHÔNG contain sensitive data (password, JWT, credit card)?
□ Log retention policy (≥ 90 days for compliance)?
□ Centralized logging (KHÔNG just local files)?
□ Production errors trigger alerts (Sentry/CloudWatch)?
```

---

## A10 — Server-Side Request Forgery (SSRF)

```
□ User-supplied URL fetched: blocklist internal IPs (10.x, 172.16.x, 192.168.x, 127.x)?
□ DNS rebinding protection?
□ Webhook URLs validate (whitelist domains)?
□ Image fetcher: timeout + size limit?
□ KHÔNG follow redirects to internal hosts?
```

**Example:**
```python
# ✗ DANGEROUS
async def fetch_user_avatar(url):
    async with httpx.AsyncClient() as client:
        return await client.get(url)

# ✓ SAFE
import ipaddress
from urllib.parse import urlparse

async def fetch_user_avatar(url):
    parsed = urlparse(url)
    if parsed.scheme not in ('http', 'https'):
        raise ValueError("Invalid scheme")

    # Resolve and check IP
    import socket
    ip = socket.gethostbyname(parsed.hostname)
    addr = ipaddress.ip_address(ip)
    if addr.is_private or addr.is_loopback or addr.is_link_local:
        raise ValueError("Internal IP not allowed")

    async with httpx.AsyncClient(timeout=5.0, max_redirects=2) as client:
        resp = await client.get(url)
        if len(resp.content) > 5_000_000:  # 5 MB limit
            raise ValueError("File too large")
        return resp.content
```

---

## PAYMENT-SPECIFIC SECURITY

```
□ VNPay/MoMo callback verify HMAC signature BEFORE update payment_status?
□ Amount in callback === amount in order (prevent amount tampering)?
□ Order ID in callback exists trong DB?
□ Idempotency: same callback fired 2x = only 1 status update?
□ KHÔNG mark "paid" qua frontend request — only via verified callback?
□ Refund only allowed cho order.payment_status == "paid"?
□ Refund amount ≤ original order total?
□ Audit log mọi payment state change?
```

---

## QUICK SECURITY GREP

```bash
# Critical vulnerabilities
grep -rn "eval(\|exec(\|pickle.loads\|yaml.load" backend/

# Hardcoded secrets pattern
grep -rEn "(secret|password|api_key|token)\s*=\s*['\"][A-Za-z0-9+/=]{12,}" backend/

# Unsafe deserialization
grep -rn "pickle\|marshal\|yaml.load\b" backend/

# SQL string interpolation
grep -rEn 'execute\(f["'\''])\|text\(f["'\'']' backend/

# Missing auth
grep -rL "Depends(get_current" backend/app/api/v1/endpoints/*.py

# Webhook without signature
grep -rn "@router.post.*webhook\|@router.post.*callback" backend/
# For each, check signature verification exists

# Disabled SSL
grep -rn "verify=False\|ssl_verify=False" backend/

# DEBUG mode in production
grep -rn "DEBUG\s*=\s*True\|debug=True" backend/

# Insecure random for security tokens
grep -rn "random\.\|randint" backend/ | grep -i "token\|secret\|nonce"
```

---

## SECURITY HEADERS CHECKLIST

```python
# main.py - middleware
@app.middleware("http")
async def add_security_headers(request, call_next):
    response = await call_next(request)
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    response.headers["Content-Security-Policy"] = (
        "default-src 'self'; "
        "script-src 'self' 'unsafe-inline'; "
        "style-src 'self' 'unsafe-inline'; "
        "img-src 'self' data: https:; "
        "connect-src 'self' https://api.example.com"
    )
    response.headers["Permissions-Policy"] = "geolocation=(), microphone=(), camera=()"
    return response
```

---

## INCIDENT RESPONSE READINESS

```
□ Có runbook cho data breach?
□ Có process revoke compromised JWT (token blacklist)?
□ DB backup tested (restore from backup verified)?
□ Production access log (who did what when)?
□ Emergency contacts list (Cloudflare, hosting, payment processor)?
□ Tabletop exercise yearly?
```

---

**Final rule:** Security review KHÔNG phải one-time. Run trước MỌI release. Run sau MỌI dependency update. Run khi có CVE alert.
