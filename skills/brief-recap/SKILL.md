---
name: brief-recap
description: Trả lời NGẮN GỌN nhưng kèm 1-2 dòng giải thích cái em vừa làm để anh hiểu — anh là dev mobile (Flutter) nên dùng ngôn ngữ tech bình thường được, KHÔNG cần dumbing down, chỉ cần ngắn + rõ + giải thích phần web/backend mà anh không quen sâu. Auto-trigger sau MỌI task code/edit/fix/build. Trigger keywords: "làm xong báo anh", "tóm tắt", "giải thích".
---

# brief-recap — Ngắn + Đủ Hiểu

## CONTEXT VỀ ANH

```
Anh = dev mobile (Flutter, Riverpod, Dio).
Anh hiểu: state management, async, API, DB cơ bản, OOP, architecture patterns.
Anh KHÔNG quen sâu: React internals, SQLAlchemy quirks, Celery, FastAPI patterns,
                    TailwindCSS edge cases, build tooling web.

→ Dùng tech term BÌNH THƯỜNG, không dumbing down ("tách logic" thay vì "tách component" là sai).
→ Chỉ giải thích thêm khi gặp khái niệm WEB/BACKEND-SPECIFIC mà mobile không có.
```

## FORMAT MẶC ĐỊNH

```
[1 câu kết quả — vào thẳng]

**Đã làm:**
- [hành động + lý do tech ngắn]
- [hành động]
- [hành động — tối đa 5 bullet]

[Next step nếu cần test, bỏ qua nếu không]
```

## VÍ DỤ

### Bug fix nhỏ
```
Fix bug trang orders load chậm — do useEffect re-fetch vô tận.

**Đã làm:**
- Fix dependency array của useEffect (thiếu memoize callback)
- Wrap fetchOrders bằng useCallback
- Build pass

Test: mở /orders → check Network tab xem còn spam request không.
```

### Feature mới (web)
```
Xong feature import sản phẩm Excel.

**Đã làm:**
- Backend: endpoint POST /products/import nhận file .xlsx, parse bằng openpyxl, validate Decimal cho giá
- Admin: drag-drop modal, hiển thị preview 5 dòng đầu trước khi confirm
- Atomic insert: nếu 1 dòng lỗi → rollback cả batch (tránh import nửa vời)

Test: /products → Import → upload file mẫu xem có preview không.
```

### Backend refactor
```
Tối ưu query orders list — N+1 → 1 query.

**Đã làm:**
- Thay lazy="noload" của Order.items bằng selectinload trong list endpoint
  (SQLAlchemy default: mỗi order trigger 1 query con để load items → 50 orders = 51 queries)
- Giờ JOIN sẵn → 1 query duy nhất
- Test load 100 orders: 800ms → 80ms
```
**(Note: giải thích `selectinload` vì đây là SQLAlchemy-specific, anh quen Dio thì không gặp)**

### React-specific
```
Sửa modal bị header sidebar che.

**Đã làm:**
- Move modal ra ngoài DOM tree bằng React Portal (mount vào document.body thay vì component cha)
  → tránh bị overflow:hidden / z-index của parent ảnh hưởng
- Pattern này dùng cho mọi Modal/Drawer/Toast từ giờ
```
**(Note: giải thích Portal vì Flutter có Navigator/Overlay tương tự nhưng cơ chế khác)**

## QUY TẮC

| Khái niệm | Có cần giải thích thêm không? |
|-----------|------------------------------|
| `useState`, `useEffect`, `useCallback` | KHÔNG — anh hiểu hooks |
| `async/await`, `Promise` | KHÔNG |
| `JWT`, `bcrypt`, `HMAC` | KHÔNG |
| `Decimal precision` | KHÔNG — đã có rule trong CLAUDE.md |
| `React Portal` | CÓ — mobile không có khái niệm này |
| `SQLAlchemy lazy/eager loading` | CÓ — Dio không có |
| `Celery / background task` | CÓ ngắn — Flutter dùng isolate khác |
| `TailwindCSS arbitrary values` | CÓ ngắn |
| `Vite / Next.js SSR` | CÓ ngắn |
| `Atomic SQL update` | KHÔNG — anh hiểu race condition |
| `Connection pool` | KHÔNG |

## ĐỘ DÀI

```
Bug fix 1 dòng:        1 câu — "Fix X bằng cách Y."
Bug fix vừa:           2-3 bullet
Feature nhỏ:           3-5 bullet + next step
Feature lớn:           5 bullet + section "Cần test" cụ thể
Refactor:              Nói cũ làm gì, mới làm gì, tại sao tốt hơn
```

## ANTI-PATTERNS

```
✗ Paste file paths: "Sửa OrdersPage.tsx line 142, OrderModal.tsx line 88..."
  → Anh không cần biết line. Anh cần biết FEATURE thay đổi gì.

✗ Liệt kê hành động trước, kết quả sau:
  "Em đã refactor X, sau đó update Y, cuối cùng test Z..."
  → Vào kết quả luôn ở câu đầu.

✗ Quá dumbing down: "Em sửa cái nút bấm cho nó không bị bug nữa"
  → Anh là dev. Nói "fix onClick handler bị stale closure" được.

✗ Quá technical: paste stack trace, error message dài
  → Tóm tắt root cause 1 câu.

✗ Sycophantic mở đầu: "Em đã hoàn thành task...", "Tuyệt vời, em sẽ..."
  → CẤM. Vào thẳng.

✗ Thiếu next step khi UI thay đổi
  → Phải nói anh test URL nào, click gì.
```

## SELF-CHECK

```
□ Câu đầu = KẾT QUẢ (không phải "em đã làm...")?
□ Bullets ngắn, mỗi cái 1 ý?
□ Có giải thích thêm khi gặp khái niệm web/backend-specific?
□ KHÔNG dumbing down khái niệm chung (state, async, JWT...)?
□ KHÔNG paste file path / line number?
□ Có next step test nếu UI thay đổi?
□ Tổng < 10 dòng (trừ feature lớn)?
```

---

**Mục tiêu:** Anh đọc 10 giây hiểu vừa làm gì + tại sao + cần test gì. Đủ tin để ship hoặc tự test.
