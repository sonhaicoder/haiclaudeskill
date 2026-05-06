# PR Templates & Review Guide

---

## Template 1 — Feature PR

Dùng khi: thêm tính năng mới, bất kể lớn hay nhỏ.

```markdown
## Problem
<!-- Vấn đề hoặc user need đang giải quyết -->
<!-- Seller mất 30 phút viết mô tả SP → cần AI làm trong 10 giây -->
<!-- Ticket: Closes #123 -->

## Solution
<!-- Approach đã chọn và lý do -->
<!-- Đã cân nhắc những approach nào khác? Tại sao không chọn? -->
<!-- Trade-off nào được chấp nhận? -->

Example:
Implemented AI Content Studio using 9router gateway (Groq → Gemini fallback).
Chose streaming response over batch for better perceived performance.
Rejected direct OpenAI call: no fallback, higher cost, no caching.

## What Changed
<!-- List các thay đổi chính, không phải từng commit -->
- Added `POST /shops/{id}/ai/content-studio` endpoint
- New `AIContentService` with multi-provider fallback
- Admin UI: Content Studio panel in ProductFormModal
- i18n: 12 new keys in vi.json + en.json

## Testing
<!-- Cụ thể — không phải "tested manually" -->
- [ ] Happy path: generate content for product with name + category
- [ ] Fallback: Groq down → Gemini picked up automatically
- [ ] Quota enforcement: free tier blocked after 10 requests/day
- [ ] Empty input validation: returns 422 with Vietnamese error message
- [ ] Mobile: panel displays correctly on 375px width

## Screenshots
<!-- Before / After cho mọi UI change -->
<!-- Mobile view nếu responsive thay đổi -->

## Checklist
- [ ] Conventional commit messages
- [ ] No debug code (`console.log`, `print`, `pdb`)
- [ ] No `.env` or secrets in diff (`git diff --staged | grep -i secret`)
- [ ] Build pass: `npm run build` + `python -m py_compile`
- [ ] i18n: both `vi.json` and `en.json` updated
- [ ] shop_id filter on all new queries (if backend)
- [ ] Decimal for all money fields (if backend)
- [ ] Loading / Empty / Error states (if frontend)
```

---

## Template 2 — Bug Fix PR

Dùng khi: fix bug, security patch, hotfix.

```markdown
## Bug Description
<!-- Mô tả bug: ai bị ảnh hưởng, mức độ nghiêm trọng -->
<!-- Severity: Critical / High / Medium / Low -->
Severity: High — Affects all shops using MoMo payment

MoMo IPN callback was not verifying HMAC signature, allowing
attackers to forge "paid" status without actually paying.

## Root Cause
<!-- Tại sao bug xảy ra — đừng mô tả symptom, mô tả cause -->
`payment_service.py:214` trusts callback payload directly.
VNPay already had HMAC verify; MoMo implementation was copy-pasted
without adding the signature check step.

## Reproduction Steps
<!-- Steps cụ thể để reproduce, trước khi fix -->
1. Create order with MoMo payment method
2. Send fake IPN callback: `POST /payments/momo/callback` with
   arbitrary `resultCode: 0` (success) payload
3. Before fix: order.payment_status updated to "paid"
4. After fix: 400 returned, payment_status unchanged

## Fix
<!-- Giải thích fix, không chỉ list files changed -->
Added `verify_momo_signature()` function matching MoMo docs HMAC-SHA256 spec.
Called before any payload processing. Returns 400 on mismatch.
Pattern mirrors existing `verify_vnpay_signature()`.

## What Changed
- `backend/app/services/payment_service.py`: add `verify_momo_signature()`
- Called at line 214 before `update_payment_status()`

## Testing
- [ ] Valid signature: payment status updates correctly
- [ ] Invalid signature: 400 returned, status unchanged
- [ ] Missing signature field: 400 returned
- [ ] Replay attack (old timestamp): 400 returned

## Regression Risk
<!-- Những gì có thể bị ảnh hưởng bởi fix này -->
Low — only affects MoMo IPN path. VNPay and COD untouched.
Verified: existing MoMo orders with real callbacks still process correctly.

## Checklist
- [ ] Security: no new attack surface introduced
- [ ] Existing behavior preserved for valid callbacks
- [ ] Error messages in Vietnamese with diacritics
- [ ] Added to KNOWN_BUGS.md as "Fixed" with commit hash
```

---

## Template 3 — Chore / Refactor PR

Dùng khi: refactor, dependency upgrade, tooling, no user-visible change.

```markdown
## Motivation
<!-- Tại sao làm cái này? Business value hoặc tech debt reason -->
`smtplib` is synchronous and blocks the async event loop when sending emails.
Under load (order confirmations spike), this caused P99 latency > 5s.

## What Changed
<!-- Before / After kèm đo lường nếu có -->

Before:
```python
smtplib.SMTP(settings.SMTP_HOST).send_message(msg)  # blocks event loop
```

After:
```python
await asyncio.get_event_loop().run_in_executor(None, _send_sync, msg)
```

P99 email send: 4.8s → 0.3s (measured with locust on staging, 50 concurrent)

## Risk Assessment
<!-- Cái gì có thể vỡ? Ai bị ảnh hưởng? -->
Low risk — same SMTP library, same config, same email content.
Only the threading model changed. Email delivery unchanged.
Tested: 200 emails sent on staging, 0 failures.

## No Behavior Change Confirmation
<!-- Khẳng định: không có thay đổi visible với user -->
- [ ] Email content identical (checked with diff on rendered templates)
- [ ] Delivery timing same or faster
- [ ] No new env vars required
- [ ] No API contract changes

## Rollback Plan
<!-- Nếu vỡ production, rollback thế nào? -->
Revert this PR. Single commit, no migration needed.
Email still functions (just slower) on revert.

## Checklist
- [ ] No user-visible behavior changes
- [ ] Performance measured before + after (if applicable)
- [ ] All tests pass
- [ ] No scope creep (only touched what's needed for this refactor)
```

---

## Reviewer Checklist — Dành cho Người Review (Không Phải Author)

Khi review PR của người khác, check các điểm này:

```
LOGIC
□ Code làm đúng cái PR description nói không?
□ Edge case nào chưa xử lý? (empty input, network fail, concurrent access)
□ Business logic có đúng với domain requirements không?
□ Error handling đủ không? (không nuốt exception)

SECURITY
□ Có SQL injection vector không? (f-string SQL, raw query)
□ Có auth/permission check trên mọi endpoint không?
□ Input validation đủ không? (user input đều qua schema)
□ Không có hardcoded secret nào trong diff?
□ Payment callback: có verify signature không?

QUALITY
□ Có test cho behavior mới không?
□ Test có meaningful assertions hay chỉ check "no exception"?
□ Tên biến/function có mô tả đúng behavior không?
□ Có comment giải thích "tại sao" cho logic phức tạp không?

STYLE (project-specific)
□ Tiền dùng Decimal, không float?
□ shop_id filter mọi query?
□ Text tiếng Việt có dấu đầy đủ?
□ i18n key có trong cả vi.json và en.json?
□ Spacing đúng gap-4/6/8, không random value?
```

---

## Cách Viết PR Feedback Tốt

### Phân biệt loại comment

| Prefix | Nghĩa | Tác giả cần làm |
|--------|-------|----------------|
| `nit:` | Nitpick nhỏ, optional | Có thể ignore nếu không đồng ý |
| `question:` | Chưa hiểu, cần giải thích | Giải thích hoặc refactor cho rõ |
| `suggestion:` | Có cách tốt hơn, không bắt buộc | Cân nhắc |
| `must:` | Phải fix trước khi merge | Fix, không discuss |
| `BLOCKER:` | Critical — PR không merge được | Fix ngay |

### Good vs Bad Feedback

```
✗ BAD: "This is wrong"
✓ GOOD: "must: This triggers N+1 queries — add selectinload(Order.items)
         to avoid separate query per order in the loop (line 47)"

✗ BAD: "Style issue"
✓ GOOD: "nit: gap-3 on line 82 — project convention is gap-4. Minor but
         inconsistent with Dashboard/Orders pages"

✗ BAD: "Why did you do it this way?"
✓ GOOD: "question: Why sync SMTP on line 214 instead of run_in_executor?
         At scale this will block the event loop — is there a reason to
         keep it sync?"

✗ BAD: "Add tests"
✓ GOOD: "must: Missing test for the error path when stock < quantity.
         This was the root cause of #87 — we need this covered."
```

### Approving vs Requesting Changes

```
Approve → "LGTM" khi: logic đúng, tests có, style ok, nit đã note
Request changes khi: BLOCKER hoặc must chưa addressed
Comment only khi: chỉ có nit/suggestion, author có thể self-merge
```

---

## Merge Strategies — Khi Nào Dùng Gì

### Squash and Merge

```
Dùng khi:
  ✓ Feature branch có nhiều "wip" commits
  ✓ Muốn main history sạch (1 commit per feature)
  ✓ Branch commits không atomic (nhiều "fix", "update")

Kết quả:
  main: "feat(auth): add Google OAuth login (#42)"  ← 1 commit sạch

Không dùng khi:
  ✗ Commits đã được carefully crafted atomic
  ✗ Branch là shared (người khác có thể base work trên đó)
```

### Rebase and Merge

```
Dùng khi:
  ✓ Branch commits đã atomic + conventional
  ✓ Muốn giữ full commit history trong main
  ✓ Each commit deployable independently

Kết quả:
  main: feat(auth): add OAuth service
        feat(auth): add OAuth callback endpoint
        test(auth): add OAuth integration tests

Không dùng khi:
  ✗ Branch có merge commits (complex history)
  ✗ Branch commits messy ("fix", "wip", "update")
```

### Create Merge Commit

```
Dùng khi:
  ✓ Long-running release branch
  ✓ Need explicit record that branch was merged at this point
  ✓ Team prefers merge commit for traceability

Kết quả:
  main: Merge pull request #42 from feat/google-oauth

Không dùng khi:
  ✗ Feature branches (creates noisy history)
  ✗ Hotfix PRs (squash cleaner)
```

### Rule of thumb

```
Feature PR (new feature)     → Squash and Merge (clean history)
Bug Fix PR (hotfix)          → Squash and Merge
Refactor PR (atomic commits) → Rebase and Merge
Release branch               → Merge Commit
```

---

## GitHub CLI Commands

### Tạo PR

```bash
# Basic
gh pr create --title "feat(auth): add Google OAuth login" \
  --body "$(cat <<'EOF'
## Problem
...

## Solution
...
EOF
)"

# Với base branch cụ thể
gh pr create --base main --head feat/google-oauth \
  --title "feat(auth): add Google OAuth login"

# Draft PR (chưa ready for review)
gh pr create --draft --title "WIP: feat(auth): add Google OAuth"

# Gán reviewer
gh pr create --reviewer username1,username2
```

### Review PR

```bash
# Xem diff
gh pr diff 42

# Approve
gh pr review 42 --approve --body "LGTM, tests pass"

# Request changes
gh pr review 42 --request-changes \
  --body "must: missing shop_id filter on line 47"

# Comment only
gh pr review 42 --comment --body "nit: consider extracting to service"
```

### Merge PR

```bash
# Squash (recommended cho feature PR)
gh pr merge 42 --squash --delete-branch

# Rebase (cho atomic commits)
gh pr merge 42 --rebase --delete-branch

# Merge commit
gh pr merge 42 --merge

# Auto-merge khi CI pass
gh pr merge 42 --squash --auto --delete-branch
```

### Useful PR commands

```bash
gh pr list                          # list open PRs
gh pr list --state merged           # merged PRs
gh pr view 42                       # view PR details
gh pr checks 42                     # CI status
gh pr checkout 42                   # checkout PR branch locally
gh pr close 42                      # close without merging
gh pr ready 42                      # mark draft PR as ready
```
