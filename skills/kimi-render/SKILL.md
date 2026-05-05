---
name: kimi-render
description: Công thức render UI web production-grade như Kimi (Wanderlust/Vivu quality). 7 pattern lặp lại + 3 file md spec (design/outline/interaction) + template HTML single-file. Dùng khi build landing/storefront/marketing page/SaaS UI mới từ đầu. Auto-trigger khi user nói "render UI đẹp", "build landing", "tạo page mới từ đầu", "UI quality như Kimi", "prototype HTML". BỔ SUNG cho frontend-design — không thay thế. frontend-design = 7 công thức bí mật typography/spacing/color; kimi-render = 7 pattern render + spec-first workflow + template.
---

# kimi-render — Công Thức Render UI Như Kimi

## CHO BIẾT TRƯỚC

Đây là skill **spec-first + pattern-driven**. Không "sáng tạo tự do".

```
Nguyên lý:  UI đẹp KHÔNG đến từ model giỏi.
            UI đẹp đến từ SPEC ÉP CHẶT + 7 PATTERN LẶP LẠI.

Kimi đẹp:    vì có bộ 3 file md (design/outline/interaction) ép model fill trước khi code.
Wanderlust:  đẹp vì lặp lại 7 pattern ở 100% các section.
Commerce:    xấu vì mỗi agent render 1 kiểu, không có spec chung.
```

---

## KHI NÀO INVOKE

Invoke skill này khi:

- User yêu cầu **build landing/marketing/storefront/SaaS UI từ đầu**
- User nói "render đẹp như Kimi/Wanderlust/Vivu"
- User yêu cầu **prototype HTML single-file** (no build step)
- Build page mới mà **chưa có design system** (brand chưa rõ)
- Refactor UI xấu → đẹp, cần follow công thức chặt

**KHÔNG dùng khi:**
- Đã có design system production rồi → dùng `frontend-design`
- Admin dashboard đã có theme (như Apple light) → dùng theme hiện tại
- Task nhỏ: sửa 1 button, đổi 1 text → không cần spec
- Mobile app (Flutter/RN) → dùng `mobile-design`

---

## WORKFLOW BẮT BUỘC — 3 GIAI ĐOẠN

### Giai đoạn 1: SPEC TRƯỚC (không được skip)

Khi page/feature lớn (>1 section), BẮT BUỘC tạo bộ 3 file md trong `.design/` của project TRƯỚC KHI viết code:

```
<project>/.design/<feature-name>/
├── design.md        # Design system: color/font/spacing/animation
├── outline.md       # File structure + page sections + libraries
└── interaction.md   # Micro-interactions + user journey + mobile
```

Format 3 file này xem trong [references/spec-templates.md](references/spec-templates.md).

**Nếu skip spec** → output sẽ giống "generic AI UI" (xám xịt, thiếu linh hồn). Đã verify nhiều lần.

### Giai đoạn 2: CHỌN TEMPLATE STARTER

Có 2 template single-file sẵn:

| Template | Khi dùng | File |
|----------|---------|------|
| `saas-landing.html` | Landing page SaaS, booking, marketplace, e-commerce homepage | [templates/saas-landing.html](templates/saas-landing.html) |
| `editorial.html` | Magazine, portfolio, brand story, fashion, content-heavy | [templates/editorial.html](templates/editorial.html) |

Copy template → fill brand colors → tweak sections theo spec.

### Giai đoạn 3: APPLY 7 PATTERN TRÊN MỌI SECTION

Đây là phần **KHÔNG được phá**. Mỗi section trên page PHẢI có đủ 7 pattern sau.

---

## 7 PATTERN LẶP LẠI (công thức Wanderlust)

### Pattern 1: Eyebrow Tag (nhãn nhỏ trên heading)

```html
<span class="inline-block px-4 py-1.5 bg-[accent-bg] text-[primary]
             text-xs font-bold uppercase tracking-widest rounded-full mb-4">
  KHÁM PHÁ
</span>
```

- Luôn `uppercase` + `tracking-widest` + `font-bold text-xs`
- Background = màu secondary/accent nhạt (10-20% opacity primary)
- Text = primary color
- `rounded-full` (pill shape)
- Đặt TRÊN mọi section heading (trừ hero)

### Pattern 2: Display Heading 3-cấp

```html
<!-- Section heading -->
<h2 class="font-display text-3xl sm:text-4xl lg:text-5xl font-bold text-dark mb-4 leading-tight">
  Điểm đến nổi bật
</h2>

<!-- Hero heading -->
<h1 class="font-display text-4xl sm:text-5xl lg:text-7xl font-bold leading-tight">
  Khám phá thế giới<br>
  <span class="text-transparent bg-clip-text bg-gradient-to-r from-[c1] to-[c2]">
    cùng Wanderlust
  </span>
</h1>
```

- **2 font**: `font-display` (Poppins/Fraunces) + `font-sans` (Inter/Be Vietnam Pro)
- Hero: 4xl → 7xl responsive
- Section: 3xl → 5xl responsive
- `leading-tight` trên heading, `leading-relaxed` trên body
- **Gradient accent** chỉ trên 1-2 từ quan trọng nhất trong hero

### Pattern 3: Subtitle Muted

```html
<p class="text-slate-500 max-w-xl mx-auto leading-relaxed">
  Những địa điểm du lịch được yêu thích nhất...
</p>
```

- Text `text-slate-500` hoặc `text-[ink-500]` (không phải đen)
- `max-w-xl` hoặc `max-w-2xl` → giới hạn chiều ngang
- `mx-auto` nếu section center, bỏ nếu left-aligned
- `leading-relaxed` cho dễ đọc

### Pattern 4: Gradient Button + Colored Shadow

```html
<button class="px-6 py-3.5 bg-gradient-to-r from-[primary] to-[primary-dark]
               text-white font-semibold rounded-xl
               shadow-lg shadow-[primary]/30
               hover:shadow-xl hover:shadow-[primary]/40
               transition-all active:scale-[0.98]
               flex items-center justify-center gap-2">
  <i class="fa-solid fa-magnifying-glass"></i>
  Tìm kiếm
</button>
```

**4 tầng chiều sâu:**
1. Gradient background (2 tone primary)
2. Colored shadow có opacity (25-30% → 40% khi hover)
3. `transition-all` smooth
4. `active:scale-[0.98]` → tactile feedback khi click

Secondary button thì: `bg-white border border-slate-200` + no shadow.

### Pattern 5: Card với Hover Lift

```html
<div class="card-hover bg-white rounded-2xl overflow-hidden shadow-sm">
  <img class="w-full h-48 object-cover" />
  <div class="p-6">
    <h3 class="font-display text-xl font-bold mb-2">Title</h3>
    <p class="text-slate-500 text-sm mb-4">Description</p>
    <div class="flex items-center justify-between">
      <span class="text-primary font-bold">1.200.000đ</span>
      <button class="...">Chi tiết</button>
    </div>
  </div>
</div>

<style>
.card-hover { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
.card-hover:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(0,0,0,0.12); }
</style>
```

- `rounded-2xl` (không dùng `rounded-md/lg` → quá nhỏ)
- Shadow đậm dần khi hover
- `translateY(-8px)` → lift effect
- Cubic-bezier Material: `(0.4, 0, 0.2, 1)`

### Pattern 6: Form Input với Focus Ring

```html
<div>
  <label class="block text-xs font-semibold text-slate-500 uppercase tracking-wider mb-1.5">
    Địa điểm
  </label>
  <div class="relative">
    <i class="fa-solid fa-location-dot absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400"></i>
    <input type="text" placeholder="Bạn muốn đi đâu?"
           class="w-full pl-10 pr-4 py-3
                  bg-slate-50 border border-slate-200 rounded-xl text-sm
                  focus:outline-none focus:ring-2 focus:ring-[primary]/20 focus:border-[primary]
                  transition-all">
  </div>
</div>
```

- **Label uppercase** `text-xs tracking-wider` → editorial feel
- Input `bg-slate-50` (không phải trắng) → mềm hơn
- **Icon absolute trong input** (left-3.5)
- Focus: ring 2px với opacity + border primary
- `rounded-xl` cho input
- Placeholder là GỢI Ý cụ thể (không trùng label)

### Pattern 7: Stagger Animation trên Reveal

```html
<div class="fade-in stagger-1">...</div>
<div class="fade-in stagger-2">...</div>
<div class="fade-in stagger-3">...</div>

<style>
.fade-in { animation: fadeIn 0.6s ease-out forwards; opacity: 0; }
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}
.stagger-1 { animation-delay: 0.1s; }
.stagger-2 { animation-delay: 0.25s; }
.stagger-3 { animation-delay: 0.4s; }
.stagger-4 { animation-delay: 0.55s; }
</style>
```

- Hero elements: entrance immediate
- Below-fold elements: Intersection Observer + `.reveal.show` class
- Stagger delay: 0.1s → 0.25s → 0.4s → 0.55s (exponential cảm giác)
- **KHÔNG** dùng delay >0.8s (user impatient)

---

## BRAND COLOR RECIPE (3 tầng)

Mỗi brand CẦN định nghĩa đủ 3 tầng:

```js
// tailwind.config inline
colors: {
  // TẦNG 1: BRAND (signature)
  primary: '#0ea5e9',       // sky-500 — CTA, links, accent
  secondary: '#f0f9ff',     // sky-50 — eyebrow bg, card bg nhẹ

  // TẦNG 2: SEMANTIC
  accent: '#22c55e',        // green — success, badge
  accentOrange: '#f97316',  // orange — hot/sale badge
  danger: '#ef4444',        // red

  // TẦNG 3: INK (text + structure)
  dark: '#0f172a',          // slate-900 — heading, footer bg
  ink: {
    700: '#334155',         // body text
    500: '#64748b',         // muted
    300: '#cbd5e1',         // disabled
  }
}
```

**KHÔNG** dùng màu random (purple/pink/teal) trừ khi có lý do brand. Stick với 1 brand color + neutrals.

---

## TYPOGRAPHY PAIRING RECIPE

Chọn 1 trong 3 combo này:

| Style | Display | Body | Feel |
|-------|---------|------|------|
| **Modern SaaS** | Poppins 600-800 | Inter 400-600 | Wanderlust, Linear, Stripe |
| **Editorial** | Fraunces / Playfair | Be Vietnam Pro / Inter | Vivu, Kinfolk, NYTimes |
| **Luxury** | Canela / Tiempos | Suisse Int'l / Inter | Atelier Veil, premium |

Load qua Google Fonts inline trong `<head>`:

```html
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
```

Define trong tailwind.config:

```js
fontFamily: {
  display: ['Poppins', 'system-ui', 'sans-serif'],
  sans: ['Inter', 'system-ui', 'sans-serif'],
}
```

---

## SECTION ANATOMY (xương sống mỗi section)

Mọi section content (không phải hero) phải follow anatomy này:

```html
<section class="py-20 lg:py-28 bg-[bg-color]">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

    <!-- HEADER BLOCK -->
    <div class="text-center mb-14">
      <!-- 1. Eyebrow -->
      <span class="eyebrow">KHÁM PHÁ</span>
      <!-- 2. Display heading -->
      <h2 class="font-display text-3xl sm:text-4xl lg:text-5xl font-bold mb-4">
        Điểm đến nổi bật
      </h2>
      <!-- 3. Subtitle -->
      <p class="text-slate-500 max-w-xl mx-auto">...</p>
    </div>

    <!-- CONTENT BLOCK -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <!-- cards / items -->
    </div>

    <!-- OPTIONAL: Footer CTA -->
    <div class="text-center mt-12">
      <a href="#" class="text-primary font-semibold hover:underline inline-flex items-center gap-1">
        Xem tất cả <i class="fa-solid fa-arrow-right text-xs"></i>
      </a>
    </div>

  </div>
</section>
```

**Spacing rule:**
- Section padding: `py-20 lg:py-28`
- Container: `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`
- Header → Content: `mb-14`
- Grid gap: `gap-6` (cards), `gap-4` (small items), `gap-8` (large blocks)

**Alternating backgrounds:**
- Section 1: `bg-white`
- Section 2: `bg-slate-50`
- Section 3: `bg-white`
- ... → tạo rhythm

---

## SELF-CHECK TRƯỚC KHI SHIP

Prompt ép model tự check:

```
□ Mỗi section có ĐỦ 3 phần: eyebrow → heading → subtitle? (trừ hero)
□ Button chính có gradient + colored shadow + active:scale?
□ Card có rounded-2xl + hover lift (translateY(-8px))?
□ Input có label uppercase + icon absolute + focus ring với opacity?
□ Font pairing: 1 display + 1 sans, load từ Google Fonts?
□ Color palette: 1 primary + 1 secondary + semantic + ink scale?
□ Animation: fadeIn stagger 0.1/0.25/0.4/0.55s?
□ Section padding py-20 lg:py-28, container max-w-7xl?
□ Responsive: sm: / lg: breakpoints có mặt ở grid và typography?
□ Không dùng màu lạ (purple/pink) trừ khi brand yêu cầu?
□ Text tiếng Việt CÓ DẤU đầy đủ?
□ Mobile 375px: test grid 1 cột, stat không vỡ, form không tràn?
```

Nếu 1 ô FAIL → fix trước, không ship.

---

## KHI USER BẢO "RENDER 1 CÂU" NHƯ KIMI

Công thức ngắn gọn:

```
INPUT:  "Tạo landing cho app du lịch"
OUTPUT: 1 file HTML single-page có 7 section:
        1. Header (logo + nav + CTA)
        2. Hero (headline + subtitle + search box nổi + stats)
        3. Destinations grid (4 cards)
        4. Featured hotels (3 cards với price + rating)
        5. Blog/offers (3 cards horizontal)
        6. Newsletter CTA (gradient bg)
        7. Footer (4 cols + social + copyright)

        Mỗi section follow anatomy chuẩn.
        Apply đủ 7 pattern.
        Dùng template saas-landing.html làm starter.
```

**KHÔNG** hỏi user "bạn muốn màu gì?" ở vòng đầu. Chọn **blue-primary default** (`#0ea5e9` sky-500) — brand màu an toàn nhất. User thấy rồi sẽ nói nếu muốn đổi.

---

## FILES TRONG SKILL NÀY

- [SKILL.md](SKILL.md) — file này
- [references/spec-templates.md](references/spec-templates.md) — template cho design.md/outline.md/interaction.md
- [references/patterns-cookbook.md](references/patterns-cookbook.md) — 7 pattern với variations
- [templates/saas-landing.html](templates/saas-landing.html) — starter cho SaaS/booking/marketplace
- [templates/editorial.html](templates/editorial.html) — starter cho editorial/portfolio/brand

---

## KẾT HỢP VỚI SKILL KHÁC

- `frontend-design`: xem TRƯỚC skill này (7 công thức typography/spacing chi tiết)
- `mobile-design`: thay thế skill này cho mobile app
- `feature-dev`: orchestrate khi build full-stack feature

**Thứ tự invoke đúng:**
```
1. frontend-design (fundamentals)  →
2. kimi-render (render patterns + spec)  →
3. code
```
