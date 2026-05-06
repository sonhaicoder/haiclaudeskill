# Git Bisect — Tìm Commit Gây Ra Bug Bằng Binary Search

> "Worked in v1.2, broken in v1.5, 50 commits ở giữa."
> Git bisect tìm ra exact commit trong ~6 bước thay vì check từng commit.

---

## 1. Git Bisect là gì?

Git bisect dùng binary search để tìm commit đầu tiên gây ra bug.

**Ý tưởng:**
- Bạn biết commit GOOD (code chạy đúng) và commit BAD (code broken)
- Git checkout midpoint → bạn test → báo good/bad
- Git tiếp tục chia đôi vùng chưa kiểm tra
- Sau O(log n) bước → tìm ra exact "first bad commit"

**Ví dụ:** 64 commits ở giữa → tối đa 6 bước (log₂64 = 6).

---

## 2. Khi nào dùng bisect

**DÙNG khi:**
- Bug xuất hiện trong một khoảng thời gian cụ thể ("hồi tháng trước còn chạy")
- Không biết commit nào gây ra
- Có nhiều commits (>5) cần kiểm tra
- Có cách TEST rõ ràng: chạy được → good, crash/fail → bad

**KHÔNG DÙNG khi:**
- Bug luôn tồn tại (không có "good" commit để reference)
- Lỗi phụ thuộc vào state bên ngoài (database, env vars thay đổi)
- Commits ở giữa có database migration → checkout cũ sẽ fail schema mismatch
- Feature flags thay đổi behavior — bisect có thể blame nhầm commit vô tội

---

## 3. Step-by-Step Workflow

### Chuẩn bị

```bash
# Kiểm tra bạn biết:
# 1. Commit/tag nào là GOOD (code chạy đúng)
# 2. Commit/tag nào là BAD (hiện tại, broken)

# Xem recent tags:
git tag --sort=-creatordate | head -20

# Tìm commit khoảng thời gian cụ thể:
git log --oneline --after="2026-04-01" --before="2026-04-15"
```

### Bắt đầu bisect

```bash
git bisect start
git bisect bad                  # commit hiện tại (HEAD) là broken
git bisect good v1.2.0          # tag/commit cuối biết là chạy đúng
# Hoặc dùng commit hash:
git bisect good abc1234
```

Git sẽ:
1. Tính số commits ở giữa
2. Checkout midpoint commit
3. In ra: `Bisecting: 25 revisions left to test after this (roughly 5 steps)`

### Test và đánh dấu

```bash
# Sau mỗi lần git checkout midpoint:
# 1. Chạy test / reproduce bug

npm run test         # hoặc
python test_bug.py   # hoặc
curl localhost:8001/api/health  # bất kỳ cách nào verify

# 2. Báo kết quả:
git bisect good    # code này KHÔNG bị bug
git bisect bad     # code này CÓ bug
```

Git tiếp tục checkout commit mới để test. Lặp lại cho đến khi:

```
abc1234def is the first bad commit
commit abc1234def
Author: Dev Name <dev@example.com>
Date:   Wed May 6 14:23:00 2026

    feat: thêm order status validation

 backend/app/services/order_service.py | 15 +++++++++------
```

### Kết thúc bisect

```bash
git bisect reset    # Trở về HEAD, thoát bisect mode
```

**Quan trọng:** Luôn `git bisect reset` trước khi làm việc khác. Quên reset → bạn đang ở detached HEAD.

---

## 4. Automated Bisect với Test Script

Nếu có script test tự động, git bisect có thể chạy toàn bộ không cần tương tác:

```bash
git bisect start
git bisect bad HEAD
git bisect good v1.2.0

# Chạy tự động với test script
git bisect run python test_specific_bug.py
```

**Yêu cầu script:**
- Exit code **0** = commit GOOD (không có bug)
- Exit code **1-127** (trừ 125) = commit BAD (có bug)
- Exit code **125** = commit không test được → skip

```python
# test_specific_bug.py — ví dụ
import sys
import subprocess

result = subprocess.run(
    ["python", "-c", "from app.services.order import validate_status; validate_status('pending', 'shipped')"],
    capture_output=True
)

if result.returncode == 0:
    print("GOOD — validation works")
    sys.exit(0)
else:
    print("BAD — validation broken")
    sys.exit(1)
```

```bash
# Ví dụ với pytest:
git bisect run pytest tests/test_order.py::test_status_transition -x -q
# -x = stop on first failure
# -q = quiet output
```

---

## 5. Common Gotchas

### Detached HEAD State

```bash
# Trong bisect, bạn ở trạng thái "detached HEAD"
# git status sẽ hiện:
HEAD detached at abc1234

# ĐỪNG commit trong lúc bisect
# ĐỪNG tạo branch trong lúc bisect
# Khi xong: git bisect reset → trở về branch bình thường
```

### Skip commit không test được

```bash
# Một số commits ở giữa có thể không build được (broken unrelated to your bug)
# Dùng skip để bỏ qua:
git bisect skip

# Skip nhiều commits:
git bisect skip abc123 def456 ghi789

# Skip một range:
git bisect skip abc123..def456
```

### Khi bisect báo wrong commit

```bash
# Nếu bisect tìm ra commit nhưng bạn nghĩ không đúng:
# 1. Chạy lại từ đầu với good/bad rõ hơn
git bisect reset
git bisect start
git bisect bad <commit_rõ_ràng_hơn>
git bisect good <commit_rõ_ràng_hơn>

# 2. Kiểm tra có dependency ngoài không (database, env vars)
# Bisect chỉ đúng khi bug 100% là code issue
```

### Build steps giữa commits

```bash
# Nếu project cần build trước khi test:
# Viết script bao gồm cả build step
# test_with_build.sh:
#!/bin/bash
npm install --silent || exit 125  # skip nếu install fail
npm run build --silent || exit 125
npm test -- --testPathPattern="OrderStatus" || exit 1
exit 0

git bisect run bash test_with_build.sh
```

---

## 6. Alternative: Tìm Khi File Thay Đổi

Không cần bisect nếu bạn biết BUG Ở FILE NÀO — chỉ cần tìm commits đã sửa file đó:

```bash
# Tất cả commits đã thay đổi file cụ thể:
git log --oneline --diff-filter=M -- backend/app/services/order_service.py

# Output:
abc1234 feat: thêm status validation
def5678 fix: sửa race condition
ghi9012 refactor: tách service

# Chỉ commits thay đổi FUNCTION cụ thể (git pickaxe):
git log --oneline -S "validate_status" -- backend/app/services/order_service.py
#                  ↑ tìm commits add/remove string này

# Xem diff của 1 commit cụ thể với file:
git show abc1234 -- backend/app/services/order_service.py
```

### Tìm khi một string xuất hiện/biến mất:

```bash
# Commit nào thêm/xóa "VALID_TRANSITIONS":
git log --oneline -S "VALID_TRANSITIONS" -- backend/

# Commit nào thêm/xóa pattern (regex):
git log --oneline -G "status.*transition" -- backend/
```

### So sánh 2 commits:

```bash
# Diff giữa 2 tags:
git diff v1.2.0..v1.5.0 -- backend/app/services/order_service.py

# Blame — xem từng dòng được thay đổi bởi commit nào:
git blame backend/app/services/order_service.py

# Blame một range dòng cụ thể:
git blame -L 42,55 backend/app/services/order_service.py
```

---

## 7. Quick Reference

```bash
# === BẮT ĐẦU ===
git bisect start
git bisect bad                    # HEAD broken
git bisect good <tag/hash>        # last known good

# === TRONG QUÁ TRÌNH ===
git bisect good                   # commit này không có bug
git bisect bad                    # commit này có bug
git bisect skip                   # commit này không test được

# === TỰ ĐỘNG ===
git bisect run <test-script>      # chạy script tự động

# === KẾT THÚC ===
git bisect reset                  # LUÔN chạy khi xong

# === KHÔNG CẦN BISECT ===
git log --oneline -S "keyword" -- path/to/file    # tìm khi string thay đổi
git log --oneline -- path/to/file                  # tất cả commits sửa file
git blame -L <start>,<end> path/to/file            # ai sửa dòng nào
```
