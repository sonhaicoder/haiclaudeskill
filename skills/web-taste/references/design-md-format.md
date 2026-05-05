# DESIGN.md Format — Standard Spec

> Source: distilled từ [getdesign.md](https://getdesign.md/) (70+ design systems collection), [designmd.ai](https://designmd.ai/) ("Google's open format"), [styles.refero.design](https://styles.refero.design/) (extracted DESIGN.md), [impeccable.style](https://impeccable.style/) (Stitch-compatible export).

> DESIGN.md là **single markdown file đặt ở project root** (alongside README.md). AI coding tools (Claude Code, Cursor, Codex, Gemini) đọc nó để build matching UI.

---

## Khi nào tạo DESIGN.md

```
TẠO khi:
  ✓ Project mới, đã pick direction từ Discovery Form (turn 2 Branch A)
  ✓ Project có brand spec từ user (turn 2 Branch B) — cần codify
  ✓ Project match reference site (turn 2 Branch B) — cần extract values
  ✓ Project lớn cần share design context giữa multiple agents/devs

KHÔNG cần khi:
  ✗ Quick prototype (1 page, throwaway)
  ✗ Tweak component nhỏ trong app có sẵn (đã có DESIGN.md rồi)
```

---

## Standard Template

````markdown
# DESIGN.md

> Project: <Project Name>
> Last updated: 2026-XX-XX
> Direction: <editorial-monocle | modern-minimal | warm-soft | tech-utility | brutalist-experimental | custom>
> Mode: <brand | product | both>

## 1. Visual Theme & Atmosphere

<1-3 paragraph mô tả overall feel. Reference real sites/products.>

**Key Characteristics:**
- <bullet 1: signature visual element>
- <bullet 2>
- <bullet 3>

## 2. Color Palette & Roles

### Background Surfaces
- **Primary BG** (`oklch(...)` / `#hex`): description + when to use
- **Surface** (`oklch(...)`): cards, modals
- **Elevated** (`oklch(...)`): popovers, dropdowns

### Text & Content
- **Primary Text** (`oklch(...)`): default body
- **Muted Text** (`oklch(...)`): secondary content, metadata
- **Tertiary** (`oklch(...)`): timestamps, disabled states

### Brand & Accent
- **Accent** (`oklch(...)`): primary CTA, links, brand mark
- **Accent Hover** (`oklch(...)`): interactive variant

### Status Colors
- **Success** (`oklch(...)`)
- **Warning** (`oklch(...)`)
- **Danger** (`oklch(...)`)

### Border & Divider
- **Border Primary** (`oklch(...)`): visible separations
- **Border Subtle** (`oklch(...)`): cards, inputs
- **Divider** (`oklch(...)`): horizontal rules

## 3. Typography Rules

### Font Family
- **Display:** `<font stack>` — for headlines, hero text
- **Body:** `<font stack>` — for paragraphs, UI labels
- **Mono:** `<font stack>` — for code, numerics, IDs

### Hierarchy

| Role | Font | Size | Weight | Line Height | Letter Spacing |
|------|------|------|--------|-------------|----------------|
| Display XL | <font> | 72px | 510 | 1.0 | -0.02em |
| Display | <font> | 48px | 510 | 1.0 | -0.018em |
| H1 | <font> | 32px | 600 | 1.13 | -0.02em |
| H2 | <font> | 24px | 600 | 1.33 | -0.01em |
| H3 | <font> | 20px | 600 | 1.4 | normal |
| Body Large | <font> | 18px | 400 | 1.6 | normal |
| Body | <font> | 16px | 400 | 1.5 | normal |
| Body Medium | <font> | 16px | 510 | 1.5 | normal |
| Small | <font> | 14px | 400 | 1.5 | normal |
| Caption | <font> | 13px | 400 | 1.4 | normal |
| Mono Body | <mono> | 14px | 400 | 1.5 | normal |

### Principles
- <principle 1: tracking strategy>
- <principle 2: weight system>
- <principle 3: hierarchy strategy>

## 4. Layout & Spacing

### Container
- Max-width: `1400px` (content) / `768px` (long-form text)
- Section padding: `py-24` desktop / `py-12` mobile
- Page padding: `px-6` mobile / `px-8` tablet / `px-12` desktop

### Grid
- 12-column grid với `gap-6` desktop / `gap-4` mobile
- Bento mode: asymmetric với `grid-cols-12`

### Spacing Scale
Use ONLY: `4`, `8`, `12`, `16`, `20`, `24`, `32`, `48`, `64`, `96`px (i.e. `gap-1/2/3/4/5/6/8/12/16/24` Tailwind)

### Vertical Rhythm
- Between form fields: `gap-4` (16px)
- Between sections: `gap-6` (24px)
- Between page blocks: `gap-12` (48px)

## 5. Border Radius
- Small (button, input, badge): `rounded-md` (6px) hoặc `rounded-lg` (8px)
- Medium (card): `rounded-xl` (12px) hoặc `rounded-2xl` (16px)
- Large (modal, hero): `rounded-3xl` (24px)
- Full: `rounded-full` ONLY cho avatar, status dot, pill badge

## 6. Shadows & Elevation
- **Default:** No shadow. Use `border-t`/`divide-y` cho separation.
- **Card hover:** `shadow-[0_2px_8px_rgba(0,0,0,0.04)]`
- **Modal/Dropdown:** `shadow-[0_20px_40px_-15px_rgba(0,0,0,0.1)]`
- **NEVER:** `shadow-md`, `shadow-lg`, `shadow-xl` Tailwind defaults

## 7. Component Stylings

### Buttons

**Primary**
```css
background: var(--accent);
color: white;
padding: 0.5rem 1rem;
border-radius: 0.75rem;
font-weight: 510;
&:hover { background: var(--accent-hover); }
&:active { transform: scale(0.98); }
```

**Secondary (Ghost)**
```css
background: transparent;
border: 1px solid var(--border);
color: var(--fg);
&:hover { background: var(--surface-2); }
```

**Sizes:** sm (h-9), md (h-10), lg (h-11). KHÔNG mix sizes trong cùng action group.

### Inputs
- Label luôn TRÊN input, KHÔNG floating
- Border: `1px solid var(--border)`
- Focus: `ring-2 ring-accent/30` + `border-accent`
- Error: `border-danger` + helper text dưới
- Padding: `px-3 py-2` (md), `px-4 py-3` (lg)

### Cards
- Background: `var(--surface)`
- Border: `1px solid var(--border)`
- Padding: `p-6` default, `p-4` compact
- Radius: `rounded-2xl`
- Hover (interactive): subtle lift `transition: all 200ms`

### Tables
- Header: `bg-neutral-50`, `text-xs uppercase tracking-wide font-medium`
- Row: `hover:bg-neutral-50`, `border-b border-neutral-100`
- Cell: `px-4 py-3`
- Numbers: `text-right`, `font-mono tabular-nums`

### Tags / Badges
- Pill shape: `rounded-full px-3 py-0.5`
- Size: `text-xs` (10-11px)
- Tinted bg + matching text color (low saturation)

## 8. Iconography

- **Library:** Phosphor Icons / Radix / Heroicons (consistent stroke width)
- **Stroke width:** standardized 1.5 hoặc 2.0 toàn project
- **Size scale:** 14, 16, 18, 20, 24px
- **NEVER:** emoji icons, generic Lucide user/egg avatars

## 9. Motion & Animation

### Transitions
- Standard: `transition: all 200ms cubic-bezier(0.16, 1, 0.3, 1)`
- Hover: `200ms`
- Focus: `150ms`
- Page transitions: `400ms`

### Animation Principles
- Animate ONLY `transform` và `opacity`
- Hardware acceleration mặc định
- KHÔNG animate `top`, `left`, `width`, `height`, `padding`

### Specific Patterns
- **Entrance reveal:** `opacity 0 → 1, translateY(12px) → 0`, 600ms
- **Hover lift:** `translateY(-1px)`, 200ms
- **Active push:** `scale(0.98)`, 100ms
- **Stagger children:** `delay: index * 80ms`

### Performance
- KHÔNG `window.addEventListener('scroll')` — dùng `IntersectionObserver`
- KHÔNG `useState` cho continuous animation — dùng `useMotionValue` (Framer)

## 10. Imagery & Photography

- **Style:** <muted/desaturated/high-contrast/B&W>
- **Aspect ratios:** 16:9 (hero), 4:3 (feature), 1:1 (avatar)
- **Placeholder:** `https://picsum.photos/seed/{string}/800/600` (deterministic, không broken)
- **NEVER:** Unsplash links, generic stock photos

## 11. Voice & Copy

### Tone
- <Editorial / Friendly / Authoritative / Technical / Playful>
- Sentence length: <short punchy / medium balanced / long detailed>
- Person: <1st / 2nd / 3rd>

### Banned Phrases
- "Elevate", "Seamless", "Unleash", "Next-gen", "Game-changer", "Delve"
- Generic CTAs: "Learn more", "Get started", "Click here"
- Use specific verbs: "Cut billing time 2h → 15min", "Replace 5 tools with 1"

### Numbers & Data
- Real metrics or honest placeholder (`—`, `[your metric]`)
- KHÔNG round numbers (50%, 99%, 1M+)
- Specific: 47.2%, 843K, +1 (312) 847-1928

### Names & Brands
- Realistic specific: "Linh Nguyen" (not "John Doe")
- Brand placeholders: contextual ("Brewlab Coffee" cho coffee shop demo)
- KHÔNG: "Acme", "Nexus", "SmartFlow"

## 12. Responsive Breakpoints

```
sm:  640px   (large mobile)
md:  768px   (tablet)
lg:  1024px  (small desktop)
xl:  1280px  (desktop)
2xl: 1536px  (large desktop)
```

- **Mobile-first** mặc định
- Layout asymmetric ≥ md PHẢI fallback strict 1-col ở `< 768px`
- Hero sections dùng `min-h-[100dvh]`, KHÔNG `h-screen`

## 13. Accessibility

- Contrast: body text WCAG AA (4.5:1), large text 3:1
- Focus ring visible (`ring-2 ring-accent/30`)
- All interactive elements ≥ 44×44px hit target
- Semantic HTML (`<nav>`, `<main>`, `<button>`, `<a>`)
- Alt text cho mọi `<img>`

## 14. Anti-Patterns Specific to This Project

- <project-specific things to avoid based on past iteration>
- VD: "KHÔNG dùng purple gradient — đã thử, không match brand"
- VD: "KHÔNG dùng floating CTA bar — distract khỏi content"

## 15. Agent Prompt Guide

> When AI agent uses this DESIGN.md, follow this priority order:
> 1. Match section 2 (color) and section 3 (typography) verbatim
> 2. Honour section 4-7 (layout, radius, shadow, components) defaults
> 3. Apply section 9 (motion) only when adds value
> 4. Audit against section 14 (anti-patterns)
> 5. Use section 11 (voice) for ALL generated copy
````

---

## Workflow: Create DESIGN.md

### Branch A — Pick a direction

```
1. User picks direction từ form (vd: "modern-minimal")
2. Em copy template từ references/directions.md
3. Substitute palette + fonts vào sections 2-3
4. Customize section 1 (visual theme) cho project-specific
5. Save tới <project-root>/DESIGN.md
6. Tell user: "Created DESIGN.md — Modern Minimal direction (cobalt accent, Geist font). Ready to build."
```

### Branch B — Have brand spec / Match reference

```
1. Locate source: list attached files HOẶC WebFetch <brand>.com/brand|press|about
2. Download styling: CSS file, brand-guide PDF, screenshots
3. Extract:
   - `grep -E '#[0-9a-fA-F]{3,8}'` trên CSS để lấy hex
   - Convert hex → OKLch (use online tool hoặc oklch.com)
   - Eyeball screenshots cho typography (Display family, Body family, Mono?)
   - Note radii, border weight, shadow intensity, accent color budget
4. Codify vào DESIGN.md template
5. Vocalise: "Brand system: warm cream bg + rust accent + Newsreader display. Match?" → user confirm
6. Save tới <project-root>/DESIGN.md
```

---

## Examples — see `design-systems/` folder

5 starter DESIGN.md có sẵn cho 5 directions:
- `linear.md` — Linear App style (modern-minimal direction, dark mode)
- `stripe.md` — Stripe pre-2020 (warm-soft direction)
- `apple.md` — Apple.com (modern-minimal với premium polish)
- `monocle-editorial.md` — Editorial direction
- `brutalist-arena.md` — Brutalist direction

Use chúng làm template hoặc reference. Copy + customize.

---

## Lifecycle: Update DESIGN.md

DESIGN.md không phải static. Update khi:
- Brand spec thay đổi (rebrand)
- Phát hiện anti-pattern mới (add vào section 14)
- Component pattern mới được approve sau iteration (add vào section 7)
- Tone of voice update (refine section 11)

Treat DESIGN.md như living document — review mỗi quarter, prune deprecated patterns.
