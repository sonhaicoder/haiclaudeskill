---
name: frontend-design
description: Design formula bắt buộc cho MỌI web UI task (landing, storefront, admin page, component, page mới, refactor UI, theme, style). Chắt lọc từ 3 reference Kimi. Auto-trigger mỗi khi chạm file .tsx/.jsx/.vue/.svelte/.html/.css hoặc khi user nói build/thêm/sửa giao diện web, page, trang, component, landing, storefront, shop, UI. KHÔNG áp dụng cho Flutter/iOS/Android/React Native mobile — dùng mobile-design skill riêng.
---

# Frontend Design Formula (WEB ONLY)

## AUTO-TRIGGER

Skill này phải được invoke **lần đầu tiên mỗi session** khi:

- User nói: "build page/trang/landing/storefront/shop/UI/component/form/modal/card/theme/style"
- User nói: "thêm/sửa/làm/refactor giao diện/UI/page"
- Agent sắp edit/write file `.tsx .jsx .vue .svelte .astro .html .css .scss`
- Agent sắp chạm thư mục chứa `components/` `pages/` `app/` của 1 web project

Sau lần đầu tiên trong session, agent đã nắm formula → không cần re-invoke trừ khi session mới.

## KHÔNG dùng khi

- Flutter / Dart / iOS / Android / React Native / SwiftUI / Jetpack Compose → dùng skill `mobile-design`
- Backend-only task (API, DB, service) — không có UI
- Config/infra task (CI/CD, env, docker) — không có UI

---

## 7 CÔNG THỨC BÍ MẬT (cái `design.md` KHÔNG bao giờ nói)

Đây là những chi tiết tạo ra khác biệt giữa UI "đúng spec nhưng vô hồn" và UI "đẹp mê li" như Kimi làm.

### 1. Typography layering — 3 scale + letter-spacing đi ngược chiều

```css
/* EYEBROW / OVERLINE — tiny uppercase, spacing DƯƠNG */
.text-overline {
  font-size: 11px;
  font-weight: 400;
  letter-spacing: 0.12em;  /* rộng */
  text-transform: uppercase;
  line-height: 1.4;
}

/* BODY SMALL — subtle description */
.text-body-small {
  font-size: 13px;
  font-weight: 300;        /* light */
  letter-spacing: 0.01em;
  line-height: 1.5;
}

/* DISPLAY — hero heading, spacing ÂM */
.text-display {
  font-size: clamp(44px, 8vw, 72px);
  font-weight: 400;        /* KHÔNG bold */
  letter-spacing: -0.02em; /* hẹp */
  line-height: 1.05;       /* tight */
}
```

**Quy tắc vàng:** heading to → letter-spacing ÂM, tracking tight. Text nhỏ → letter-spacing DƯƠNG, tracking wide. Đây là signature của editorial design (Kinfolk, The Gentlewoman).

**SAI:** `text-6xl font-bold` thuần Tailwind — không có tracking, không có weight variation → generic.

### 2. Color — warm off-white + champagne accent, KHÔNG pure white/gold

```css
/* DARK LUXURY palette */
--bg: #080808;              /* không #000 — đen ấm hơn */
--text: #F5F0EB;            /* warm off-white, KHÔNG #FFFFFF lạnh */
--text-muted: rgba(245,240,235,0.55);  /* opacity, KHÔNG text-gray-400 */
--accent: rgba(200,169,126,0.06);      /* champagne mờ, KHÔNG gold rực */

/* WARM NEUTRAL palette */
--bg: #FEFCF8;              /* warm white, KHÔNG #FFFFFF */
--bg-secondary: #F5F1E8;    /* oat */
--bg-tertiary: #E8E5E0;     /* fog gray */
--text: #2C2C2C;            /* charcoal, KHÔNG #000 */
--accent: #A8B5A0;          /* sage, muted green */

/* EDITORIAL B&W palette */
--bg: #FFFFFF;
--bg-secondary: #F8F8F8;
--text: #1A1A1A;            /* charcoal, KHÔNG #000 */
--accent: #D4AF37;          /* gold SỬ DỤNG RẤT ÍT, accent thôi */
```

**Quy tắc:**
- KHÔNG dùng `#000000` hoặc `#FFFFFF` thuần — luôn pha chút warm/cool
- Text muted dùng `rgba()` với opacity, không phải gray scale
- Accent color chỉ dùng 2-3% diện tích (buttons, highlights) — không phải bg lớn

### 3. Liquid Glass — công thức CHÍNH XÁC

Glassmorphism 90% web làm sai. Đây là công thức thật:

```css
.liquid-glass {
  background: rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(24px) saturate(140%);
  -webkit-backdrop-filter: blur(24px) saturate(140%);
  border: none;                /* ← KHÔNG border! */
  border-radius: 20px;
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,0.2),    /* top highlight */
    inset 0 -1px 0 rgba(0,0,0,0.1),         /* bottom shadow */
    0 24px 48px -12px rgba(0,0,0,0.3);      /* depth */
  position: relative;
  overflow: hidden;
}

/* Edge specular highlight */
.liquid-glass::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1.4px;
  background: linear-gradient(180deg,
    rgba(255,255,255,0.5) 0%,
    rgba(255,255,255,0.15) 20%,
    rgba(255,255,255,0) 40%,
    rgba(255,255,255,0) 60%,
    rgba(255,255,255,0.15) 80%,
    rgba(255,255,255,0.5) 100%);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  pointer-events: none;
  mix-blend-mode: screen;
  opacity: 0.25;
}

/* Top light reflection */
.liquid-glass::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background:
    radial-gradient(ellipse 90% 40% at 50% 0%, rgba(255,255,255,0.18) 0%, transparent 55%),
    radial-gradient(ellipse 60% 35% at 65% 10%, rgba(255,255,255,0.08) 0%, transparent 50%);
  mix-blend-mode: overlay;
  pointer-events: none;
}
```

**Key insights:**
- KHÔNG có `border` — dùng `::before` với mask-composite để tạo edge thật
- `backdrop-filter: saturate(140%)` — tăng màu bên dưới thấm qua, không chỉ blur
- 2 pseudo element = edge highlight + top reflection → "glass thật"
- Inset box-shadow tạo depth 3D, không phải flat

**KHÔNG làm:** `bg-white/10 backdrop-blur-md border border-white/20` — đây là "fake glass" generic.

### 4. Noise overlay — chi tiết invisible-but-felt

```css
.noise-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  pointer-events: none;
  mix-blend-mode: overlay;
  opacity: 0.025;              /* 2.5% — gần như không thấy */
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
  background-repeat: repeat;
  background-size: 256px 256px;
  animation: noise-drift 20s ease-in-out infinite alternate;
}

@keyframes noise-drift {
  0%   { background-position: 0% 0%; }
  100% { background-position: 3% 5%; }
}
```

**Tại sao:** Mắt không nhận ra layer noise ở 2.5% opacity nhưng cảm nhận được "texture" — phá cảm giác "flat/sterile" của web thường. Đây là chi tiết phân biệt premium vs average.

### 5. Motion system — GSAP + Lenis, KHÔNG chỉ CSS transition

```typescript
// Entrance sequence — staggered, LONG duration (editorial pace)
gsap.from(heading, { opacity: 0, y: 30, duration: 3.0, ease: 'power3.out', delay: 0.2 });
gsap.from(subtitle, { opacity: 0, y: 20, duration: 2.5, ease: 'power3.out', delay: 0.7 });
gsap.from(arrow, { opacity: 0, duration: 2.0, ease: 'power2.out', delay: 1.2 });

// Scroll-driven — element theo scroll position
ScrollTrigger.create({
  trigger: section,
  start: 'top top',
  end: 'bottom top',
  scrub: true,  // animation bám scroll position
  onUpdate: (self) => { /* map self.progress to animation value */ }
});

// Lenis smooth scroll (inertia tự nhiên)
const lenis = new Lenis({ lerp: 0.08, duration: 1.2 });
```

**Timing chuẩn:**
- Hero entrance: **3s** duration (KHÔNG phải 300-500ms — editorial pace chậm)
- Stagger delay: 0.5s giữa các element
- Scroll reveal: 0.6s với `cubic-bezier(0.4, 0, 0.2, 1)`
- Hover transition: 300ms

**Quy tắc:** Landing page = slow motion (premium feel). App UI = fast motion (responsive feel).

### 6. Spacing — 8rem giữa section, KHÔNG phải gap-16

```css
section { padding: 8rem 0; }        /* 128px vertical */
.section-title { margin-bottom: 4rem; }  /* 64px title → content */
.products-grid { gap: 3rem; }       /* 48px product cards */
.hero-content { padding: 0 8vw; }   /* 8% viewport horizontal */
```

**Scale chuẩn cho landing/marketing:**
| Context | Value | Tailwind |
|---------|-------|----------|
| Section vertical padding | 128px (8rem) | py-32 |
| Title → content | 64px (4rem) | mb-16 |
| Grid gap | 48px (3rem) | gap-12 |
| Card internal padding | 32px (2rem) | p-8 |
| Hero horizontal padding | 8vw | px-[8vw] |

**Chú ý:** scale này KHÁC scale admin app (gap-4/6/8). Landing cần THỞ, admin cần COMPACT.

### 7. Layout hero — KHÔNG phải "text trái + image phải"

Kimi Atelier Veil layout:
```tsx
<section className="relative min-h-[100dvh]">
  <video className="absolute inset-0 w-full h-full object-cover" />  {/* video bg full */}
  <div className="absolute inset-0 bg-gradient-to-b from-black/50 to-black/85" />  {/* overlay */}

  {/* TEXT ĐƯỚI ĐÁY, không giữa */}
  <div className="relative z-10 flex flex-col justify-end min-h-[100dvh] px-[8vw] pb-[15vh]">
    <div className="max-w-[700px]">
      <h1>...</h1>
      <p>...</p>
    </div>
  </div>
</section>
```

**Layout patterns khác:**
- Full video/image bg + text bottom-left (Atelier Veil) — cinematic
- Centered text + gradient bg + CTA (Wool Sneakers) — classic
- Asymmetric split: text trái 40% + carousel phải 60% (Westie) — editorial

**SAI:** `grid-cols-2 gap-8` 50-50 split — generic SaaS template.

---

## 4 THEMES CÓ SẴN (chọn 1 theo surface, đừng mix)

### Theme A: Dark Luxury (Atelier Veil-inspired)
Dùng cho: landing marketing premium, perfume, fashion cao cấp, jewelry
```
bg: #080808
text: #F5F0EB (warm off-white)
accent: rgba(200,169,126,0.06) champagne
fonts: Cormorant Garamond (display) + Inter (body)
motion: GSAP slow (3s), scroll-driven video, liquid glass
full 7 công thức: YES (typography layering, liquid glass, noise, GSAP, spacing generous)
```

### Theme B: Warm Minimalist (Wool Sneakers-inspired)
Dùng cho: storefront customer-facing, sustainable brands, lifestyle, F&B, wellness
```
bg: #FEFCF8 (warm white)
secondary: #F5F1E8 (oat), #E8E5E0 (fog)
text: #2C2C2C (charcoal)
accent: #A8B5A0 (sage)
fonts: Canela (display) + Suisse Int'l (body) — hoặc Playfair + Inter nếu không có Canela
motion: anime.js medium (600ms), organic curves, scroll reveal 16-24px translate
full 7 công thức: PARTIAL (typography + noise + motion, KHÔNG dùng liquid glass)
```

### Theme C: Editorial B&W (Westie-inspired)
Dùng cho: premium niche, pet/kid brands, charity, magazine-style storefront
```
bg: #FFFFFF
secondary: #F8F8F8
text: #1A1A1A
accent: #D4AF37 (gold — 2% usage only)
fonts: Playfair Display (display) + Inter (body)
motion: subtle fade + scale, 600ms cubic-bezier(0.4, 0, 0.2, 1)
full 7 công thức: PARTIAL (typography + motion subtle, KHÔNG liquid glass, noise optional)
```

### Theme D: Admin Utility (Apple light — đang dùng ở web-admin)
Dùng cho: admin dashboard, internal tool, form-heavy app
```
bg: #f5f5f7 (page) / #ffffff (card)
text: gray-900 / muted gray-600 / placeholder gray-400
accent: blue-500 (primary), red-500 (danger), green-500 (success), amber-500 (warn)
border: gray-200
fonts: Inter (body only, không display serif)
motion: CSS transition 300ms, KHÔNG GSAP heavy
spacing: compact (gap-4/6/8, p-4/6/8 — xem UI rules trong ~/.claude/CLAUDE.md)
radius: rounded-xl (button/input) / rounded-2xl (card/modal)
full 7 công thức: MINIMAL (chỉ typography discipline + color palette nhất quán, KHÔNG luxury aesthetics)
```

**Quy tắc chọn theme:**
- Landing / marketing / bán sản phẩm cao cấp → **A**
- Storefront khách mua hàng → **B** hoặc **C** (tùy ngành seller)
- Admin/internal tool → **D** (giữ utility, không over-design)
- Mobile app → KHÔNG dùng skill này, xem `mobile-design`

---

## TECH STACK CHUẨN CHO LANDING/STOREFRONT

```
Next.js 15 App Router (SSR for SEO)
Tailwind v4 với @theme CSS-first config (KHÔNG tailwind.config.js)
GSAP + ScrollTrigger (motion)
Lenis (smooth scroll)
Google Fonts: Playfair Display / Cormorant Garamond + Inter
react-fast-marquee (horizontal ticker)
imagesloaded (layout measurements)

KHÔNG shadcn cho landing (bespoke UI)
CÓ shadcn cho app pages (forms/cart/checkout)
```

---

## SELF-CHECK TRƯỚC KHI SHIP UI ĐẸP

```
□ Typography có 3 scale rõ rệt (overline + body + display)?
□ Letter-spacing có variation (display âm, overline dương)?
□ Color dùng warm off-white/charcoal (KHÔNG pure white/black)?
□ Text muted dùng rgba() opacity (KHÔNG gray scale)?
□ Section padding ≥ 96px vertical?
□ Nếu có glass → dùng công thức liquid-glass đầy đủ (2 pseudo)?
□ Có noise overlay 2.5% opacity?
□ Motion dùng GSAP với duration ≥ 1.5s cho hero?
□ Smooth scroll có Lenis?
□ Hero layout KHÔNG phải "text trái + image phải" generic?
□ Accent color < 3% diện tích?
□ Images dùng product photography chất lượng (không icon SVG thuần)?
□ Chọn 1 theme (A/B/C) và giữ nguyên, KHÔNG mix?
```

**1 checkbox FAIL → UI sẽ bị cảm giác "generic SaaS template".**

---

## REFERENCE FILES

Source code 3 reference Kimi đã phân tích nằm tại:
```
/Volumes/hai/haicode/kimi-refs/
├── atelier-veil/       # Dark luxury — React + GSAP + Lenis + Canvas
├── wool-sneakers/      # Warm minimalist — HTML + anime.js + p5.js
└── ao-kimi/            # Editorial B&W — HTML + Playfair + Inter
```

Key files để đọc khi cần chi tiết:
- `atelier-veil/app/src/index.css` — liquid-glass công thức + noise overlay
- `atelier-veil/app/src/sections/HeroSection.tsx` — GSAP timeline + scroll-driven video
- `atelier-veil/tech-spec.md` — toàn bộ animation timing breakdown
- `wool-sneakers/index.html` — inline CSS chi tiết, spacing rhythm
- `ao-kimi/index.html` — editorial layout với Playfair + Inter

Resources images (dùng làm mock đẹp ngay):
- `atelier-veil/` (không có assets — cần tự sourced)
- `wool-sneakers/resources/` — product-1.jpg → product-12.jpg, hero-urban.jpg, hero-nature.jpg
- `ao-kimi/resources/` — westie-january.png → westie-december.png, hoodie-1/2/3.png, poster-1/2/3.png

---

## ANTI-PATTERNS (không làm)

| Sai | Đúng | Lý do |
|-----|------|-------|
| `bg-black text-white` | `bg-[#080808] text-[#F5F0EB]` | Warm > pure |
| `text-gray-400` cho muted | `text-[rgba(245,240,235,0.55)]` | Opacity giữ hue |
| `text-6xl font-bold` | `text-[72px] font-normal tracking-[-0.02em] leading-[1.05]` | Editorial weight |
| `bg-white/10 backdrop-blur-md` | Full liquid-glass formula với 2 pseudo | Fake vs real glass |
| `py-16` giữa section | `py-32` (128px) | Landing cần thở |
| `transition-all duration-300` | GSAP 1.5-3s với `power3.out` | Premium pace |
| 50-50 text+image split | Full bg + text bottom-left, hoặc asymmetric 40-60 | Generic SaaS |
| Mix 2-3 themes trong 1 site | Chọn 1 theme, giữ nguyên | Coherence |
| Icon SVG cho hero visual | Product photography thật | Premium = real imagery |
| Gold/Accent ≥ 10% diện tích | Accent < 3% | Luxury = restraint |
