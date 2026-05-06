# Conventional Commits — Full Specification

Reference: https://www.conventionalcommits.org/en/v1.0.0/

---

## Full Format

```
type(scope): subject
<blank line>
[body]
<blank line>
[footer(s)]
```

- **type** — bắt buộc
- **scope** — optional, trong dấu ngoặc đơn
- **subject** — bắt buộc, sau dấu hai chấm + space
- **body** — optional, cách subject 1 dòng trắng
- **footer** — optional, cách body 1 dòng trắng

---

## Type Specification (đầy đủ)

### `feat` — New Feature
```
feat(auth): add Google OAuth login

Users can now sign in with their Google account in addition to email/password.
OAuth callback at /auth/google/callback stores JWT in httpOnly cookie.

Closes #42
```

### `fix` — Bug Fix
```
fix(orders): prevent negative stock on concurrent confirm

Race condition when two requests confirm the same order simultaneously
caused stock to go below zero. Fixed with atomic SQL update:
  WHERE stock >= quantity → if rowcount == 0 raise InsufficientStock

Fixes #87
```

### `docs` — Documentation Only
```
docs(api): add authentication section to README

Explains JWT token flow, refresh token behavior, and error codes.
```

### `style` — Formatting (no logic change)
```
style(dashboard): apply consistent gap-4/6/8 spacing across cards

No behavior change. Pure visual consistency fix per UI rules.
```

### `refactor` — Code Restructure
```
refactor(products): extract price calculation to PricingService

Moves discount + tax logic out of product endpoint into dedicated
service for reuse across order creation and storefront pricing.
```

### `test` — Tests
```
test(orders): add unit tests for status transition validation

Covers all valid transitions and rejects invalid jumps (pending→shipping).
Uses pytest-asyncio + SQLAlchemy in-memory fixture.
```

### `chore` — Build / Tooling / Dependencies
```
chore(deps): upgrade fastapi from 0.111 to 0.115

Includes Pydantic v2 compat improvements. No API changes.
See FastAPI changelog: https://...
```

### `perf` — Performance
```
perf(products): add composite index on (shop_id, is_active, created_at)

Reduces products list query from 340ms to 12ms on 50K products.
Tested with EXPLAIN ANALYZE on staging DB.
```

### `ci` — CI/CD Configuration
```
ci(railway): add health check to deployment config

Prevents Railway from routing traffic before app is ready.
Configured /health endpoint with 30s initial delay.
```

### `build` — Build System
```
build(vite): enable chunk splitting for vendor dependencies

Reduces initial bundle from 1.2MB to 380KB by separating
react, recharts, and tanstack-query into separate chunks.
```

---

## Breaking Changes

### Cách 1: Dấu `!` sau type (ngắn gọn)
```
feat!: remove deprecated /v1/auth/token endpoint

BREAKING CHANGE: Use /v1/auth/login instead. Token format unchanged.
```

### Cách 2: Footer `BREAKING CHANGE:` (đầy đủ)
```
feat(api): redesign order response schema

BREAKING CHANGE: `order.items` field renamed to `order.line_items`.
All clients must update field access. Affects GET /orders, GET /orders/:id.
Migration guide: docs/migration/v2-order-schema.md
```

### Rules cho breaking changes
- **LUÔN** có footer `BREAKING CHANGE:` giải thích migration path
- Tạo CHANGELOG entry rõ ràng
- Bump major version (semver): v1.x.x → v2.0.0
- Giữ deprecated endpoint song song ít nhất 1 minor version trước khi xóa

---

## Multi-line Body — Khi nào dùng

Dùng body khi:
- Lý do thay đổi không tự rõ ràng từ subject
- Có trade-off hoặc alternative approach đã từ chối
- Fix bug phức tạp cần giải thích context

```
fix(payments): add HMAC verify on MoMo IPN callback

Previous implementation trusted MoMo callback payload without
verifying signature, allowing attackers to forge "paid" status.

Fix: compute HMAC-SHA256 from rawData + secretKey, compare with
received signature before updating payment_status. Reject with
400 if mismatch — consistent with VNPay implementation.

Security: This was a critical vulnerability. All unverified
callbacks from before 2026-04-20 should be manually audited.

Refs: #SECURITY-001
```

---

## Emoji Mapping (optional, team preference)

Common convention nếu team dùng emoji prefix:

| Emoji | Type | Example |
|-------|------|---------|
| ✨ | `feat` | `✨ feat(auth): add SSO login` |
| 🐛 | `fix` | `🐛 fix(orders): prevent double confirm` |
| 📝 | `docs` | `📝 docs(api): update auth section` |
| ♻️ | `refactor` | `♻️ refactor(pricing): extract discount calc` |
| ⚡️ | `perf` | `⚡️ perf(db): add index on shop_id` |
| ✅ | `test` | `✅ test(orders): add transition unit tests` |
| 🔧 | `chore` | `🔧 chore(deps): upgrade sqlalchemy` |
| 🚀 | `ci` | `🚀 ci(railway): add health check` |
| 💥 | Breaking | `💥 feat!: remove v1 auth endpoint` |

**Lưu ý:** Emoji hoặc không emoji — chọn 1 và nhất quán toàn project.

---

## Scope Examples by Project Type

### Web App (monolithic)
```
feat(auth): ...
fix(checkout): ...
perf(dashboard): ...
style(products): ...
refactor(orders): ...
```

### Monorepo (multi-package)
```
feat(backend): ...
fix(admin): ...
chore(storefront): ...
build(mobile): ...
```

### Library / SDK
```
feat(core): ...
fix(parser): ...
docs(types): ...
test(utils): ...
```

### API Versioning
```
feat(v2/orders): ...
fix(v1/auth): ...   # backport fix to old version
```

---

## Changelog Generation

### Tự động từ git log
```bash
# Lấy feat và fix để build CHANGELOG
git log --oneline --grep="^feat\|^fix" v1.0.0..HEAD

# Format đẹp hơn với full message
git log --pretty=format:"- %s (%h)" --grep="^feat" v1.0.0..HEAD

# Theo từng type
git log --pretty=format:"%s" v1.0.0..HEAD | grep "^feat" | sort
git log --pretty=format:"%s" v1.0.0..HEAD | grep "^fix" | sort
git log --pretty=format:"%s" v1.0.0..HEAD | grep "BREAKING CHANGE" | sort
```

### Tools tự động hóa
```bash
# conventional-changelog-cli
npx conventional-changelog-cli -p angular -i CHANGELOG.md -s

# standard-version (Node.js)
npx standard-version

# semantic-release (CI/CD)
npx semantic-release
```

### Format CHANGELOG.md thủ công
```markdown
## [1.2.0] — 2026-05-06

### Features
- feat(auth): add Google OAuth login (#42)
- feat(payments): add VietQR payment method (#61)

### Bug Fixes
- fix(orders): prevent race condition on stock deduction (#87)
- fix(payments): add HMAC verify on MoMo callback (#SECURITY-001)

### Performance
- perf(products): add composite index, reduce query from 340ms to 12ms

### Breaking Changes
- feat!: remove deprecated /v1/auth/token endpoint — use /v1/auth/login
```

---

## Bad Commit Anti-Patterns — Giải thích Tại Sao Bad

| Commit | Vấn đề | Hậu quả |
|--------|--------|---------|
| `fix bug` | Không nói bug gì, ở đâu | `git bisect` không dùng được |
| `update code` | Không có thông tin gì | Sau 1 tuần không biết đây là gì |
| `wip` | Work in progress = chưa xong | Review impossible, không revertable cleanly |
| `merge main into feature` | Merge noise, không có logic | Log messy, squash later bất tiện |
| `FINAL FINAL v3` | Tuyệt vọng naming | Dấu hiệu process bị hỏng |
| `fix for real this time` | Sarcasm in commit | Không professional, không searchable |
| `misc changes` | "Misc" = không biết mô tả | 10 thứ trong 1 commit = anti-atomic |
| `added some stuff` | Thì quá khứ + vague | Subject phải imperative + cụ thể |
| `123` | Ticket number không context | Cần ticket system để hiểu |
| `Revert "Revert "fix""` | Double revert chaos | Nên cherry-pick thay vì revert revert |

---

## Quick Reference Card

```
feat(scope): add X          → new feature
fix(scope): prevent Y       → bug fix
docs(scope): update Z       → docs only
style(scope): apply W       → formatting
refactor(scope): extract V  → restructure
test(scope): add tests for  → tests
chore(scope): upgrade U     → tooling
perf(scope): optimize T     → performance

feat!: ...                  → BREAKING CHANGE (short form)
BREAKING CHANGE: ...        → footer (long form)

Max 72 chars subject
Imperative mood (add, not added)
Lowercase subject
No period at end
```
