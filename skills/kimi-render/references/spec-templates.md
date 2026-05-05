# Spec Templates — Bộ 3 File MD Ép Model

Kimi đẹp vì ép model fill 3 file này trước khi render. Copy template bên dưới, điền thật kỹ, rồi mới code.

---

## 1. design.md — Design System Bible

```markdown
# <Project Name> — Design Style Guide

## Design Philosophy

### Core Concept
<1-2 câu mô tả brand personality. Ví dụ: "Premium travel booking — editorial magazine meets modern SaaS. Elegant, trustworthy, approachable.">

### Visual Inspiration
- <Reference 1 — ví dụ: "Kinfolk magazine typography">
- <Reference 2 — ví dụ: "Airbnb search UX">
- <Reference 3 — ví dụ: "Linear color hierarchy">

## Color Palette

### Primary
- **Primary**: #0ea5e9 (sky-500) — CTA, links, accent
- **Secondary**: #f0f9ff (sky-50) — eyebrow bg, subtle sections

### Semantic
- **Success**: #22c55e (green-500)
- **Warning**: #f97316 (orange-500)
- **Danger**: #ef4444 (red-500)

### Ink (Text + Structure)
- **Dark**: #0f172a (slate-900) — heading, footer bg
- **Ink-700**: #334155 — body text
- **Ink-500**: #64748b — muted
- **Ink-300**: #cbd5e1 — disabled

### Usage Rules
- Primary chỉ dùng cho: CTA button, link, icon accent, active state
- KHÔNG dùng primary cho body text (contrast kém)
- KHÔNG dùng màu semantic cho decoration

## Typography

### Font Pairing
- **Display**: Poppins 600-800 — headings, CTA
- **Body**: Inter 300-600 — paragraph, label, UI

### Scale
| Level | Size | Weight | Line-height | Letter-spacing |
|-------|------|--------|-------------|----------------|
| H1 Hero | 4xl/5xl/7xl | 700 | 1.1 | -0.02em |
| H2 Section | 3xl/4xl/5xl | 700 | 1.15 | -0.01em |
| H3 Card | xl/2xl | 600 | 1.3 | 0 |
| Body | base (16px) | 400 | 1.6 | 0 |
| Small | sm (14px) | 400 | 1.5 | 0 |
| Eyebrow | xs (12px) | 700 | 1.4 | 0.12em UPPERCASE |
| Label | xs (12px) | 600 | 1.4 | 0.08em UPPERCASE |

## Spacing System

- Base unit: 4px (Tailwind default)
- Section padding vertical: 80px (mobile) / 112px (desktop) → `py-20 lg:py-28`
- Container: `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`
- Header → Content: 56px → `mb-14`
- Grid gap: 24px → `gap-6`
- Card padding: 24px → `p-6`

## Border Radius

- Input, Button: `rounded-xl` (12px)
- Card, Modal: `rounded-2xl` (16px)
- Pill, Badge, Avatar: `rounded-full`
- Tag nhỏ: `rounded-lg` (8px)

## Shadows (COLORED — signature move)

- Button primary: `shadow-lg shadow-primary/30 hover:shadow-xl hover:shadow-primary/40`
- Card: `shadow-sm` → `shadow-2xl` on hover
- Floating element (search box on hero): `shadow-2xl`

## Animation

- **Easing**: `cubic-bezier(0.4, 0, 0.2, 1)` (Material standard)
- **Duration**: 200-300ms cho hover, 500-800ms cho entrance
- **Hover lift**: `translateY(-8px)` + shadow expand
- **Active feedback**: `scale-[0.98]` on button click
- **Stagger**: 0.1s → 0.25s → 0.4s → 0.55s

## Responsive Breakpoints

- Mobile: < 640px (default)
- Tablet: sm: 640px+
- Desktop: lg: 1024px+
- Wide: xl: 1280px+

## Brand Personality

4 tính từ:
- <adj 1 — VD: "Sophisticated">
- <adj 2 — VD: "Clean">
- <adj 3 — VD: "Warm">
- <adj 4 — VD: "Trustworthy">
```

---

## 2. outline.md — File Structure + Sections

```markdown
# <Project Name> — Project Outline

## File Structure

\`\`\`
<project>/
├── index.html          # Landing page
├── [other pages if multi-page]
├── assets/             # images, videos
└── .design/            # spec files
    ├── design.md
    ├── outline.md
    └── interaction.md
\`\`\`

Hoặc nếu React project:

\`\`\`
src/
├── app/
│   └── page.tsx        # Landing
├── components/
│   ├── layout/         # Header, Footer
│   ├── hero/
│   ├── sections/       # Destinations, Hotels, etc.
│   └── ui/             # Button, Card, Input (reused)
└── styles/
\`\`\`

## Page Breakdown

### 1. Landing Page (index.html / page.tsx)

**Purpose:** <1 câu — VD: "Convert khách ghé thăm thành user đặt phòng đầu tiên">

**Key Sections:**

#### 1.1 Header (sticky, white bg, blur)
- Logo (icon + wordmark)
- Nav: [6 items max]
- CTA group: Login + Signup (primary gradient)
- Mobile: hamburger → slide-in panel

#### 1.2 Hero
- Background: image + gradient overlay
- Headline 2-line (gradient accent trên 1 cụm từ)
- Subtitle (max 2 lines, max-w-2xl)
- Search box nổi (backdrop-blur, white/95 opacity, shadow-2xl)
  - Tab switcher (nếu multi-type)
  - Form grid 4 cols với icon-labeled inputs
  - CTA button full-width gradient
- Stats row (4 items: 500+/200+/50K+/4.9)

#### 1.3 Destinations Grid
- Eyebrow: "KHÁM PHÁ"
- Heading + subtitle center-aligned
- Grid 1/2/4 cols → 4 cards
- Card: image + name + desc + tag badge (hot/new/sale)

#### 1.4 Featured Hotels
- Eyebrow: "LƯU TRÚ"
- Heading left-aligned + "Xem tất cả" link right
- Grid 1/2/3 cols → 3-6 cards
- Card: image + rating stars + name + location + price

#### 1.5 Blog / Offers
- Eyebrow: "TIN TỨC"
- Heading center
- Grid 1/3 → 3 cards horizontal

#### 1.6 Newsletter CTA
- Gradient background (primary → primary-dark)
- Decorative circles white/5 opacity
- Center: heading + email input + CTA button

#### 1.7 Footer (dark bg)
- Grid 1/2/4 cols
- Col 1: logo + description + social icons
- Col 2-3: link lists (Services, Support)
- Col 4: contact info với icons
- Bottom: copyright + payment icons

**Interactive Elements:**
- Tab switcher trong hero search
- Card hover lift
- Form validation
- Modal booking flow
- Toast notifications
- Mobile menu slide-in

## JavaScript Functionality

### Core Features
1. Tab switcher (hotel/train)
2. Form submit → modal → confirm → toast
3. Intersection Observer cho reveal animation
4. Mobile menu toggle
5. Smooth scroll to section

### Libraries (via CDN)
- Tailwind (CDN)
- Font Awesome 6.5.1
- Google Fonts (Poppins + Inter)
- [Optional] Anime.js cho advanced animations
- [Optional] Splide.js cho carousel

## Content Strategy

### Photography
- Unsplash URLs với `?w=600&q=80&auto=format&fit=crop`
- Subject: <ví dụ: landscape travel photography>
- Consistency: same color temperature, similar composition

### Copy Tone
- <VD: "Warm, confident, aspirational. Tiếng Việt có dấu đầy đủ. Tránh corporate jargon.">

### User Flow
1. Land on hero → search intent
2. Browse destinations → inspiration
3. View hotels → decision
4. Click book → modal → confirm
5. Toast success → encourage further browsing
```

---

## 3. interaction.md — Micro-interactions

```markdown
# <Project Name> — Interaction Design

## Core User Interactions

### 1. Hero Search Box
- **Tab switch**: Click "Khách sạn" / "Vé tàu" → smooth form crossfade (opacity 0.2s)
- **Input focus**: ring-2 primary/20 xuất hiện, border primary
- **Date picker**: Native HTML5 date input (mobile-friendly)
- **Submit**: Button scale 0.98 on click → loading spinner → results slide in below

### 2. Destination Cards
- **Hover**: translateY(-8px), shadow expand từ sm → 2xl, 300ms cubic-bezier
- **Image**: scale(1.05) khi hover (overflow-hidden)
- **Click**: Ripple effect → scroll to hotel section prefilled

### 3. Hotel Cards
- **Hover**: Same card lift pattern
- **Rating stars**: Static, màu amber-400
- **Price**: Gradient background tag bên góc
- **"Đặt ngay" button**: Primary gradient, colored shadow

### 4. Booking Modal
- **Open**: Backdrop fadeIn 0.3s + modal scale 0.95 → 1 + opacity 0 → 1
- **Close**: Reverse + click backdrop để đóng
- **Submit**: Button loading → success → toast + auto close after 1s
- **Validation**: Real-time, error border red + text bên dưới

### 5. Newsletter
- **Input focus**: white ring nhẹ trên gradient bg
- **Submit**: Button scale feedback → toast "Đăng ký thành công"

### 6. Mobile Menu
- **Open**: translateX(100% → 0) 300ms ease
- **Close**: Backdrop click hoặc X button
- **Links**: Underline animation on hover (desktop)

### 7. Scroll Animations
- Above-fold: Immediate fadeIn với stagger delay
- Below-fold: Intersection Observer threshold 0.1
  - Card grids: Stagger 0.1s/0.25s/0.4s/0.55s
  - Section heading: fadeUp 0.6s
  - Hero stats: slideUp delay 0.4s

## User Journey Flow

### First-Time Visitor
1. **Land** → See hero carousel + search → Immediate intent capture
2. **Search** → Trigger modal OR scroll to results
3. **Browse** → Destinations → Hotels → Blog
4. **Trust** → Stats (500+ hotels) + Reviews + Social proof
5. **Convert** → Booking modal → Success

### Returning Visitor
1. Direct navigation to favorite section via nav
2. Newsletter signup nếu đã convert trước
3. Check new offers in blog section

## Mobile Responsiveness

### Touch Targets
- Minimum 44x44px cho mọi button/link
- Spacing giữa touchable elements: 8px min

### Gestures
- Swipe: Carousel (nếu có)
- Tap: Card → modal hoặc detail page
- Long-press: Không dùng (không intuitive trên web)

### Breakpoint Behavior
- < 640px: Grid 1 col, hero text 4xl, stats stack 2x2
- 640-1024px: Grid 2 cols, hero 5xl, stats 4x1
- > 1024px: Grid 3-4 cols, hero 7xl, full layout

## Accessibility

- **Keyboard navigation**: Tab order logical, focus visible
- **Screen reader**: ARIA labels cho icon-only buttons
- **Contrast**: WCAG AA min (4.5:1 body, 3:1 large text)
- **Focus states**: Ring-2 primary/20 rõ ràng
- **Skip link**: "Skip to content" cho screen reader users
- **Reduced motion**: Respect `prefers-reduced-motion: reduce`

## Error States

- **Form validation**: Red border + error text dưới input
- **Empty state**: Icon + message + CTA
- **Loading**: Skeleton matching final layout
- **Network error**: Toast với retry button
- **404**: Custom page với navigation back to home
```

---

## HƯỚNG DẪN DÙNG 3 FILE

1. **Copy template** vào `<project>/.design/<feature>/`
2. **Fill từng section** — KHÔNG skip "Visual Inspiration" hay "Brand Personality" (đây là linh hồn)
3. **Show anh duyệt** trước khi code (hoặc ít nhất state assumptions rõ)
4. **Code follow strictly** — mỗi dòng code trace về 1 dòng trong spec
5. **Review** cuối: diff có match spec không?

Nếu có bước thiếu → output sẽ thiếu linh hồn. Không bỏ qua được.
