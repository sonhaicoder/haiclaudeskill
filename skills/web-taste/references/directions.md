# 5 Visual Directions — Deterministic Library

> Source: distilled từ [open-design](https://github.com/nexu-io/open-design) `packages/contracts/src/prompts/directions.ts`, gốc từ huashu-design's "5 schools × 20 philosophies".
> Mục đích: khi user chưa có brand → pick 1 trong 5 → bind palette + font verbatim, KHÔNG freestyle.

## Cách dùng

```
User submit Discovery Form với brand: "Pick a direction for me"
  ↓
Emit form thứ 2 với 5 cards (palette swatches + type sample + mood blurb + refs)
  ↓
User pick id (vd: "modern-minimal")
  ↓
Bind direction.palette + direction.fonts VERBATIM vào :root
  ↓
Apply posture cues vào layout choices
```

Mỗi direction = 1 package CỐ ĐỊNH:
- 6 OKLch palette tokens (`--bg`, `--surface`, `--fg`, `--muted`, `--border`, `--accent`)
- Display font stack + body font stack + (optional) mono font
- 4-6 posture cues cụ thể (border weight, radius, accent budget)

---

## 1. `editorial-monocle` — Editorial / Monocle / FT magazine

**Mood:** Print-magazine feel. Generous whitespace, large serif headlines, restrained palette of off-white paper + ink + a single warm accent. Confident, quietly intelligent.

**References:** Monocle, FT Weekend, NYT Magazine, It's Nice That, Kinfolk.

**Palette + Fonts (drop into `:root` verbatim):**

```css
:root {
  --bg:      oklch(97% 0.012 80);    /* off-white paper */
  --surface: oklch(99% 0.005 80);
  --fg:      oklch(20% 0.02 60);     /* ink */
  --muted:   oklch(48% 0.015 60);
  --border:  oklch(89% 0.012 80);
  --accent:  oklch(58% 0.16 35);     /* warm rust / clay */

  --font-display: 'Iowan Old Style', 'Charter', Georgia, serif;
  --font-body:    -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
  --font-mono:    ui-monospace, 'IBM Plex Mono', Menlo, monospace;
}
```

**Posture (honour trong layout choices):**
- Serif display, sans body, mono CHỈ cho metadata
- KHÔNG shadows, KHÔNG rounded cards — borders + whitespace do the work
- Một decisive image, cropped only at the bottom
- Kicker / eyebrow trong mono UPPERCASE, accent color used at most twice
- Body max-width tight (~65ch), generous line-height (1.7)
- Page padding generous (`py-24` hoặc `py-32`)

---

## 2. `modern-minimal` — Linear / Vercel / Notion

**Mood:** Quiet, precise, software-native. System fonts, near-greyscale palette, single saturated accent. Chrome disappears so content registers.

**References:** Linear, Vercel, Notion 2024, Stripe docs, Geist, Cal.com.

**Palette + Fonts:**

```css
:root {
  --bg:      oklch(99% 0.002 240);
  --surface: oklch(100% 0 0);
  --fg:      oklch(18% 0.012 250);
  --muted:   oklch(54% 0.012 250);
  --border:  oklch(92% 0.005 250);
  --accent:  oklch(58% 0.18 255);    /* cobalt */

  --font-display: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Geist', system-ui, sans-serif;
  --font-body:    -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Geist', system-ui, sans-serif;
  --font-mono:    'JetBrains Mono', 'IBM Plex Mono', 'Geist Mono', ui-monospace, Menlo, monospace;
}
```

**Posture:**
- Tight letter-spacing on display sizes (`tracking-tighter`, `-0.02em`)
- Hairline borders only, KHÔNG shadows except dropdowns/modals
- Mono numerics with `font-variant-numeric: tabular-nums`
- Sticky frosted nav (`backdrop-blur-md bg-white/70`)
- Content-led layouts, KHÔNG hero illustrations
- One accent: links + primary CTA, nothing else
- Display weight 510-590 (medium-semibold), KHÔNG full bold 700+

---

## 3. `warm-soft` — Stripe pre-2020 / Headspace / Mercury

**Mood:** Cream backgrounds, soft accent, gentle radii. Reads like a thoughtful product magazine — friendly without being cute. Good for fintech, wellness, indie SaaS.

**References:** Stripe pre-2020, Headspace, Substack, Mercury, Things 3.

**Palette + Fonts:**

```css
:root {
  --bg:      oklch(97% 0.018 70);    /* warm cream */
  --surface: oklch(99% 0.008 70);
  --fg:      oklch(22% 0.02 50);
  --muted:   oklch(50% 0.018 50);
  --border:  oklch(90% 0.014 70);
  --accent:  oklch(64% 0.13 28);     /* terracotta */

  --font-display: 'Tiempos Headline', 'Newsreader', 'Iowan Old Style', Georgia, serif;
  --font-body:    'Söhne', 'Inter', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
}
```

**Posture:**
- Serif display, soft sans body
- Gentle radii (`12-16px`), KHÔNG hard 0px corners on content cards
- Single accent cho primary CTA + một editorial flourish (quote mark, stat callout)
- Soft inner glow on hero cards (`shadow-[inset_0_1px_0_rgba(255,255,255,0.6)]`) hơn drop shadow
- Avoid icons — dùng real screenshots/photographs/illustrations
- Generous whitespace, vertical rhythm 1.6-1.8

---

## 4. `tech-utility` — Datadog / GitHub / Cloudflare

**Mood:** Data-dense, monospace-friendly. Made for engineers và operators muốn information per square inch, không vibes.

**References:** Datadog, GitHub, Cloudflare dashboard, Sentry, Grafana.

**Palette + Fonts:**

```css
:root {
  --bg:      oklch(98% 0.005 250);
  --surface: oklch(100% 0 0);
  --fg:      oklch(22% 0.02 240);
  --muted:   oklch(50% 0.018 240);
  --border:  oklch(90% 0.008 240);
  --accent:  oklch(58% 0.16 145);    /* signal green */

  --font-display: -apple-system, BlinkMacSystemFont, 'Inter', 'Geist', system-ui, sans-serif;
  --font-body:    -apple-system, BlinkMacSystemFont, 'Inter', 'Geist', system-ui, sans-serif;
  --font-mono:    'JetBrains Mono', 'IBM Plex Mono', 'Geist Mono', ui-monospace, Menlo, monospace;
}
```

**Posture:**
- Sans display + sans body (one family) OK ở đây — utility trumps editorial
- Tabular numerics everywhere, mono cho code/IDs/hashes
- Dense tables với hairline borders, KHÔNG row striping
- Inline status pills (success/warn/danger) với restrained tinted backgrounds
- Avoid: hero images, oversized headlines, marketing copy — show the product instead
- Density target: VISUAL_DENSITY = 7-9
- Card containers TỐI THIỂU — dùng `border-t`, `divide-y` cho data grouping

---

## 5. `brutalist-experimental` — Are.na / Yale / Read.cv

**Mood:** Loud type. Visible grid. System sans + một oversized serif. Deliberate ugliness as confidence. Great cho art, indie, agency, manifesto.

**References:** Are.na, Yale Center for British Art, mschf, Read.cv, Block protocol docs.

**Palette + Fonts:**

```css
:root {
  --bg:      oklch(96% 0.004 100);   /* off-white printer paper */
  --surface: oklch(100% 0 0);
  --fg:      oklch(15% 0.02 100);
  --muted:   oklch(40% 0.02 100);
  --border:  oklch(15% 0.02 100);    /* borders = full-strength fg */
  --accent:  oklch(60% 0.22 25);     /* hot red */

  --font-display: 'Times New Roman', 'Iowan Old Style', Georgia, serif;
  --font-body:    ui-monospace, 'IBM Plex Mono', 'JetBrains Mono', Menlo, monospace;
}
```

**Posture:**
- Display = serif at extreme sizes (`clamp(80px, 12vw, 200px)`)
- Body = monospace — yes, monospace as body, deliberately
- Borders full-strength fg (1.5-2px), KHÔNG muted greys
- Asymmetric layouts: 70/30 split columns
- Almost no border-radius (0-2px). KHÔNG shadows. KHÔNG gradients.
- Underline links, KHÔNG hover decoration — let typography carry it
- Hot red accent dùng SẮC NÉT, không soft

---

## Form JSON cho Direction Picker (emit verbatim)

```json
{
  "title": "Pick a visual direction",
  "description": "No brand to match — pick a direction. Mỗi cái có palette/font/posture cố định. Có thể override accent ở dưới.",
  "questions": [
    {
      "id": "direction",
      "label": "Direction",
      "type": "direction-cards",
      "required": true,
      "options": ["editorial-monocle", "modern-minimal", "warm-soft", "tech-utility", "brutalist-experimental"]
    },
    {
      "id": "accent_override",
      "label": "Accent override (optional)",
      "type": "text",
      "placeholder": "VD: 'use moss green instead of cobalt', 'no orange — too brand-y'"
    }
  ]
}
```

---

## Quick lookup table

| ID | Background | Accent | Display Font | Body Font | Best for |
|----|------------|--------|--------------|-----------|----------|
| `editorial-monocle` | off-white paper | warm rust | Iowan/Charter serif | system sans | content/media/editorial |
| `modern-minimal` | near-white | cobalt | SF Pro Display/Geist | SF Pro Text/Geist | dev-tools/SaaS |
| `warm-soft` | warm cream | terracotta | Tiempos/Newsreader serif | Söhne sans | fintech/wellness/indie |
| `tech-utility` | cool near-white | signal green | Inter sans | Inter sans | dashboard/admin/data |
| `brutalist-experimental` | printer paper | hot red | Times serif (huge) | mono | agency/creative/art |

---

## Selecting direction nếu user skip Discovery Form

Nếu user nói "just build, no questions" — dùng tone-based heuristic:

```
brief có "saas/dev-tools/api/devops/cli"        → modern-minimal
brief có "fintech/wellness/health/journal/blog"  → warm-soft
brief có "dashboard/admin/analytics/monitoring"   → tech-utility
brief có "magazine/editorial/content/news/press"  → editorial-monocle
brief có "agency/portfolio/art/manifesto/indie"   → brutalist-experimental
default                                            → modern-minimal
```
