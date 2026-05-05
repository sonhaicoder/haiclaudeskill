---
name: code-review
description: |
  Code review skill — find bugs, security issues, anti-patterns BEFORE merge.
  AUTO-TRIGGER khi: user nói "review/check code/audit/PR review", file vừa changed (git diff), Claude Code spawn reviewer/qa-reviewer agent, hoặc trước khi commit/push.
  Force apply 6 audit lenses: (1) Security (SQLi/XSS/secrets/auth bypass), (2) Multi-tenant leak (shop_id missing), (3) Money precision (float vs Decimal), (4) Race conditions (read-then-write), (5) State machine violations (order/payment status jumps), (6) API↔frontend boundary mismatch.
  Plus 27 anti-patterns + 5-dim severity scoring + grep recipes ready-to-run.
  Distilled từ Commerce Platform 100 commits production patterns.
  KHÔNG dùng cho: writing new code (use feature skill), planning/architecture (use planner).
---

# Code Review Skill — Find Bugs Before Production

> **Triết lý:** Reviewer KHÔNG nice. Nice review = bug ship to prod. Brutal honest > polite vague.
> **Mục tiêu:** mỗi lần review tìm ra ít nhất 1 issue. Không tìm ra = chưa đọc kỹ.

---

## 1. AUTO-TRIGGER

```
DÙNG khi:
  ✓ User nói "review/check code/audit/security check/code quality"
  ✓ User: "review PR <number>"
  ✓ Vừa làm xong feature, trước khi commit/push
  ✓ Claude Code spawn reviewer/qa-reviewer agent
  ✓ Có file changed trong git status

KHÔNG dùng khi:
  ✗ Đang writing new code (use feature skills)
  ✗ Planning architecture (use planner)
  ✗ Bug fix nhanh đã biết root cause (just fix)
```

---

## 2. SÁU AUDIT LENSES (chạy theo thứ tự severity)

### LENS 1 — Security (P0, CRITICAL)

```
□ SQL Injection
   Run: grep -rn 'execute(f"\|execute(".*{.*}\|f"SELECT\|f"UPDATE' <changed_files>
   Issue: f-string SQL = injection vector
   Fix:   Use parameterized: text("... :param"), {"param": value}

□ Hardcoded Secrets
   Run: grep -rEn '(secret|api_key|password|token|jwt)\s*=\s*["'\''][^"'\'']' <files> | grep -v "settings\."
   Issue: secret in code = git history leak
   Fix:   Move to settings (Pydantic BaseSettings + .env)

□ Webhook Signature Verify (payments)
   Run: grep -rn "callback\|webhook\|notify" <changed_payment_files>
   Issue: VNPay/MoMo callback không verify HMAC = giả mạo "paid"
   Fix:   verify_signature() BEFORE update payment_status

□ Auth Bypass
   Run: grep -L "Depends(get_current_user)\|Depends(get_current_shop)" <new_endpoints>
   Issue: endpoint thiếu auth dependency
   Fix:   Add Depends(get_current_user) + Depends(get_current_shop)

□ Permission Check
   Issue: user A access shop của user B
   Check: get_current_shop dependency verify ownership
   Fix:   Return 404 (not 403) — tránh lộ existence
```

### LENS 2 — Multi-Tenant Data Leak (P0)

```
□ shop_id filter MISSING
   Run: grep -rn "select(\|update(\|delete(" <changed_services> | grep -v "shop_id\|current_shop"
   Issue: query không filter shop_id = lộ data shop khác
   Fix:   .where(Model.shop_id == current_shop.id)

□ Composite query: ALL joined tables filtered
   Pattern: select(Order).join(Customer).where(
              Order.shop_id == X,
              Customer.shop_id == X,  # PHẢI filter cả join
            )

□ Storefront public API expose internal fields?
   Run: grep -rn "PublicProductResponse\|PublicOrder" <changed_files>
   Check: schema KHÔNG include cost_price, internal_note, customer.email full

□ Search endpoint: filter shop_id?
   Common bug: /search?q=X tìm khắp mọi shop
```

### LENS 3 — Money Precision (P0)

```
□ Float used for money
   Run: grep -rEn "(price|amount|total|fee|discount|tax)\s*=\s*[0-9]+\.[0-9]" <files>
   Issue: 250000.0 * 0.9 = 225000.00000000003
   Fix:   Decimal("250000") * Decimal("0.9")

□ Mixing float + Decimal
   Pattern: Decimal(...) * float = TypeError
   Fix: Decimal(str(float_value))

□ VNPay amount precision
   Run: grep -rn "order.total\s*\*\s*100\|amount.*\*\s*100" <payment_files>
   Issue: int(order.total * 100) truncates Decimal incorrectly
   Fix:   int(order.total.quantize(Decimal("1")) * 100)

□ Database column type
   Run: grep -rn "Float\|Decimal\|Numeric" <model_files>
   Issue: Float type for money column
   Fix:   Numeric(14, 2)
```

### LENS 4 — Race Conditions (P0)

```
□ Inventory deduct: read-then-write
   Run: grep -rn "stock\s*[-+]=\|\.stock\s*=" <service_files>
   Issue: race condition (2 orders cùng SP cuối → stock = -1)
   Fix:   Atomic UPDATE WHERE stock >= quantity, check rowcount

□ Counter increment: read-then-write
   Issue: order_count, view_count update race
   Fix:   UPDATE table SET counter = counter + 1 (atomic)

□ Customer create from order: race
   Run: grep -rn "Customer\(" <service_files>
   Issue: 2 đơn cùng SĐT đồng thời → duplicate customer
   Fix:   with_for_update() lock OR UNIQUE constraint + ON CONFLICT

□ Distributed lock cho long-running job?
   Issue: 2 worker process cùng task
   Fix:   Redis SETNX với expiry HOẶC database advisory lock
```

### LENS 5 — State Machine Violations (P0)

```
□ Order status nhảy trạng thái
   Run: grep -rn "order.status\s*=\s*\|status\s*==.*pending" <service_files>
   Issue: pending → completed (skip confirmed/packing/shipping)
   Fix:   validate_transition(current, new) qua VALID_TRANSITIONS dict

□ Payment status: unpaid → refunded (skip paid)
   Issue: data inconsistent
   Fix:   PAYMENT_TRANSITIONS dict với valid paths

□ Stock change without order context
   Issue: stock thay đổi không có order_id (audit gap)
   Fix:   inventory_logs PHẢI có reference (order_id, manual_adjustment_id, return_id)

□ Refund without return verification
   Issue: refund money mà chưa nhận lại hàng
   Fix:   refund chỉ allowed khi order.status == "returned"
```

### LENS 6 — API ↔ Frontend Boundary (P1)

```
□ Field name mismatch
   Run so sánh: backend schema vs frontend API client types
   Common bug: backend `discount_type` vs frontend `type`

□ Pagination format
   Backend trả: {items, total, page, page_size, total_pages}
   Frontend expect: {items, total, page, page_size, total_pages}
   FIX: align format

□ Datetime format
   Backend ISO 8601 với timezone
   Frontend Date.parse() handles
   Bug: backend trả timestamp number = frontend parse sai

□ Empty array vs null
   Backend trả [] khi không có items, KHÔNG null
   Frontend assumes Array.length

□ Error response format
   Backend: {detail: "..."} (FastAPI standard)
   Frontend extracts: error.response.data.detail

□ HTTP status codes
   Backend trả 404 cho not-found
   Frontend handle: 401 → logout, 403 → permission denied, 404 → not found
```

---

## 3. ANTI-PATTERNS — Common Bugs Pattern

### Backend Anti-Patterns

```
✗ try/except: pass         → Log + raise specific exception
✗ from x import *           → Specific imports
✗ Hardcoded URLs            → settings.BACKEND_URL
✗ print() debugging         → logger.info/error
✗ Sync function in async    → await + use async lib
✗ Bare exception            → except SpecificError
✗ Mutable default args      → def f(x: list = None) → x = x or []
✗ requests library          → httpx.AsyncClient
✗ datetime.utcnow()         → datetime.now(timezone.utc)
✗ Hardcoded magic numbers   → constants module
```

### Frontend Anti-Patterns

```
✗ console.log in production → remove or use logger
✗ Inline styles thay class  → use Tailwind class system
✗ Any TypeScript type        → specific interface
✗ useEffect mà không cleanup → return cleanup function
✗ Mutate state directly      → setState(new object)
✗ Hardcoded API URLs         → env vars (VITE_API_URL)
✗ Generic placeholder name   → realistic ("Linh Nguyen")
✗ Missing loading/error/empty state → 3 states bắt buộc
✗ Modal trong <main>         → React Portal (z-index, sidebar overlap)
✗ Hardcoded text             → t() i18n
```

---

## 4. SEVERITY SCORING

```
P0 — CRITICAL (block merge, must fix)
   - Security exploit (SQLi, XSS, auth bypass)
   - Data leak (multi-tenant, secrets)
   - Money loss (float precision, double charge, race condition)
   - Data corruption (order state jump, atomicity violation)
   - Production downtime risk

P1 — HIGH (fix trong PR này)
   - Performance regression (N+1 queries, missing index)
   - UX broken (loading/error state missing)
   - API contract break
   - Memory leak / resource exhaustion

P2 — MEDIUM (fix trong PR follow-up)
   - Code smell (dead code, unused vars)
   - Test missing
   - Docs out of date
   - Naming unclear

P3 — LOW (note for future)
   - Style/formatting
   - Minor refactor opportunity
```

---

## 5. REVIEW WORKFLOW

```
1. PRE-READ
   - Đọc PR description / commit message — hiểu intent
   - Run `git diff main...HEAD` để xem CHỈ changes (không re-review old code)

2. SCAN
   - Run grep recipes (xem references/grep-recipes.md)
   - List files changed → categorize (backend/frontend/migration/test/config)

3. AUDIT (theo 6 lenses)
   - Backend: Lens 1-5
   - Frontend: Lens 1 + 6 + Frontend anti-patterns
   - Migration: Special audit (NOT NULL, drop column 2-step, index concurrent)
   - Test: Coverage + assertions meaningful

4. SCORE
   - Mỗi issue → P0/P1/P2/P3
   - Tổng kết: X issues found (Y P0, Z P1, ...)

5. REPORT
   - File:line:column: issue description
   - Severity tag
   - Suggested fix (code snippet nếu cần)
   - DO NOT just say "looks good" — luôn tìm gì đó (kể cả P3)
```

---

## 6. REPORT TEMPLATE

```markdown
# Code Review Report — PR #<n> / Branch <branch>

**Files changed:** <count> files, +<add>/-<del> lines
**Reviewer:** code-review skill (automated)
**Verdict:** ❌ BLOCK / ⚠️ NEEDS WORK / ✅ APPROVED

## Summary

<2-3 sentences: what changed, overall quality, key concerns>

## Issues Found (X total: Y P0, Z P1, W P2)

### 🔴 P0 — Critical (must fix before merge)

**1. [LENS 3 — Money Precision] `payment_service.py:142`**
```python
# Current
amount_vnp = int(order.total * 100)
# Issue: Decimal * 100 truncates incorrectly (e.g., 250000.005 → 25000000 not 25000001)
# Fix
amount_vnp = int(order.total.quantize(Decimal("1")) * 100)
```

**2. [LENS 2 — Multi-tenant Leak] `customer_service.py:87`**
```python
# Current
customers = await db.execute(select(Customer))
# Issue: Missing shop_id filter — returns ALL shops' customers
# Fix
customers = await db.execute(
    select(Customer).where(Customer.shop_id == current_shop.id)
)
```

### 🟡 P1 — High (fix in this PR)

**3. [Frontend Boundary] `api/orders.ts:23`**
- Backend returns `{detail: "..."}` for errors
- Frontend extracts `error.message` (will be undefined)
- Fix: `error.response?.data?.detail || 'Lỗi không xác định'`

### 🟢 P2 — Medium (follow-up PR OK)

**4. [Code Smell] `OrderDetailModal.tsx:145`**
- Dead code: `const oldHandler = ...` not referenced
- Remove

## Recommendations

- ☑ Fix 2 P0 issues before merge
- ☑ Address P1 frontend boundary in this PR
- 📝 Schedule P2 cleanup for next sprint

## Tests Run
- [ ] Backend pytest: not run
- [ ] Frontend tsc --noEmit: not run
- [ ] E2E Playwright: not run

**Recommend run before merge.**
```

---

## 7. SPECIAL CASES

### Migration Review

```
□ NOT NULL trên existing column → 2-step?
□ Drop column → deploy code không reference TRƯỚC, drop column SAU?
□ Add index large table → CONCURRENTLY?
□ Data migration → batch processing (1000 rows/batch)?
□ Has downgrade() function?
□ Tested on staging clone DB?
```

### Test Review

```
□ Test có meaningful assertions (không chỉ "no error")?
□ Mock ONLY external boundaries (HTTP, DB, time, random)?
□ Setup/teardown isolated (test independence)?
□ Edge cases covered (empty, null, max, race)?
□ Test name describe BEHAVIOR (not implementation)?
```

### Performance Review

```
□ N+1 queries? (lazy="select" + loop)
□ Index trên cột filter/sort hot path?
□ Pagination implemented (không load all)?
□ Cache opportunities (Redis cho hot data)?
□ Bundle size (frontend) — lazy load?
```

---

## 8. REFERENCE FILES

| File | Khi nào đọc |
|------|-------------|
| `references/grep-recipes.md` | Ready-to-run grep commands cho mỗi lens |
| `references/security-checklist.md` | Deep security audit (OWASP top 10 mapping) |

---

## 9. RULES OF ENGAGEMENT

```
✓ Brutal honest > polite vague
✓ Specific line:column references
✓ Fix code snippet when possible
✓ Severity tag everything
✓ Tìm ra ÍT NHẤT 1 issue (kể cả P3)

✗ "looks good" without searching
✗ Vague "consider refactoring"
✗ Repeat warnings từ linter
✗ Style nitpicks (formatter handles)
✗ Praise/encourage in review (this is review, not coaching)
```

**Rule cuối:** Reviewer là last line of defense. Nếu reviewer nice, bug ship to prod. Be the reviewer you wish your team had.
