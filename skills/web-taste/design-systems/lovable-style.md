# DESIGN.md — Lovable-Style (Modern Minimal Cinematic)

> Direction: `modern-minimal` (dark/cinematic variant)
> Reference: lovable.dev, v0.dev, magicui.design
> Mode: brand + product hybrid

## 1. Visual Theme

Modern-minimal-meets-cinematic. Bento grid hero, animated gradient pulse, big bold display type, dark theme native với bright accent. "Watch it come to life" energy. Friendly conversational tone với "Build something Lovable" personality.

**Key Characteristics:**
- Dark mode native (`#0a0a0a` near-black canvas)
- Animated gradient pulse loops cho energy
- Bento grid hero (6-9 tiles asymmetric) thay cho text-only
- Big bold display (≥ text-7xl, weight 600+)
- Real product preview tiles, không abstract
- Conversational hero copy ("Build something X")
- Stat callouts prominent ("847k builders", "14ms p50")
- Cards rounded-3xl với subtle border
- Gradient text emphasis (single, restrained)

## 2. Color Palette

### Backgrounds (dark default)
- Page: `#0a0a0a` / `oklch(7% 0.005 250)`
- Surface 1: `rgba(255,255,255,0.03)` / `oklch(100% 0 0 / 0.03)`
- Surface 2: `rgba(255,255,255,0.05)` / `oklch(100% 0 0 / 0.05)`
- Elevated card: `#141414` / `oklch(13% 0.005 250)`

### Text
- Primary: `#fafafa` / `oklch(96% 0.005 100)`
- Secondary: `rgba(255,255,255,0.7)` / `oklch(100% 0 0 / 0.7)`
- Tertiary: `rgba(255,255,255,0.5)` / `oklch(100% 0 0 / 0.5)`
- Disabled: `rgba(255,255,255,0.3)`

### Accent (gradient signature)
- Violet primary: `#8b5cf6` / `oklch(60% 0.22 285)`
- Fuchsia: `#d946ef` / `oklch(65% 0.28 320)`
- Cyan secondary: `#06b6d4` / `oklch(70% 0.18 195)`
- **Gradient text:** `from-violet-400 to-fuchsia-400` (single use per page max)

### Status
- Success: `#10b981` / `oklch(65% 0.16 165)`
- Warning: `#f59e0b` / `oklch(72% 0.18 70)`
- Danger: `#ef4444` / `oklch(60% 0.22 25)`

### Borders
- Default: `rgba(255,255,255,0.1)` / `oklch(100% 0 0 / 0.1)`
- Subtle: `rgba(255,255,255,0.05)` / `oklch(100% 0 0 / 0.05)`
- Strong (active): `rgba(255,255,255,0.2)`

### Ambient gradient layers (hero bg)
- Layer 1: `bg-violet-600/20 blur-[120px]`, slow pulse 25s
- Layer 2: `bg-fuchsia-500/15 blur-[100px]`, counter-rotate 18s
- Optional Layer 3: `bg-cyan-500/10 blur-[80px]`, slow 22s

## 3. Typography

### Font Family
- **Display:** `'Geist'`, `'Cabinet Grotesk'`, `'Outfit'`, system-ui, sans-serif
- **Body:** `'Geist'`, `'Inter Variable'`, -apple-system, system-ui, sans-serif
- **Mono:** `'Geist Mono'`, `'JetBrains Mono'`, ui-monospace, Menlo

### Hierarchy

| Role | Size | Weight | Tracking | Line Height |
|------|------|--------|----------|-------------|
| Mega Display | clamp(48px, 7vw, 96px) | 700 | -0.025em | 1.05 |
| Display | clamp(40px, 5.5vw, 72px) | 600 | -0.02em | 1.1 |
| H1 (section) | 40px | 600 | -0.018em | 1.15 |
| H2 | 28px | 600 | -0.012em | 1.2 |
| H3 | 20px | 600 | -0.005em | 1.3 |
| Body Large | 18px | 400 | normal | 1.6 |
| Body | 15px | 400 | normal | 1.5 |
| Body Medium | 15px | 500 | normal | 1.5 |
| Small | 13px | 400 | normal | 1.4 |
| Eyebrow / Pill | 11-12px | 500 | normal | 1.4 |
| Mono Stat | clamp(36px, 5vw, 64px) | 600 | normal (tabular) | 1.0 |
| Mono Code | 13px | 400 | normal | 1.5 |

### Principles
- **Display weight 600-700 BOLD** (Lovable signature, không thin)
- **Gradient text:** chỉ 1 hero element per page (`<em>` không italic, `bg-clip-text`)
- **Tracking-tighter aggressive** ở display sizes
- **Tabular nums cho mọi data**

## 4. Components

### Hero Bento Grid (Lovable signature)
```html
<div class="grid grid-cols-12 gap-4 md:gap-6">
  <!-- Large feature 7-col x 2-row -->
  <div class="col-span-12 row-span-2 rounded-3xl border border-white/10 bg-gradient-to-br from-violet-500/20 to-transparent p-10 md:col-span-7">
    <!-- icon + content -->
  </div>
  <!-- Stat tile -->
  <div class="col-span-6 rounded-3xl border border-white/10 bg-white/[0.03] p-8 md:col-span-5">
    <div class="font-mono text-5xl font-bold tabular-nums">847k</div>
    <div class="mt-2 text-sm text-white/50">apps shipped</div>
  </div>
  <!-- Quote tile -->
  <!-- Demo tile -->
  <!-- ... -->
</div>
```

### Hero Display với Gradient Emphasis
```html
<h1 class="font-bold leading-[1.05] tracking-tight"
    style="font-size: clamp(48px, 7vw, 96px);">
  <span class="bg-gradient-to-b from-white to-white/70 bg-clip-text text-transparent">
    Build something
  </span><br>
  <em class="not-italic bg-gradient-to-r from-violet-400 to-fuchsia-400 bg-clip-text text-transparent">
    impossible
  </em>
</h1>
```

### Status Pill (animated)
```html
<span class="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/[0.05] px-4 py-1.5 backdrop-blur">
  <span class="size-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
  <span class="text-xs font-medium text-white/80">v2.6 just shipped — try it free</span>
</span>
```

### Primary CTA (gradient bg)
```html
<button class="rounded-xl bg-gradient-to-r from-violet-500 to-fuchsia-500 px-6 py-3 text-sm font-medium text-white hover:from-violet-400 hover:to-fuchsia-400 active:scale-[0.98] transition-all">
  Build with AI →
</button>
```

### Secondary CTA (glass)
```html
<button class="rounded-xl border border-white/10 bg-white/[0.03] px-6 py-3 text-sm font-medium text-white backdrop-blur hover:bg-white/[0.08]">
  See how it works
</button>
```

### Spotlight Card (cursor-follow gradient)
```html
<div class="group relative rounded-3xl border border-white/10 bg-white/[0.02] p-8 hover:border-white/20 transition-colors">
  <!-- Cursor spotlight overlay (from motion-recipes.md #10) -->
  <div class="card-content">...</div>
</div>
```

### Code Demo Tile
```html
<div class="rounded-3xl border border-white/10 bg-white/[0.03] p-8">
  <div class="mb-4 flex items-center gap-2 text-xs text-white/50">
    <span class="size-1.5 rounded-full bg-red-500"></span>
    <span class="size-1.5 rounded-full bg-yellow-500"></span>
    <span class="size-1.5 rounded-full bg-green-500"></span>
    <span class="ml-2 font-mono">prompt.txt</span>
  </div>
  <code class="block font-mono text-sm leading-relaxed text-white/80">
    "Build a marketplace<br>for vintage cameras with<br>seller verification"
  </code>
</div>
```

## 5. Layout

- Page padding: `py-24` mobile / `py-32` desktop
- Container: `max-w-7xl` cho bento, `max-w-5xl` cho text content
- Bento grid: `grid-cols-12` với gap-4/6 (mobile/desktop)
- Asymmetric: prefer 7/5, 8/4 splits (KHÔNG 6/6 generic)

## 6. Motion

### Always
- Tactile button press (`scale(0.98)`)
- Hover lift (`translateY(-1px)` 200ms)
- Smooth transitions (400ms cubic-bezier `[0.16, 1, 0.3, 1]`)

### Hero
- Multi-layer ambient pulse (2-3 gradient blobs counter-rotating, 18-25s)
- Status dot pulse loop
- Page choreography stagger 100-120ms (eyebrow → headline → lede → CTA → bento)

### Bento tiles
- Cursor spotlight on hover (premium tile feedback)
- Stagger reveal entrance (80ms between tiles)
- Subtle border color transition on hover

### Cards / interactive
- Border color transition: `transition: border-color 200ms`
- Background opacity transition: `transition: background-color 200ms`

### Avoid
- Parallax effects (Lovable không dùng heavy)
- Marquee text
- Cursor trail
- Multiple gradient text per page
- Animation lasting > 800ms (feels broken)

## 7. Imagery

- **Real product preview** trong tiles (screenshot UI/dashboard)
- **Avatar:** real photos via `picsum.photos/seed/<name>/40/40`
- **Illustration:** subtle gradient blobs/orbs, KHÔNG hand-drawn humans
- **Aspect ratios:** 16:10 product preview, 4:5 portrait, 1:1 avatar/stat
- **Cinematic photo overlay** cho dark hero: image với gradient mask down to bg color

## 8. Voice & Copy

### Hero
- Conversational personality ("Build something Lovable", "Watch it come to life")
- Specific brand verb + emotion ("impossible", "lovable", "weekend project")
- Single italic/gradient emphasis word per display

### CTAs
- Specific outcome ("Build with AI", "Ship in 47 seconds")
- KHÔNG generic "Get Started", "Sign Up"

### Numbers
- Big bold prominent (text-5xl mono)
- Real OR honest placeholder
- Organic: 847k, 14ms, 99.97% (NOT 1M+, 50%, 99.9%)

### Tone
- Friendly + confident, ngắn câu
- 2nd person ("you build")
- Brand voice = personality (Lovable: warm + can-do, NOT corporate)

## 9. Anti-Patterns Specific

- KHÔNG plain hero text-only — PHẢI có Bento HOẶC oversized type
- KHÔNG generic stock illustration trong tiles — real product screenshot
- KHÔNG light gray text trên dark bg với contrast borderline (PHẢI ≥ 4.5:1)
- KHÔNG > 1 gradient text per page (overuse)
- KHÔNG static page — ambient motion presence required
- KHÔNG centered hero generic — bento OR asymmetric split
- KHÔNG 3-col equal feature row — use bento grid (#1 trong section-blueprints.md)
- KHÔNG default shadcn styling — customize radii/colors/borders
- KHÔNG generic CTA "Get Started" — specific outcome verb
- KHÔNG > 5 active animations onscreen (perf hit)

## 10. Quality Bar Checklist

```
□ Hero là Bento grid (6-9 tiles) HOẶC oversized type ≥ text-7xl
□ Big bold display weight 600+ với tight tracking
□ Dark mode default OR cream warm bg (no flat white)
□ Animated bg element (gradient pulse 2+ layers, slow 18-25s loop)
□ Real screenshots/videos trong tile (no abstract shapes)
□ Cards rounded-3xl với border-white/10 subtle
□ Conversational hero copy (specific verb + brand vibe)
□ Number/scale callouts mono tabular prominent
□ Status dot pulse on "live" indicator
□ Smooth page transitions 400ms cubic-bezier
□ Single gradient text emphasis (≤ 1 per page)
□ Cursor spotlight on premium tiles (optional)
□ Tactile press + hover lift on EVERY button
□ NO Inter display, NO emoji icons, NO purple gradient bg generic
□ Mobile responsive 1-col fallback < 768px
```

**All ✓ = Lovable-tier achieved.**

---

## Compatible Heroes & Sections

Use Lovable-tier với patterns từ:
- **Hero:** Pattern 2 (Bento), Pattern 5 (Animated pulse) trong `references/hero-patterns.md`
- **Sections:** Bento feature grid (#1), Stat strip (#6), CTA footer (#7) trong `references/section-blueprints.md`
- **Motion:** Ambient pulse (#1), Cursor spotlight (#10), Page choreography (#8) trong `references/motion-recipes.md`
