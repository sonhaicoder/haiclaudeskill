---
name: git-pr
description: >
  Auto-trigger khi: git commit, git push, tạo PR, "viết commit message", "review PR",
  "tách commit", "squash", "rebase", "git log", "changelog", "CHANGELOG.md",
  "pull request", "merge request", keyword "commit", "push", "branch", "PR #".
  Rule: Conventional Commits bắt buộc. KHÔNG --no-verify. KHÔNG force push main.
  PR = document for reviewers, not dump of code.
---

# Git PR Skill — Commits, Branches & Pull Requests

> **Triết lý:** Commit là lịch sử dự án. PR là tài liệu cho reviewer. Cả hai phải đọc được sau 6 tháng mà không cần hỏi tác giả.
> **Source:** Conventional Commits 1.0.0 + real-world team patterns.

---

## 1. AUTO-TRIGGER

```
DÙNG khi:
  ✓ User nói "commit", "push", "PR", "pull request", "merge request"
  ✓ User nói "viết commit message", "review PR #N"
  ✓ User nói "tách commit", "squash", "rebase", "git log"
  ✓ User nói "changelog", "CHANGELOG.md"
  ✓ Đang chuẩn bị `git commit` hoặc `gh pr create`
  ✓ User nói "branch", "branch name"

KHÔNG dùng khi:
  ✗ Debug code — dùng debug-first
  ✗ Code review nội dung — dùng code-review
  ✗ Deploy — dùng deploy skill
```

---

## 2. COMMIT MESSAGE RULES — CONVENTIONAL COMMITS

### Format bắt buộc

```
type(scope): subject

[body — optional]

[footer — optional]
```

### Types

| Type | Khi nào dùng | Xuất hiện trong CHANGELOG? |
|------|-------------|---------------------------|
| `feat` | Thêm tính năng mới (user-visible) | Có |
| `fix` | Sửa bug | Có |
| `docs` | Chỉ thay đổi documentation | Không |
| `style` | Format, dấu phẩy, whitespace — không đổi logic | Không |
| `refactor` | Restructure code — không thêm feature, không fix bug | Không |
| `test` | Thêm hoặc sửa tests | Không |
| `chore` | Build process, dependencies, tooling | Không |
| `perf` | Cải thiện performance | Có |
| `ci` | CI/CD config (GitHub Actions, Railway, etc.) | Không |
| `build` | Build system, external dependencies | Không |

### Subject rules

```
✓ Imperative mood: "add", "fix", "update" — KHÔNG "added", "fixing", "updates"
✓ Lowercase: "add user auth" — KHÔNG "Add User Auth"
✓ Không dấu chấm cuối: "fix price bug" — KHÔNG "fix price bug."
✓ Tối đa 72 ký tự (git log --oneline cắt ở đây)
✓ Mô tả WHAT thay đổi, không HOW
```

### Scope (optional nhưng khuyến khích)

```
feat(auth): add Google OAuth login
fix(orders): prevent negative stock on concurrent confirm
perf(products): add index on shop_id + is_active
chore(deps): upgrade fastapi to 0.115
```

Scope gợi ý theo project type:
- **Web app:** `auth`, `orders`, `products`, `dashboard`, `ui`, `api`
- **Monorepo:** `backend`, `admin`, `storefront`, `mobile`
- **Library:** `core`, `utils`, `types`, `parser`

---

## 3. GOOD VS BAD COMMITS — 10 EXAMPLES

| Bad | Good | Vấn đề |
|-----|------|--------|
| `fix bug` | `fix(orders): prevent race condition on stock deduction` | Bad không nói bug gì |
| `update code` | `refactor(products): extract price calculation to service layer` | Bad không có thông tin |
| `wip` | `feat(checkout): add VietQR payment method` | WIP không được commit vào main |
| `changes` | `chore(deps): upgrade sqlalchemy from 2.0.28 to 2.0.30` | Bad vô nghĩa sau 1 tuần |
| `fix typo` | `docs(readme): fix installation command in quickstart` | Bad không nói typo ở đâu |
| `add feature` | `feat(customers): add RFM segmentation (champions/loyal/at_risk)` | Bad không nói feature gì |
| `hotfix` | `fix(payments): add HMAC verify on VNPay IPN callback` | Bad không traceble |
| `refactor` | `refactor(auth): replace requests with httpx for async compat` | Bad thiếu context |
| `test` | `test(orders): add unit tests for status transition validation` | Bad không biết test gì |
| `style` | `style(dashboard): apply consistent gap-4/6/8 spacing` | Bad không nói scope |

---

## 4. ATOMIC COMMITS — 1 COMMIT = 1 LOGICAL CHANGE

### Nguyên tắc

```
Atomic commit nghĩa là:
  ✓ Một commit chỉ làm một việc
  ✓ Revert 1 commit không break tính năng khác
  ✓ Commit message mô tả đủ không cần đọc code
  ✓ `git bisect` có thể tìm bug chính xác đến commit
```

### Tách commit với `git add -p` (interactive staging)

```bash
# Thay vì: git add .
# Dùng:
git add -p              # chọn từng hunk để stage
# s = split hunk nhỏ hơn
# y = stage hunk này
# n = bỏ qua hunk này
# e = edit hunk thủ công
```

### Workflow tách commit

```bash
# Bước 1: Xem toàn bộ thay đổi
git diff

# Bước 2: Stage từng phần liên quan
git add -p backend/app/services/order_service.py   # stage chỉ logic order
git commit -m "fix(orders): validate transition before status update"

git add -p backend/app/api/v1/endpoints/orders.py  # stage endpoint riêng
git commit -m "feat(orders): add bulk status update endpoint"

# Bước 3: Phần còn lại
git add -p
git commit -m "test(orders): add tests for bulk status endpoint"
```

### Reset và chia lại commit cuối

```bash
# Undo commit VỪA LÀM nhưng giữ changes (chưa push thì an toàn)
git reset HEAD~1 --soft     # giữ staged changes
git reset HEAD~1 --mixed    # giữ changes, unstage (default)

# Sau đó dùng git add -p để stage lại từng phần
```

### Stash để làm sạch working tree

```bash
git stash push -m "wip: incomplete feature X"  # save tạm
git add -p && git commit -m "fix: ..."          # commit clean thứ khác
git stash pop                                   # lấy lại wip
```

---

## 5. KHÔNG BAO GIỜ

```
✗ git commit --no-verify
   Tại sao bad: bypass pre-commit hooks = bypass quality gates
   KHÔNG exception nào. Hooks fail = fix hooks, KHÔNG bypass.

✗ git push --force (hoặc -f) lên main/master
   Tại sao bad: xóa lịch sử shared branch = mất work của người khác
   Thay thế: git push --force-with-lease (safer, check remote không thay đổi)
   KHÔNG force push main. Bao giờ cũng không.

✗ git commit -m "fix"
   Tại sao bad: vô nghĩa sau 3 ngày, không thể dùng git bisect
   Fix: viết đủ type + scope + subject theo Conventional Commits

✗ git add . (không check git status trước)
   Tại sao bad: có thể stage .env, credentials, build artifacts
   Fix: git status → git diff --staged → rồi mới commit

✗ Squash public history (commits đã push lên shared branch)
   Tại sao bad: người khác đã base work trên commits đó → conflict
   OK để squash: feature branch chưa push, hoặc squash khi merge (PR)
   KHÔNG squash sau khi push lên remote shared branch

✗ git commit -m "wip"
   Tại sao bad: thông tin zero, không thể review, không thể revert
   Fix: nếu cần save tạm → git stash push -m "wip: description"
```

---

## 6. PR DESCRIPTION — TEMPLATE BẮT BUỘC

Mọi PR phải có đủ 5 phần:

```markdown
## Problem
<!-- Vấn đề gì đang xảy ra? Tại sao cần thay đổi này? -->
<!-- Ticket/issue link nếu có: Closes #123 -->

## Solution
<!-- Approach chọn là gì? Tại sao approach này? -->
<!-- Decision/trade-off nào đã cân nhắc? -->

## Testing
<!-- Đã test bằng cách nào? -->
<!-- - [ ] Manual test: steps cụ thể -->
<!-- - [ ] Unit tests added/updated -->
<!-- - [ ] Edge cases tested: empty state, error case -->

## Screenshots (nếu UI thay đổi)
<!-- Before / After screenshots -->
<!-- Mobile view nếu có responsive changes -->

## Checklist
- [ ] Commit messages theo Conventional Commits
- [ ] Không có debug code (`console.log`, `print`, `debugger`)
- [ ] Không có `.env` hay secrets trong diff
- [ ] Build pass (`npm run build` / `python -m py_compile`)
- [ ] Tests pass
- [ ] CHANGELOG.md cập nhật (nếu public API/breaking change)
```

Chi tiết hơn: xem `references/pr-templates.md`

---

## 7. PR SIZE GUIDELINES

### Kích thước lý tưởng

```
< 200 lines diff  → Perfect. Reviewer đọc 15 phút, approve ngay
200–400 lines     → OK. Cần context trong description
400–800 lines     → Khó review. Cân nhắc tách
> 800 lines       → PHẢI tách. Reviewer sẽ rubber-stamp = waste of time
```

### Cách tách PR lớn thành nhỏ

**Chiến lược 1: Feature flag (an toàn nhất)**
```bash
# PR 1: Thêm code mới nhưng DISABLED by feature flag
if settings.ENABLE_NEW_CHECKOUT:
    # new flow
else:
    # old flow

# PR 2: Backend + API changes (no frontend yet)
# PR 3: Frontend changes
# PR 4: Enable feature flag + cleanup old code
```

**Chiến lược 2: Stacked branches**
```bash
git checkout -b feat/base-refactor      # PR 1: foundation
git checkout -b feat/new-feature        # PR 2: feature (base = PR 1)
git checkout -b feat/new-feature-ui     # PR 3: UI (base = PR 2)
```

**Chiến lược 3: Separate concerns**
```
PR 1: Database migration + model changes
PR 2: Backend API + service layer
PR 3: Frontend integration
PR 4: Tests
```

### PR không nên chứa cùng lúc

```
✗ Feature mới + refactor không liên quan
✗ Bug fix + style cleanup toàn file
✗ Migration + business logic change
✗ 3 unrelated bug fixes trong 1 PR
→ Mỗi concern = 1 PR riêng
```

---

## 8. BRANCH NAMING

### Format

```
type/short-description-kebab-case
```

### Examples

```bash
# ✓ ĐÚNG
feat/google-oauth-login
fix/cart-quantity-overflow
fix/vnpay-hmac-signature
chore/upgrade-sqlalchemy-2-0-30
refactor/extract-pricing-service
docs/add-api-authentication-guide
test/order-status-transition-unit

# ✗ SAI
test                # không mô tả gì
wip                 # không bao giờ push wip branch
new-branch          # template name
fix1, fix2          # không semantic
Feature/AddPayment  # PascalCase, không convention
bugfix_VNPay        # underscore + không type prefix
```

### Branch lifecycle

```bash
# Tạo từ main (luôn update trước)
git checkout main && git pull
git checkout -b feat/new-feature

# Sync với main trong quá trình development
git fetch origin
git rebase origin/main   # hoặc merge, tùy team convention

# Xóa sau khi merge
git branch -d feat/new-feature              # local
git push origin --delete feat/new-feature   # remote
```

---

## 9. PRE-PUSH CHECKLIST

Chạy TRƯỚC khi `git push`. Mỗi checkbox FAIL = fix trước.

```
□ git status sạch? (không có untracked files bất ngờ)
   Run: git status

□ git diff --staged không có .env, secrets, credentials?
   Run: git diff --staged | grep -E "(SECRET|API_KEY|PASSWORD|TOKEN)" | grep -v "#"

□ Commit messages đúng Conventional Commits?
   Run: git log --oneline origin/main..HEAD
   Check: mỗi dòng có format "type(scope): subject"

□ Không có debug code còn sót?
   Run: git diff origin/main | grep -E "^\+(.*console\.log|debugger|print\(|pdb\.)"

□ Build pass?
   Frontend: npm run build (trong đúng project directory)
   Backend: python -m py_compile <files changed>

□ Tests pass?
   Run: npm test / pytest (nếu có test suite)

□ Branch name đúng convention?
   Run: git branch --show-current
   Check: format feat/fix/chore/docs/... + kebab-case
```

---

## 10. GIT RECOVERY RECIPES

### Undo commit cuối nhưng giữ changes

```bash
git reset HEAD~1 --soft    # giữ staged (ready to commit lại)
git reset HEAD~1 --mixed   # giữ unstaged (default, cần add lại)
git reset HEAD~1 --hard    # XÓA LUÔN changes (nguy hiểm, cẩn thận)
```

### Undo staged file (chưa commit)

```bash
git restore --staged <file>     # unstage, giữ changes trong working dir
git checkout -- <file>          # DISCARD changes (nguy hiểm)
```

### Sửa commit message cuối (chưa push)

```bash
git commit --amend -m "fix(orders): correct message"
# ⚠️ Chỉ dùng khi CHƯA push. Đã push → tạo commit mới thay vì amend.
```

### Recover deleted branch

```bash
# Tìm commit hash gần nhất của branch bị xóa
git reflog | grep "feat/deleted-branch-name"
# Tạo lại branch từ hash đó
git checkout -b feat/deleted-branch-name <commit-hash>
```

### Cherry-pick commit từ branch khác

```bash
# Lấy commit hash cụ thể
git log --oneline feat/other-branch
# Apply sang branch hiện tại
git cherry-pick <commit-hash>
```

### Commit nhầm branch

```bash
# Bước 1: Copy commit hash
git log --oneline -1    # copy hash của commit nhầm

# Bước 2: Undo trên branch sai
git reset HEAD~1 --soft

# Bước 3: Sang đúng branch
git stash
git checkout correct-branch
git stash pop

# Bước 4: Commit lại
git add -p && git commit -m "type(scope): message"
```

### Xem lịch sử đầy đủ (kể cả deleted)

```bash
git reflog                          # mọi thứ đã xảy ra
git log --oneline --graph --all     # visual branch history
git log --oneline --grep="feat"     # filter theo keyword
```

---

## REFERENCES

- `references/conventional-commits.md` — Full specification, breaking changes, emoji mapping, changelog generation
- `references/pr-templates.md` — 3 PR templates (feature/bugfix/chore) + reviewer checklist + merge strategies
