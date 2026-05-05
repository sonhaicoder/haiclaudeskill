# DESIGN.md — Kimi-Style (Editorial Premium AI)

> Direction: `editorial-monocle` + `modern-minimal` hybrid (Kimi-tier)
> Reference: kimi.com (Moonshot), claude.ai, openai.com landing
> Mode: brand (AI tool landing)

## 1. Visual Theme

Editorial-premium-meets-AI-tool. Generous whitespace + display-driven hierarchy + ambient gradient pulse + AI input prominent. Page reads như essay với product input, không marketing brochure với CTA spam.

**Key Characteristics:**
- Off-white "paper" background (`#fafaf7`) with ambient gradient pulse
- Display = serif italic emphasis HOẶC sans-display tracking-tighter
- AI input field là focal point thay vì button
- Generous py-32 page padding minimum
- Single accent color, ≤2 instances per screen
- Real product UI screenshots (no abstract 3D)
- Mono numerics tabular cho data

## 2. Color Palette

### Light mode (default)
- Page: `#fafaf7` / `oklch(98% 0.008 80)`
- Surface: `#ffffff` / `oklch(100% 0 0)`
- Subtle: `#f5f5f1` / `oklch(95% 0.012 80)`

### Dark mode (alt)
- Page: `#0a0a0a` / `oklch(7% 0.005 250)`
- Surface: `#141414` / `oklch(13% 0.005 250)`
- Elevated: `#1d1d1d` / `oklch(18% 0.005 250)`

### Text
- Primary: `#1a1612` / `oklch(20% 0.02 60)` (light) / `#fafafa` / `oklch(96% 0.005 100)` (dark)
- Muted: `#6b6357` / `oklch(48% 0.015 60)`
- Tertiary: `#a39d8e` / `oklch(70% 0.012 80)`

### Accent (subtle, restrained)
- Warm rust: `#b04832` / `oklch(58% 0.16 35)` (editorial mode)
- HOẶC Cobalt: `#3b5dff` / `oklch(58% 0.18 255)` (modern mode)
- HOẶC Emerald: `#10b981` / `oklch(65% 0.16 165)` (AI/tech mode)

### Borders
- Light: `#e8e3da` / `oklch(89% 0.012 80)`
- Subtle: `rgba(0,0,0,0.06)` (light) / `rgba(255,255,255,0.08)` (dark)
- Strong (rule lines): same as fg

### Ambient gradient (background pulse)
- Layer 1: `bg-violet-600/15 blur-[120px]`
- Layer 2: `bg-cyan-500/10 blur-[100px]`
- Animation: 18-25s slow loop, opposite directions

## 3. Typography

### Font Family
- **Display (editorial mode):** `'Iowan Old Style'`, `'Newsreader'`, `'Tiempos'`, Georgia, serif
- **Display (modern mode):** `'Geist'`, `'SF Pro Display'`, system-ui, sans-serif
- **Body:** `'Geist'`, `'Inter Variable'`, -apple-system, system-ui, sans-serif
- **Mono:** `'JetBrains Mono'`, `'Geist Mono'`, ui-monospace, Menlo

### Hierarchy

| Role | Font | Size | Weight | Tracking | Line Height |
|------|------|------|--------|----------|-------------|
| Mega Display | display | clamp(56px, 9vw, 144px) | 500 (serif) / 600 (sans) | -0.025em | 0.95 |
| Display | display | clamp(48px, 7vw, 96px) | 500 / 600 | -0.022em | 1.0 |
| H1 | display | 40px | 600 | -0.02em | 1.1 |
| H2 | sans | 28px | 600 | -0.015em | 1.2 |
| H3 | sans | 20px | 600 | -0.01em | 1.3 |
| Lede | sans | 19px | 400 | normal | 1.6 |
| Body Large | sans | 17px | 400 | normal | 1.55 |
| Body | sans | 15px | 400 | normal | 1.5 |
| Small | sans | 14px | 400 | normal | 1.4 |
| **Eyebrow** | mono | 11px | 500 | 0.2em (UPPERCASE) | 1.4 |
| Caption | sans | 12px | 500 | normal | 1.4 |
| Mono Stat | mono | clamp(40px, 6vw, 80px) | 600 | normal (tabular-nums) | 1.0 |

### Principles
- **Italic emphasis:** Display có 1-2 italic words làm visual rhythm ("Build something *impossible*")
- **Eyebrow MONO UPPERCASE wide tracking** — magazine signature
- **Body line-height 1.55-1.7** — longform readable
- **Display tracking AGGRESSIVE negative** (-0.022em+) tại large sizes
- **Tabular nums everywhere** cho data, mono cho code/IDs/timestamps

## 4. Components

### Hero Display
```html
<h1 class="font-serif font-medium leading-[0.95] tracking-tight text-neutral-900"
    style="font-size: clamp(56px, 9vw, 144px);">
  Design without<br>
  <em class="italic font-normal text-neutral-500">apology.</em>
</h1>
```

### Eyebrow
```html
<p class="font-mono text-[11px] uppercase tracking-[0.2em] text-neutral-500">
  — VOL 03 / 2026
</p>
```

### AI Input (Kimi signature CTA)
```html
<div class="rounded-2xl border border-neutral-300 bg-white/80 backdrop-blur-xl shadow-sm">
  <div class="flex items-center gap-3 px-5 py-4">
    <span class="font-mono text-xs text-neutral-400">$</span>
    <input
      type="text"
      placeholder="Ask anything — try 'explain attention to a 5yr old'"
      class="flex-1 bg-transparent text-base text-neutral-900 placeholder:text-neutral-400 focus:outline-none"
    />
    <button class="rounded-xl bg-neutral-900 px-4 py-2 text-sm font-medium text-white hover:bg-neutral-800">
      Run →
    </button>
  </div>
  <div class="border-t border-neutral-200 px-5 py-3 text-xs text-neutral-500">
    Ctrl+K to focus · Esc to cancel · Free up to 1k tokens/day
  </div>
</div>
```

### Underline link với offset (editorial signature)
```html
<a href="#" class="inline-flex items-center gap-2 text-base font-medium text-neutral-900 underline decoration-1 underline-offset-[6px] hover:decoration-2">
  Start reading <span>→</span>
</a>
```

### Subtle CTA pair (no flashy)
```html
<div class="flex flex-wrap items-center gap-x-8 gap-y-4">
  <button class="rounded-xl bg-neutral-900 px-6 py-3 text-base font-medium text-white hover:bg-neutral-800 active:scale-[0.98]">
    Get started free
  </button>
  <a href="#" class="text-base text-neutral-500 hover:text-neutral-900">
    Read the docs →
  </a>
</div>
```

### Stat Strip (mono tabular)
```html
<div class="grid grid-cols-2 md:grid-cols-4 gap-8">
  <div>
    <div class="font-mono text-5xl font-semibold tabular-nums text-neutral-900">87.3</div>
    <div class="mt-2 text-xs uppercase tracking-wider text-neutral-500">MMLU</div>
  </div>
  <!-- ... -->
</div>
```

### Sticky Frosted Nav
```html
<nav class="sticky top-0 z-40 border-b border-neutral-200/60 bg-[#fafaf7]/80 backdrop-blur-xl">
  <div class="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
    <span class="text-base font-semibold tracking-tight">Brand<sup class="text-xs text-neutral-400">v2</sup></span>
    <!-- nav links -->
  </div>
</nav>
```

## 5. Layout

- Page padding: `py-24` mobile / `py-32` desktop minimum
- Container: `max-w-5xl` cho hero, `max-w-3xl` cho prose
- Section vertical rhythm: `space-y-32` (huge gaps = magazine spread feel)
- Asymmetric grids: 9/3 hoặc 7/5 splits (KHÔNG 6/6)
- Mobile: strict 1-col fallback ≥ md sang `<` md

## 6. Motion

### Always
- Tactile button press (`scale(0.98)` on `:active`)
- Hover lift (`translateY(-1px)`, 200ms)
- Smooth scroll (`scroll-behavior: smooth`)

### Hero
- Ambient gradient pulse (2 layers, 18-25s loop, low opacity 0.04)
- Hero text choreography (eyebrow → display → lede → CTA stagger 120ms)
- Status dot pulse on "live" indicator

### Section transitions
- IntersectionObserver entrance reveal (translateY(20px) → 0, 700ms)
- Stagger children 80ms

### Avoid
- Parallax (Kimi không dùng)
- Marquee text
- Glow effects
- Gradient text (trừ 1 hero element max)

## 7. Imagery

- Real product UI screenshots (NOT abstract 3D)
- Photography: muted, warm-toned, documentary
- Aspect 16:9 hero, 4:5 portrait, 1:1 stat callouts
- KHÔNG: Unsplash links (use `picsum.photos/seed/...`)
- Image cropped at edges (như magazine spread bleed)

## 8. Voice & Copy

### Hero
- 1 italic emphasis word per display headline
- Specific verb + concrete benefit ("Cut billing 2h → 15min", "14ms p50 latency")
- KHÔNG "Welcome to..." / "Hello, [brand]" generic

### Body
- Sentence length: medium (15-25 words avg). Sometimes long. Sometimes short.
- 2nd person ("you") cho landing, 1st-person plural ("we") cho team mode
- Em-dashes — không hyphens — cho parenthetical thought

### Numbers
- Real metrics OR honest placeholder (`—`, `[your metric here]`)
- Organic: `87.3`, `14ms`, `847k` (NOT round 50%, 99%, 1M)
- Mono tabular display

### Banned phrases
- "Elevate", "Seamless", "Unleash", "Next-gen", "Game-changer", "Delve"
- "Get Started" generic CTA
- "Welcome to..." opener

## 9. Anti-Patterns Specific

- KHÔNG generic "3-column equal feature row" — use Bento grid hoặc asymmetric
- KHÔNG drop shadows trên cards — hairline border
- KHÔNG centered hero trên dark stock image — use ambient pulse instead
- KHÔNG Inter as display — Geist hoặc serif
- KHÔNG emoji icons (✨🚀) — Phosphor/Heroicons stroke 1.5
- KHÔNG random spacing — chỉ scale 4/8/12/16/24/32/48/64/96
- KHÔNG > 1 italic emphasis per section — restraint
- KHÔNG > 2 accent color instances per screen
- KHÔNG `h-screen` hero (mobile bug) — use `min-h-[100dvh]`

## 10. Quality Bar Checklist

```
□ Page padding ≥ py-24 desktop (py-32 ideal)
□ Hero text size clamp(48px, 7vw, 96px+)
□ Display tracking-tighter (-0.02em+)
□ Body line-height ≥ 1.55
□ Background ambient motion present
□ One accent color, ≤ 2 instances per screen
□ Real product screenshot/UI capture (no abstract)
□ AI input field prominent với subtle glow
□ Sticky frosted nav backdrop-blur-xl
□ IntersectionObserver entrance reveal
□ NO emoji icons
□ NO purple/pink gradient hero
□ NO Inter display
□ NO 3-col equal feature grid
□ Mobile responsive ≤ 768px tested
```

**All ✓ = Kimi-tier achieved.**
