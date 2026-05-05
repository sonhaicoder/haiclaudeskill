# Quality Tiers — Kimi-tier vs Lovable-tier

> Mục tiêu của skill này: ship UI **đạt Kimi-tier hoặc Lovable-tier**, không phải "đẹp tạm được".
> Tier = quality bar cụ thể với pass/fail checklist, không phải vague "premium feel".

---

## Triết lý 3 tier

```
TIER 1 — "AI default"        — Bootstrap/shadcn vibe, có thể nhận ra AI gen ngay
TIER 2 — "Decent design"     — Pass review, không xấu nhưng không memorable
TIER 3 — "Kimi/Lovable-tier" — Senior designer level, người xem nghĩ là agency làm

Most AI output dừng ở Tier 1-2. Skill này force lên Tier 3.
```

---

## KIMI-TIER — Editorial Premium + AI Surface

**What is Kimi-tier:** Moonshot Kimi (kimi.com) ra UI editorial-premium-meets-AI-tool. Đặc trưng:

1. **Generous whitespace** — page padding `py-32` desktop, content `max-w-3xl` cho text
2. **Display-driven hierarchy** — hero typography là focal point, không phải image
3. **Subtle gradient pulse** — animated background blob mờ (`opacity: 0.04`, slow 20s+ duration)
4. **Tight type tracking** — display `tracking-tighter` (-0.02em+), tabular-nums data
5. **AI chat input prominent** — input field là "hero CTA", không phải button
6. **Dark mode native** — near-black canvas (`#0a0a0a`), white emerges from darkness
7. **Editorial flourish** — 1 oversized quote/stat per section, restrained

### Kimi-tier checklist

```
□ Page padding ≥ py-24 desktop (py-32 ideal)
□ Hero text size clamp(48px, 7vw, 96px)
□ Display tracking-tighter (-0.02em+)
□ Body line-height ≥ 1.6
□ Background ambient motion (radial-gradient blob, slow loop, low opacity)
□ One accent color, ≤ 2 instances per screen
□ Real product screenshot/footage (not stock)
□ AI input field prominent với subtle glow
□ Sticky frosted nav backdrop-blur-xl
□ Smooth scroll-triggered reveals (IntersectionObserver, không scroll listener)
□ NO emoji icons, NO purple gradient, NO Inter display
```

### Kimi failure modes

- ❌ Page padding `py-12` → cảm giác cramped
- ❌ Hero text < 48px → không có visual weight
- ❌ Inter làm display → cảm giác AI gen ngay
- ❌ Drop shadows trên cards → break editorial vibe
- ❌ 3-column equal feature grid → quay về Bootstrap default

---

## LOVABLE-TIER — Modern Minimal + Bento + Cinematic

**What is Lovable-tier:** Lovable.dev ra UI modern-minimal-meets-cinematic. Đặc trưng:

1. **Bento grid hero** — 6-9 tile masonry, asymmetric, thay vì hero text-only
2. **Animated background pulse** — gradient pulse loop, tăng brand energy
3. **Big bold type** — "Build something Lovable" hero ở size `text-7xl` minimum
4. **High contrast dark theme** — near-black bg (`#0a0a0a`), bright accent
5. **Real product preview** — screenshots/videos của output thật, không mock
6. **Card-driven layout** — mọi feature trong card có rounded-2xl + subtle border
7. **Conversational copy** — friendly tone ("Build something..."), real user testimonials
8. **Number scale** — "Millions of builders", "0M+ projects" làm social proof prominent

### Lovable-tier checklist

```
□ Hero là Bento grid (6-9 tiles asymmetric) hoặc oversized type
□ Big bold display (≥ text-7xl), font weight 600+
□ Dark mode default OR cream warm bg (no flat white)
□ Animated bg element (gradient pulse, particle, slow video)
□ Real screenshots/videos trong tile (no abstract shapes)
□ Cards rounded-2xl với border subtle
□ Conversational hero copy (specific verb + brand vibe)
□ Number/scale callouts với context
□ Gradient overlays subtle trên dark sections
□ Smooth page transitions (400ms+)
```

### Lovable failure modes

- ❌ Plain hero text-only → boring vs Lovable's bento hero
- ❌ Generic stock illustrations → break "production-ready" vibe
- ❌ Light gray text trên dark bg → contrast borderline
- ❌ Static page (no animated bg) → feels dead
- ❌ Generic CTA "Get Started" → conversational tone bị mất

---

## TIER COMPARISON TABLE

| Aspect | AI Default | Decent | Kimi/Lovable-tier |
|--------|-----------|--------|-------------------|
| Page padding | `py-12` | `py-16` | `py-24` to `py-32` |
| Hero display size | `text-4xl` | `text-5xl` | `clamp(48px, 7vw, 96px)+` |
| Display font | Inter | Geist | Geist/Cabinet Grotesk + serif option |
| Color count | 5+ random | 2-3 | 1 accent (≤2 instances/screen) |
| Background | flat white | subtle gradient | animated pulse / cinematic / cream |
| Hero structure | centered text | text + image | Bento grid / oversized type / dual layout |
| Motion | none | hover | entrance reveal + ambient pulse |
| Imagery | stock photo | UI mock | real product screenshot/video |
| Copy | "Welcome to..." | feature list | conversational + specific verb |
| Numbers | round (50%, 99%) | mixed | organic + contextual |
| Cards | shadow-md | shadow-sm | hairline border, no shadow |
| Avatar | egg icon | initials | photo or branded shape |
| CTA | "Get Started" | "Try free" | "Build something Lovable" / specific |

---

## SCORING SELF (sau khi build, trước khi ship)

```
Mỗi aspect cho 0/1/2 (0 = AI default, 1 = decent, 2 = Kimi/Lovable-tier)

≥ 24/26 (92%) = Kimi/Lovable-tier ✓
20-23/26 (77-89%) = Decent — fix 2-3 weak aspects
< 20/26 (< 77%) = AI default — major rework needed
```

---

## TIER-SPECIFIC ANTI-PATTERNS (đã có ở `anti-slop.md`, recap)

### Kimi-tier KHÔNG được có:
- Cramped padding (page `py-8` desktop)
- Inter as display
- Drop shadows on cards
- Emoji feature icons
- 3-column equal feature grid
- Static page (no ambient motion)
- "Welcome / Hello / Get Started" generic copy

### Lovable-tier KHÔNG được có:
- Plain text-only hero (must have bento hoặc oversized type)
- Stock illustration
- Light gray on dark borderline contrast
- Generic shadcn default styling
- "Lorem ipsum" placeholder
- 3-column generic feature row

---

## PRACTICAL APPLICATION

### Building landing → target Lovable-tier

1. Hero = Bento grid 6-9 tiles HOẶC oversized type
2. Animated bg pulse subtle
3. Real screenshots/videos trong tiles (Picsum.photos seed cho placeholder)
4. Conversational hero copy
5. Number/scale callout prominent
6. Section transitions smooth (400ms cubic-bezier)
7. Audit với 27 anti-patterns → P0 must pass
8. 5-dim critique → fix < 3/5

### Building editorial / content → target Kimi-tier

1. Hero = oversized display (clamp 48-96px)
2. `py-32` page padding
3. Body content `max-w-3xl` (optimal reading)
4. Single accent (rust/cobalt/sage), ≤2 instances
5. Real photography / product screenshot
6. Editorial flourish (pull quote, oversized stat)
7. Subtle ambient motion (gradient blob, slow)
8. Sticky nav backdrop-blur

### Building dashboard → target neither (use tech-utility)

Dashboard không phải Kimi/Lovable-tier. Use `tech-utility` direction (Datadog/GitHub style). Density > polish.

---

## REAL-WORLD REFERENCES (study before building)

### Kimi-tier references (open in browser, study patterns)
- https://kimi.com — original
- https://moonshot.cn — sister site
- https://stripe.com (pre-2020 era — Wayback Machine) — editorial-meets-product
- https://linear.app — tight type, dark mode
- https://vercel.com — modern minimal premium

### Lovable-tier references
- https://lovable.dev — original
- https://v0.dev — Vercel's AI builder, similar bento hero
- https://magicui.design — animated bento components
- https://launchui.com — premium templates với Lovable vibe

### Editorial / Brand references
- https://monocle.com — print-magazine on web
- https://itsnicethat.com — editorial
- https://bynder.com (case study site) — premium B2B

### Quality benchmark
- https://godly.website — curated premium web design (study top 50)
- https://siteinspire.com — agency portfolio standard
- https://typewolf.com/site-of-the-day — typography excellence

**Rule:** Trước khi build, mở 3-5 sites trong list trên, study trong 5 phút. Nội hoá visual language. Then build.
