# Grep Recipes — Run These During Review

> Copy-paste commands cho mỗi lens. Chạy từ project root.
> Replace `<dir>` với scope (e.g., `backend/app`, `web-admin/src`).

---

## LENS 1 — Security

```bash
# 1.1 — SQL injection (f-string SQL)
grep -rEn 'execute\(f["'\'']|sa\.text\(f["'\''].*\{' <dir> 2>/dev/null

# 1.2 — Hardcoded secrets
grep -rEn '(secret|api_key|password|token|jwt|webhook_secret)\s*=\s*["'\''][^"'\''  ]{8,}' <dir> \
  | grep -v "settings\.\|os\.environ\|getenv"

# 1.3 — Endpoints missing auth
grep -L "Depends(get_current_user)\|Depends(get_current_shop)\|Depends(verify_token)" \
  <dir>/api/v1/endpoints/*.py 2>/dev/null

# 1.4 — Webhook signature verification
grep -rn "callback\|webhook\|/notify\|/return" <dir> | grep "@router"
# Then for each, manually check signature verify exists

# 1.5 — CORS wildcard
grep -rn 'allow_origins\s*=\s*\["?\*' <dir>

# 1.6 — Eval / exec usage (dangerous)
grep -rn '\beval(\|\bexec(' <dir>

# 1.7 — Insecure random for tokens
grep -rn "random\.\|randint\|choice" <dir> | grep -i "token\|secret\|salt\|nonce"
# These should use secrets.token_urlsafe / token_hex
```

---

## LENS 2 — Multi-Tenant Data Leak

```bash
# 2.1 — Queries without shop_id filter
grep -rEn "select\(.*\)\.where|update\(.*\)\.where|delete\(.*\)\.where" <dir>/services 2>/dev/null \
  | grep -v "shop_id\|current_shop\|by_id\|user_id"

# 2.2 — Public storefront expose sensitive fields
grep -rn "PublicProduct\|PublicOrder\|StorefrontResponse" <dir>/schemas
# Check schemas — should NOT have cost_price, internal_note, etc.

# 2.3 — Cross-tenant joins missing filter
grep -rEn "\.join\(" <dir>/services
# Each join must verify both sides filtered by shop_id
```

---

## LENS 3 — Money Precision

```bash
# 3.1 — Float used for money
grep -rEn "(price|amount|total|fee|discount|tax|subtotal)\s*=\s*[0-9]+\.[0-9]+\b" <dir>

# 3.2 — Float type in models
grep -rn "Mapped\[float\]\|Float()\|Float," <dir>/models

# 3.3 — VNPay amount precision
grep -rn "amount.*\*\s*100\|total.*\*\s*100\|\.total\s*\*\s*100" <dir>
# Check uses .quantize(Decimal("1")) before int()

# 3.4 — Mixing float + Decimal (TypeError risk)
grep -rEn "Decimal\(.*\)\s*\*\s*[0-9]+\.[0-9]|[0-9]+\.[0-9].*\*\s*Decimal" <dir>

# 3.5 — JSON serialization of Decimal
grep -rn "json\.dumps\|JSONResponse" <dir>/services
# Decimal needs custom encoder OR str(decimal) conversion
```

---

## LENS 4 — Race Conditions

```bash
# 4.1 — Stock read-then-write
grep -rEn "\.stock\s*[-+]=|stock\s*=\s*.*\.stock" <dir>/services

# 4.2 — Counter increment without atomic
grep -rEn "(count|view_count|order_count)\s*[-+]=" <dir>/services

# 4.3 — Get-or-create pattern (race risk)
grep -rEn "scalar_one_or_none\(\).*\nif.*is\s+None.*\n.*\(\)|first\(\)\s*\n.*\nif" <dir>

# 4.4 — Missing with_for_update on critical reads
grep -rn "Order\.\|Customer\.\|Product\." <dir>/services | grep "scalar_one_or_none"
# Check critical updates use with_for_update() lock
```

---

## LENS 5 — State Machine Violations

```bash
# 5.1 — Direct status assignment (bypass validation)
grep -rEn "\.status\s*=\s*[\"']" <dir>/services

# 5.2 — Order/payment status without validate_transition
grep -rn "validate_transition\|VALID_TRANSITIONS" <dir>
# Files with status writes but NO validate import = bug

# 5.3 — Status comparison hardcoded strings
grep -rEn "status\s*==\s*[\"']\w+[\"']" <dir>
# Should use Enum or constants

# 5.4 — Stock change without log
grep -rn "stock\s*=\|stock\s*\+=" <dir>/services
# Each stock change should also create InventoryLog entry
```

---

## LENS 6 — API ↔ Frontend Boundary

```bash
# 6.1 — Backend response_model coverage
grep -rn "@router\." <dir>/backend/app/api | grep -v "response_model="

# 6.2 — Frontend type definitions match
# Compare files manually:
diff <(grep "class.*Response.*BaseModel" <dir>/backend/app/schemas | sort) \
     <(grep "interface.*Response\|type.*Response" <dir>/web-admin/src/types | sort)

# 6.3 — Datetime format mismatch
grep -rn "datetime\|Date.parse\|new Date" <dir>/web-admin/src/api
# Backend should return ISO 8601 string

# 6.4 — Error handling consistency
grep -rn "error.message\|error.detail\|error.response" <dir>/web-admin/src
# Should consistently extract: error.response?.data?.detail
```

---

## FRONTEND-SPECIFIC

```bash
# Frontend.1 — console.log in production
grep -rEn "^\s*console\.(log|debug|info)" <dir>/web-admin/src \
  | grep -v "// eslint-disable\|// debug"

# Frontend.2 — Hardcoded API URLs
grep -rEn "https?://[^'\"\s]+" <dir>/web-admin/src \
  | grep -v "import.meta.env\|VITE_API_URL\|//\s*comment"

# Frontend.3 — TypeScript any
grep -rEn ":\s*any\b|<any>" <dir>/web-admin/src

# Frontend.4 — Missing useEffect cleanup
grep -B2 -A10 "useEffect(" <dir>/web-admin/src \
  | grep -A10 "useEffect" | grep -v "return ()" | head -50

# Frontend.5 — Hardcoded text (i18n missing)
grep -rEn 'text-\w+">[^{<]{8,}' <dir>/web-admin/src/components \
  | grep -v "t(\|t([\"'\'']\|className"

# Frontend.6 — Missing loading/error/empty states
grep -rL "isLoading\|error\|isError\|isEmpty\|!data" <dir>/web-admin/src/pages

# Frontend.7 — Inline styles thay class
grep -rEn "style=\{\{" <dir>/web-admin/src/components \
  | grep -v "// allowed\|background-image"
```

---

## MIGRATION-SPECIFIC

```bash
# M.1 — NOT NULL without default on existing table
grep -rEn "add_column.*nullable=False" <dir>/alembic/versions \
  | grep -v "server_default\|default="

# M.2 — Missing CONCURRENTLY on large table index
grep -rn "create_index" <dir>/alembic/versions \
  | grep -v "postgresql_concurrently=True"

# M.3 — Drop column without 2-step deploy notes
grep -rn "drop_column" <dir>/alembic/versions
# Each should have comment about prior code deploy

# M.4 — Missing downgrade()
for f in <dir>/alembic/versions/*.py; do
  if ! grep -q "def downgrade" "$f"; then
    echo "MISSING: $f"
  fi
done
```

---

## TEST QUALITY

```bash
# T.1 — Tests with weak assertions
grep -rEn "assert\s+(True|1|response)$|assertIsNotNone\b" <dir>/tests

# T.2 — Tests without setup/teardown
grep -rL "fixture\|setUp\|tearDown\|@pytest\.fixture" <dir>/tests

# T.3 — Mock everything (over-mocked)
grep -rn "Mock\|patch" <dir>/tests | wc -l
# > 50% of test lines = over-mocked, refactor to integration test
```

---

## QUICK FULL AUDIT (1 command, all lenses)

```bash
#!/bin/bash
# audit.sh — run from project root

DIR="${1:-backend/app}"

echo "=== LENS 1 — Security ==="
grep -rEn 'execute\(f["'\'']' "$DIR" 2>/dev/null
grep -rEn '(secret|api_key|password)\s*=\s*["'\'']' "$DIR" | grep -v "settings\." 2>/dev/null

echo ""
echo "=== LENS 2 — Multi-Tenant ==="
grep -rEn "select\(.*\)\.where" "$DIR"/services 2>/dev/null \
  | grep -v "shop_id\|current_shop" | head -10

echo ""
echo "=== LENS 3 — Money ==="
grep -rEn "(price|amount|total)\s*=\s*[0-9]+\.[0-9]+" "$DIR" | head -10
grep -rn "Mapped\[float\]" "$DIR"/models 2>/dev/null

echo ""
echo "=== LENS 4 — Race Conditions ==="
grep -rEn "\.stock\s*[-+]=" "$DIR" | head -10

echo ""
echo "=== LENS 5 — State Machine ==="
grep -rEn "\.status\s*=\s*[\"']" "$DIR"/services 2>/dev/null | head -10

echo ""
echo "=== Frontend Anti-Patterns ==="
grep -rEn "^\s*console\.log" web-admin/src 2>/dev/null | head -5
grep -rEn ":\s*any\b" web-admin/src 2>/dev/null | head -5

echo ""
echo "Audit complete. Review output above."
```

Save as `~/audit.sh`, run: `bash ~/audit.sh backend/app`
