---
name: web-taste
description: |
  Anti-slop web frontend skill — AUTO-TRIGGER mọi web UI task. Force ship Kimi/Lovable-tier quality bằng 3 luật cứng:
  (1) Turn 1 emit Discovery Form lock brief TRƯỚC khi gen pixel (cho task lớn) hoặc apply quality bar (cho tweak nhỏ),
  (2) Turn 2 pick 1 trong 5 visual directions deterministic (OKLch palette + font + posture) hoặc extract brand-spec — KHÔNG freestyle,
  (3) Turn 3+ TodoWrite plan → live updates → 27 anti-pattern checklist + 5-dim critique + quality tier scoring → ship single artifact.
  AUTO-TRIGGER khi: chạm file .tsx/.jsx/.ts/.vue/.svelte/.astro/.html/.css/.scss/.tailwind, hoặc user nói "build/sửa/render/design/tạo/refactor" + "page/landing/UI/component/storefront/admin/site/web/trang/giao diện/style/theme", hoặc "design như Kimi/Lovable/Linear/Stripe/Apple/Monocle/Vercel/Notion".
  Bao gồm: 9 references (directions/discovery-form/anti-slop/critique/design-md-format/quality-tiers/hero-patterns/section-blueprints/motion-recipes), 8 starter design systems (Kimi, Lovable, Linear, Stripe, Apple, Monocle, Brutalist, Datadog).
  Distilled từ open-design (24K stars), taste-skill, impeccable.style, getdesign.md, kimi.com, lovable.dev, huashu-design, guizang-ppt.
  KHÔNG dùng cho: mobile (Flutter/iOS/Android/RN — dùng mobile-design), backend (API/DB), config/infra (CI/env/docker).
---

# Web-Taste — Anti-Slop Frontend Skill (Kimi/Lovable-tier)

> **Mục tiêu:** ship UI **đạt Kimi-tier hoặc Lovable-tier** — senior designer level, không phải "đẹp tạm được".
> **Triết lý:** AI không freestyle. Lock brief → pick deterministic direction → execute với guardrails + ready-to-paste blueprints → ship 1 artifact.
> Source: distilled từ open-design (24K stars), taste-skill, impeccable.style, getdesign.md, kimi.com, lovable.dev.

---

## 1. KHI NÀO ACTIVATE — AUTO-TRIGGER MỌI WEB TASK

```
AUTO-TRIGGER khi (BẤT KỲ điều kiện nào):
  ✓ Chạm file: .tsx, .jsx, .ts, .vue, .svelte, .astro, .html, .css, .scss
  ✓ Chạm thư mục: components/, pages/, app/, src/, public/
  ✓ User nói "build / sửa / render / design / tạo / refactor / fix / thêm" +
            "page / landing / UI / component / storefront / admin / site /
             web / trang / giao diện / style / theme / form / modal / card"
  ✓ User mention brand: "design như Kimi/Lovable/Linear/Stripe/Apple/
                         Monocle/Vercel/Notion/Cursor/v0/Anthropic"
  ✓ User attach Figma URL / screenshot / mockup
  ✓ Project có package.json với react/vue/svelte/next/astro

DEPTH OF APPLICATION (skill scale theo task size):
  ┌─ Big task (build từ scratch / new page / major refactor)
  │    → FULL workflow: Discovery Form → Direction → TodoWrite → 9 steps → tier scoring
  │
  ├─ Medium task (refactor section / theme rebuild / new feature UI)
  │    → SKIP Discovery Form, apply: directions + anti-slop + 5-dim critique
  │
  └─ Small task (tweak / bug fix UI / 1 component edit)
       → APPLY: anti-slop checklist + tactile press + responsive check
       → KHÔNG mở Discovery Form (waste user time)

KHÔNG dùng khi:
  ✗ Mobile app (Flutter/RN/iOS/Android/SwiftUI/Compose) → mobile-design
  ✗ Backend (API/DB/service/migration) → backend skills
  ✗ Config/infra (CI/CD/env/docker/deploy) → no UI involved
  ✗ Pure logic/algorithm (no UI surface) → general coding skill
```

---

## 2. BA LUẬT CỨNG (KHÔNG ĐƯỢC PHÁ)

### LUẬT 1 — Turn 1 PHẢI emit Discovery Form, KHÔNG code ngay

Khi user mở task mới hoặc brief mới, output đầu tiên là **1 dòng prose ngắn + Discovery Form**. KHÔNG file read, KHÔNG Bash, KHÔNG TodoWrite, KHÔNG extended thinking.

Tại sao: form là time-to-first-byte. User nhanh ở radio, chậm ở redirect sai. **30 giây radio beats 30 phút redirect.**

Form template:

```json
{
  "title": "Quick brief — 30 giây",
  "description": "Lock những cái này trước khi build. Skip cái không cần — fill default.",
  "questions": [
    { "id": "output", "label": "Build cái gì?", "type": "radio", "required": true,
      "options": ["Landing/marketing page", "App prototype", "Dashboard / tool UI", "Editorial page", "Slide deck", "Khác"] },
    { "id": "platform", "label": "Surface chính", "type": "radio",
      "options": ["Mobile (375px first)", "Desktop web", "Responsive all sizes", "Fixed canvas 1920x1080"] },
    { "id": "audience", "label": "Cho ai?", "type": "text",
      "placeholder": "VD: nhà đầu tư seed, dev-tools buyer, exec review nội bộ" },
    { "id": "tone", "label": "Visual tone (≤2)", "type": "checkbox", "maxSelections": 2,
      "options": ["Editorial/magazine", "Modern minimal", "Tech/utility", "Luxury/refined", "Brutalist/experimental", "Soft/warm", "Playful/illustrative"] },
    { "id": "brand", "label": "Brand context", "type": "radio", "required": true,
      "options": ["Pick a direction for me", "I have brand spec — share file", "Match reference site/screenshot"] },
    { "id": "scale", "label": "Quy mô", "type": "text",
      "placeholder": "VD: 1 hero + 4 sections, 8 slides, 4 mobile screens" },
    { "id": "constraints", "label": "Khác?", "type": "textarea",
      "placeholder": "Real copy, font bắt buộc, thứ phải tránh, deadline…" }
  ]
}
```

**Quy tắc form:**
- JSON valid (no comments, no trailing commas)
- ≤7 questions, batch 2 nếu cần
- Adapt theo brief — drop default user đã trả lời
- Lead 1 dòng prose ngắn ("Got it — landing cho SaaS B2B. Tell me the rest:")
- Sau form → **STOP**. KHÔNG narrate.

**CHỈ skip form khi:**
- User reply *bên trong active design* với tweak ("headline to hơn", "đổi ảnh slide 3")
- User explicit nói "skip form", "just build", "no questions"
- Message bắt đầu bằng `[form answers — …]`

---

### LUẬT 2 — Turn 2 branch theo `brand`

#### Branch A: `brand: "Pick a direction for me"`

KHÔNG TodoWrite. Emit form thứ 2 với 5 visual directions (xem `references/directions.md`):

```
[direction-cards form]
  ├── editorial-monocle    — print magazine, serif, off-white + warm rust
  ├── modern-minimal       — Linear/Vercel, system fonts, near-greyscale + cobalt
  ├── warm-soft            — Stripe pre-2020, cream bg + terracotta + serif display
  ├── tech-utility         — Datadog/GitHub, dense data, mono numerics + signal green
  └── brutalist-experimental — Are.na/Yale, loud serif + monospace body + hot red
```

User pick → bind palette + font **VERBATIM** vào `:root`. KHÔNG improvise OKLch values.

Nếu user fill `accent_override` → dùng accent đó, giữ rest direction defaults.

#### Branch B: `brand: "I have brand spec"` hoặc `"Match reference"`

Brand-spec extraction TRƯỚC TodoWrite (5 steps):
1. **Locate** — list attached files / WebFetch `<brand>.com/brand|press|about`
2. **Download** — CSS, brand-guide PDF, screenshots
3. **Extract** — `grep -E '#[0-9a-fA-F]{3,8}'` lấy hex; eyeball screenshots typography. KHÔNG đoán từ memory.
4. **Codify** — Write `DESIGN.md` ở project root (xem `references/design-md-format.md` cho format)
5. **Vocalise** — state system trong 1 câu để user redirect sớm

Sau đó chuyển LUẬT 3.

#### Branch C: anything else / no brand

Skip thẳng LUẬT 3 với tone-based default direction.

---

### LUẬT 3 — TodoWrite plan, live updates, ship 1 artifact

Sau khi direction/brand-spec lock → **first tool call** là TodoWrite với 5-10 imperative items:

```
1. Read DESIGN.md (brand-spec hoặc chosen direction)
2. Bind palette/font vào :root
3. Plan section/screen/slide list với rhythm (state TRƯỚC khi viết)
4. Wireframe pass — grey blocks + labelled placeholders, ship visible early
5. Fill real copy từ brief (replace [REPLACE] placeholders)
6. Fill imagery / decorative (real screenshots, not stock)
7. Self-check: chạy 27-anti-pattern audit (references/anti-slop.md, P0 PHẢI all pass)
8. 5-dim critique: philosophy/hierarchy/execution/specificity/restraint, fix < 3/5
9. Emit single <artifact>
```

**Live update rules:**
- Mark step `in_progress` TRƯỚC khi start
- Mark `completed` ngay khi xong (KHÔNG batch ở cuối turn)
- Plan đổi → edit list, đừng silent abandon

**Step 7-8 KHÔNG NEGOTIABLE.** Failed P0 → fix trước khi emit.

---

## 3. MODE — BRAND vs PRODUCT (impeccable.style)

Trước khi viết CSS, chọn mode dựa vào output type:

```
BRAND MODE      Marketing/editorial/landing/pitch deck
                → Emotion-driven, hero-led, 1 decisive flourish, real photography
                → Display font có character (serif hoặc display-sans), tracking-tight
                → Whitespace generous, long-form sections OK
                → Animation: orchestrated reveals, parallax, cinematic
                → AI Tells to avoid: filler copy, fake metrics, generic icons

PRODUCT MODE    App UI / dashboard / tool / admin / form-heavy
                → Function-first, density rewarded, no marketing voice
                → Display = same family as body (Geist/Inter/system), no serif headlines
                → Tabular numerics for data, mono for IDs/codes
                → Animation: only state-change feedback (loading/empty/error/success)
                → AI Tells to avoid: hero images, oversized H1, decorative shadows
```

Câu hỏi check: "Người dùng đến đây để CẢM NHẬN, hay để LÀM CÁI GÌ?" Cảm nhận → Brand. Làm việc → Product.

---

## 4. BIAS CORRECTION RULES (proactive — viết default tốt thay vì fix sau)

### Rule 1: Deterministic Typography
- **Display/Headlines:** `text-4xl md:text-6xl tracking-tighter leading-none` (brand mode); `text-2xl font-semibold` (product mode)
- **Body:** `text-base text-neutral-600 leading-relaxed max-w-[65ch]`
- **ANTI-SLOP fonts cấm dùng làm DISPLAY:** `Inter`, `Roboto`, `Arial`, `Open Sans` (body OK)
- **Brand mode display:** `Geist`, `Outfit`, `Cabinet Grotesk`, `Satoshi`, `Newsreader`, `Tiempos`, `Iowan Old Style`
- **Product mode:** `Geist` + `Geist Mono`, hoặc `Satoshi` + `JetBrains Mono`. **Serif BANNED cho dashboard.**

### Rule 2: Color Calibration
- Max 1 accent color, saturation < 80%
- Neutral base: Zinc/Slate/Stone (KHÔNG pure black `#000`, KHÔNG pure gray)
- **THE LILA BAN:** No purple/violet glow, no neon gradient, no "AI Purple" aesthetic
- One palette per project. Không mix warm-gray + cool-gray cùng output

### Rule 3: Layout Diversification
- **Centered Hero CẤM** khi `LAYOUT_VARIANCE > 4` — force Split Screen / Asymmetric
- **3-column equal cards CẤM** — dùng Bento, Zig-Zag, asymmetric grid
- Mobile override: layouts ≥md PHẢI fallback strict 1-column ở `< 768px`
- Container: `max-w-[1400px] mx-auto` hoặc `max-w-7xl`

### Rule 4: Materiality
- Card containers chỉ dùng KHI elevation = hierarchy. Else dùng `border-t`, `divide-y`, negative space
- Shadow tinted theo background hue, KHÔNG default `shadow-md/lg/xl`
- Rounded radius: 8-12px crisp (product), hoặc 16-32px gentle (brand soft mode)
- KHÔNG `rounded-full` cho large containers
- KHÔNG glassmorphism trừ khi có lý do — nếu dùng PHẢI có 1px inner border + inset shadow

### Rule 5: Interactive UI States (mandatory generation)
LLM mặc định gen "static success" — em PHẢI gen full cycle:
- **Loading:** Skeletal loader match layout (KHÔNG generic spinner)
- **Empty:** Composed empty state với hint cách populate
- **Error:** Inline error reporting (forms)
- **Tactile feedback:** `:active` → `-translate-y-[1px]` hoặc `scale-[0.98]`

### Rule 6: Form Patterns
- Label TRÊN input (KHÔNG floating label, KHÔNG label trong placeholder)
- Helper text tồn tại trong markup (kể cả không hiển thị)
- Error text DƯỚI input
- Spacing: `gap-2` cho input block

---

## 5. AI TELLS — FORBIDDEN PATTERNS (audit checklist trước ship)

### Visual & CSS (cấm tuyệt đối trừ khi user explicit yêu cầu)
- ❌ Neon/outer glows (`box-shadow` glow)
- ❌ Pure black `#000000` (dùng off-black `#0a0a0a`, Zinc-950)
- ❌ Oversaturated accents (saturation > 80%)
- ❌ Excessive gradient text (text-fill gradients cho large headers)
- ❌ Custom mouse cursors
- ❌ Purple/violet gradient backgrounds (LILA BAN)
- ❌ Aggressive emoji feature icons (✨ 🚀 🎯)
- ❌ Rounded card với left coloured border accent
- ❌ Hand-drawn SVG humans/faces/scenery
- ❌ Italic-serif display headers
- ❌ Gradient on every background

### Typography
- ❌ Inter/Roboto/Arial làm DISPLAY face
- ❌ Oversized H1 ngoài kiểm soát (control hierarchy bằng weight + color, không chỉ scale)
- ❌ Serif trên Dashboard/Software UI

### Layout & Spacing
- ❌ 3-column equal cards generic
- ❌ Floating elements với gap awkward
- ❌ Padding/margin không mathematically perfect
- ❌ Centered Hero text trên dark image (try asymmetric thay vào)

### Content & Data — "Jane Doe Effect"
- ❌ Tên placeholder "John Doe", "Sarah Chan", "Acme Corp"
- ❌ Generic SVG egg avatars / Lucide user icons
- ❌ Fake metrics "10× faster", "99.9% uptime" không có source
- ❌ Predictable numbers (`50%`, `99.99%`, `1234567`)
- ❌ Startup slop names "Acme", "Nexus", "SmartFlow"
- ❌ AI copywriting clichés: "Elevate", "Seamless", "Unleash", "Next-Gen", "Game-changer", "Delve"
- ❌ Lorem ipsum, "Feature One / Feature Two"

### External Resources
- ❌ Unsplash links (broken thường) — dùng `https://picsum.photos/seed/{string}/800/600`
- ❌ shadcn/ui generic default — PHẢI customize radii/colors/shadows
- ❌ Invented metrics → leave honest placeholder (`—`, grey block, labelled stub)

**Honest placeholder beats fake stat.**

Full danh sách 27 anti-patterns: xem `references/anti-slop.md`.

---

## 6. PERFORMANCE GUARDRAILS

- **DOM cost:** Grain/noise filters CHỈ trên `fixed inset-0 pointer-events-none` pseudo-elements, KHÔNG trên scrolling containers
- **Hardware acceleration:** Animate ONLY `transform` và `opacity`. KHÔNG animate `top`/`left`/`width`/`height`
- **Z-index:** KHÔNG spam `z-50`/`z-10`. Dùng systemic layer contexts (sticky nav, modal, overlay)
- **Scroll listeners:** KHÔNG dùng `window.addEventListener('scroll')`. Dùng `IntersectionObserver`
- **GSAP vs Framer Motion:** KHÔNG mix trong cùng component tree. Default Framer Motion cho UI; GSAP/ThreeJS exclusively cho isolated full-page scrolltelling

---

## 7. DIAL CONFIG (3 knob để adjust output)

```
DESIGN_VARIANCE: 8  (1=symmetry, 10=chaos)
MOTION_INTENSITY: 6  (1=static, 10=cinematic)
VISUAL_DENSITY: 4   (1=art gallery, 10=cockpit)
```

User có thể override bằng prompt: "make it more variance", "less motion", "denser data". Adapt config dynamically.

### DESIGN_VARIANCE
- **1-3:** flexbox center, symmetrical 12-col grid, equal padding
- **4-7:** offset (margin-top: -2rem overlap), varied aspect ratios, left-aligned headers
- **8-10:** masonry, fractional grid units, massive empty zones
- **MOBILE OVERRIDE:** levels 4-10 PHẢI strict 1-col fallback ở `< 768px`

### MOTION_INTENSITY
- **1-3:** No automatic animation. CSS `:hover`/`:active` only
- **4-7:** `transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1)`. `animation-delay` cascade. Transform/opacity only
- **8-10:** Scroll-triggered reveals, parallax. Framer Motion hooks. NEVER `window.addEventListener('scroll')`

### VISUAL_DENSITY
- **1-3:** Art gallery — huge whitespace, expensive feel
- **4-7:** Daily app — normal spacing
- **8-10:** Cockpit — tiny padding, 1px lines (no cards), monospace numerics

---

## 8. WORKFLOW EXECUTION (recap với Kimi/Lovable-tier target)

```
TURN 1
  ├─ 1-line prose ("Got it — landing cho SaaS B2B. Tell me the rest:")
  ├─ <question-form id="discovery"> (≤7 questions)
  └─ STOP — KHÔNG narrate

TURN 2 (branch on `brand` answer)
  ├─ A. "Pick direction" → emit <question-form id="direction"> (5 cards) → STOP
  ├─ B. "Have brand spec / Match reference" → extract → write DESIGN.md → goto Turn 3
  └─ C. else → tone-based default direction → goto Turn 3

TURN 3+ — TARGET KIMI/LOVABLE-TIER, NOT "decent"
  ├─ READ references/quality-tiers.md → know the bar
  ├─ TodoWrite plan (5-10 imperative items)
  ├─ Mark steps in_progress / completed live (no batch)
  ├─ HERO: pick from references/hero-patterns.md (7 ready-to-paste)
  ├─ SECTIONS: pick from references/section-blueprints.md (10 ready-to-paste)
  ├─ MOTION: add từ references/motion-recipes.md (ambient pulse + entrance reveal mandatory)
  ├─ Wireframe pass first (grey blocks, labelled stubs) — show visible early
  ├─ Fill real copy + imagery (specific numbers, real names, picsum.photos)
  ├─ Step 7: 27-anti-pattern audit (P0 must all pass) — references/anti-slop.md
  ├─ Step 8: 5-dim critique (fix < 3/5) — references/critique.md
  ├─ Step 9: Quality tier scoring (≥ 24/26 = Kimi/Lovable-tier achieved) — references/quality-tiers.md
  └─ Emit single <artifact>
```

---

## 9. REFERENCE FILES — đọc on-demand

### Foundation (luôn đọc khi bắt đầu task lớn)
| File | Khi nào đọc |
|------|-------------|
| `references/quality-tiers.md` | **BẮT BUỘC** đọc ở Turn 3 — Kimi-tier vs Lovable-tier checklist + scoring rubric |
| `references/directions.md` | User chọn "Pick direction" → bind palette/font verbatim |
| `references/discovery-form.md` | Viết Discovery Form — full JSON schema, edge cases, examples |

### Building (đọc khi viết section/hero)
| File | Khi nào đọc |
|------|-------------|
| `references/hero-patterns.md` | **READY-TO-PASTE** 7 hero patterns (oversized display, bento, asymmetric split, cinematic, animated pulse, magazine drop cap, dual-tone) |
| `references/section-blueprints.md` | **READY-TO-PASTE** 10 sections (bento, zig-zag, pricing, testimonial wall, FAQ, stat strip, CTA, footer, logo strip, comparison) + section combo recipes |
| `references/motion-recipes.md` | 10 animation recipes (ambient pulse, IntersectionObserver reveal, sticky stack, magnetic button, shimmer, tactile press, counter-up, choreography, parallax, cursor spotlight) |

### QA (đọc ở Step 7-8)
| File | Khi nào đọc |
|------|-------------|
| `references/anti-slop.md` | Step 7 — full 27 anti-patterns với fix recommendations |
| `references/critique.md` | Step 8 — 5-dim self-critique framework với scoring rubric |

### Brand spec
| File | Khi nào đọc |
|------|-------------|
| `references/design-md-format.md` | Branch B (extract brand-spec) hoặc tạo DESIGN.md mới — Google Stitch compatible |

### Starter Design Systems (8 cái)
| File | Direction | Best for |
|------|-----------|----------|
| `design-systems/kimi-style.md` | Editorial Premium AI | AI tool landing, Kimi-tier target |
| `design-systems/lovable-style.md` | Modern Minimal Cinematic | AI builder, dev tool, Lovable-tier target |
| `design-systems/linear.md` | Modern Minimal Dark | Dev tool, productivity SaaS |
| `design-systems/stripe.md` | Warm Soft | Fintech, wellness, indie SaaS |
| `design-systems/apple.md` | Modern Minimal Premium | Premium product, brand site |
| `design-systems/monocle-editorial.md` | Editorial | Long-form, content, journalism |
| `design-systems/brutalist-arena.md` | Brutalist | Agency, manifesto, creative |
| `design-systems/datadog-utility.md` | Tech Utility | Dashboard, admin, data-heavy |

---

## 10. FAQ

**Q: Skill này thay thế shadcn/ui hay TailwindCSS?**
A: Không. Skill chỉ guide *cách* dùng chúng — bias correction + anti-slop rules. Code output vẫn là Tailwind + React (hoặc whatever stack user dùng).

**Q: Có DESIGN.md sẵn rồi, vẫn cần Discovery Form?**
A: Có, nhưng tailor — drop questions DESIGN.md đã trả lời (palette, typography). Vẫn cần lock: output type, audience, tone, scale.

**Q: User nói "just build, skip form" thì sao?**
A: Skip form, dùng tone-based default direction (modern-minimal cho dev-tools, warm-soft cho consumer/wellness, editorial cho content/media, tech-utility cho data/admin, brutalist cho creative/agency).

**Q: Output stack?**
A: Default React + TailwindCSS (v3 hoặc v4 — check `package.json`). Adapt nếu user dùng stack khác (Vue, Svelte, Astro, vanilla HTML).

---

**Triết lý cuối:** Mỗi rule trên đây là 1 lựa chọn cố ý chống lại default biases của LLM. AI mặc định ship "trung bình đẹp" vì training data đầy mediocre web. Skill này force ship "có taste" bằng deterministic guardrails + ready-to-paste blueprints + quality tier scoring.

---

## 11. QUALITY TIER QUICK REFERENCE

```
TIER 1 — "AI default"        — Bootstrap/shadcn vibe, instantly recognizable as AI gen
TIER 2 — "Decent"            — Pass review, không xấu nhưng không memorable
TIER 3 — "Kimi/Lovable-tier" — Senior designer level (TARGET)
```

### Kimi-tier signature checklist (editorial premium AI)
```
□ Page padding ≥ py-32, ambient gradient pulse, AI input prominent
□ Display clamp(48px, 7vw, 96px+), italic/serif emphasis, tracking-tighter
□ One accent ≤ 2 instances, real product UI screenshots
□ Mono numerics tabular, sticky frosted nav backdrop-blur-xl
□ NO Inter display, NO emoji icons, NO 3-col equal feature grid
```

### Lovable-tier signature checklist (modern minimal cinematic)
```
□ Bento grid hero (6-9 tiles) HOẶC oversized type ≥ text-7xl
□ Dark mode native, animated gradient pulse 2+ layers
□ Big bold display weight 600+, gradient text emphasis ≤ 1 element
□ Cards rounded-3xl border-white/10, conversational hero copy
□ Specific stats organic (847k, 14ms, 99.97%), real product preview tiles
```

**Score self ≥ 24/26 trên 13 aspects** (xem `references/quality-tiers.md` cho full table) → Kimi/Lovable-tier achieved.

**< 20/26 → AI default — major rework needed.**
