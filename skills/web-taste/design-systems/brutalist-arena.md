# DESIGN.md — Brutalist / Are.na

> Direction: `brutalist-experimental`
> Reference: Are.na, Yale Center for British Art, mschf, Read.cv
> Mode: brand (creative/agency/manifesto)

## 1. Visual Theme

Loud type. Visible grid. System sans với một oversized serif. Deliberate ugliness as confidence. The page screams "I have a point of view" — not "please subscribe."

**Key Characteristics:**
- Off-white printer paper bg (`#f5f2ec`)
- Times New Roman extreme display sizes (clamp(80px, 12vw, 200px))
- MONOSPACE body — yes, monospace as paragraph text, deliberately
- Borders = full-strength fg color (1.5-2px), not muted greys
- Asymmetric 70/30 column splits
- 0px or 2px max border-radius. NO shadows. NO gradients.
- Hot red accent, used sparingly but BOLDLY
- Underline links, no hover decoration

## 2. Color Palette

### Backgrounds
- Paper: `#f5f2ec` / `oklch(96% 0.004 100)`
- Surface: `#ffffff` / `oklch(100% 0 0)`

### Text (full-strength, no soft greys)
- Primary (full ink): `#0a0a09` / `oklch(15% 0.02 100)`
- Secondary: `#4a4a45` / `oklch(40% 0.02 100)`
- KHÔNG dùng tertiary mute — brutalist không hide text behind opacity

### Accent (single hot red)
- Primary: `#d62828` / `oklch(60% 0.22 25)`
- Used cho: link underline, error state, status indicator. KHÔNG decorative

### Borders
- Default: `#0a0a09` / `oklch(15% 0.02 100)` — SAME AS FG
- Width: `2px` solid. Hairline borders banned.

### Semantic
- Success: `#0a7a3a` / `oklch(50% 0.16 145)` (green)
- Warning: `#c47a00` / `oklch(60% 0.14 70)` (mustard)
- Danger: `#d62828` / `oklch(60% 0.22 25)` (same as accent)

## 3. Typography

### Font Family
- **Display:** `'Times New Roman'`, `'Iowan Old Style'`, Georgia, serif
- **Body:** ui-monospace, `'IBM Plex Mono'`, `'JetBrains Mono'`, Menlo, monospace
- **System (UI labels):** -apple-system, BlinkMacSystemFont, system-ui, sans-serif

### Hierarchy

| Role | Font | Size | Weight | Tracking | Line Height |
|------|------|------|--------|----------|-------------|
| Display Massive | serif | clamp(80px, 12vw, 200px) | 400 | -0.04em | 0.85 |
| Display | serif | clamp(56px, 8vw, 120px) | 400 | -0.025em | 0.9 |
| H1 (mono) | mono | 32px | 700 | normal | 1.1 |
| H2 (mono) | mono | 22px | 700 | normal | 1.2 |
| Body | mono | 14px | 400 | normal | 1.5 |
| Caption | mono | 12px | 400 | normal | 1.4 |
| Small | mono | 11px | 400 | normal | 1.3 |

### Principles
- Display = serif at EXTREME sizes — 200px isn't excessive, it's the point
- Body = MONOSPACE deliberately. Read it as type-sample, not "easy reading"
- Headings = mono BOLD — bold thay vì serif vì hierarchy contrast
- Tight line-heights (0.85-0.9) cho display = stacked density

## 4. Components

### Massive Hero Type
```html
<section class="hero">
  <p class="meta">— 2026 / VOL 03</p>
  <h1 class="display-massive">DESIGN<br>WITHOUT<br>APOLOGY</h1>
  <p class="lede">A manifesto for the next decade of work.</p>
</section>
```

```css
.hero {
  border-bottom: 2px solid var(--fg);
  padding: 96px 24px 48px;
}

.display-massive {
  font-family: 'Times New Roman', serif;
  font-size: clamp(80px, 12vw, 200px);
  line-height: 0.85;
  font-weight: 400;
  letter-spacing: -0.04em;
  margin: 0;
}

.meta {
  font-family: ui-monospace, monospace;
  font-size: 11px;
  text-transform: uppercase;
  margin-bottom: 24px;
}

.lede {
  font-family: ui-monospace, monospace;
  font-size: 16px;
  margin-top: 32px;
  max-width: 60ch;
}
```

### Buttons (no rounded — sharp)
```css
.btn-primary {
  background: var(--fg);
  color: var(--paper);
  padding: 12px 20px;
  border-radius: 0;
  font-family: ui-monospace, monospace;
  font-weight: 700;
  text-transform: uppercase;
  font-size: 13px;
  letter-spacing: 0.05em;

  &:hover {
    background: var(--accent);
    color: white;
  }
}

.btn-secondary {
  background: transparent;
  color: var(--fg);
  border: 2px solid var(--fg);
  /* Same radius=0, same uppercase */
}
```

### Asymmetric 70/30 Layout
```css
.split {
  display: grid;
  grid-template-columns: 7fr 3fr;
  gap: 0;
  border-top: 2px solid var(--fg);
  border-bottom: 2px solid var(--fg);
}

.split > * {
  padding: 32px;
}

.split > * + * {
  border-left: 2px solid var(--fg);
}

@media (max-width: 768px) {
  .split { grid-template-columns: 1fr; }
  .split > * + * { border-left: 0; border-top: 2px solid var(--fg); }
}
```

### Underlined Links (no hover decoration)
```css
a {
  color: var(--accent);
  text-decoration: underline;
  text-decoration-thickness: 1px;
  text-underline-offset: 3px;
}

a:hover {
  text-decoration-thickness: 2px;
  /* NO color change, NO background, NO arrow */
}
```

### Tables (raw, no styling)
```css
table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  border: 2px solid var(--fg);
  padding: 12px;
  font-family: monospace;
  font-size: 13px;
}

th {
  background: var(--fg);
  color: var(--paper);
  text-transform: uppercase;
}
```

## 5. Layout

- NO container max-width — full-bleed dominant
- Section padding: `py-24` desktop / `py-16` mobile
- Grid asymmetric (70/30, 60/40, 80/20)
- Whitespace where strategic, density where intentional

## 6. Imagery

- Raw, un-edited photography (or stock B&W)
- Heavy halftone / dithered effects acceptable
- KHÔNG rounded image corners. KHÔNG drop shadow.
- Image captions: monospace small, ABOVE image (not below)

## 7. Voice & Copy

- Declarative. Manifesto-style. Short punchy sentences.
- Capitalize for emphasis (BUT NOT EVERYWHERE — strategic)
- Numbers as digits, not spelled out
- No corporate hedge language ("might", "could", "perhaps")

## 8. Animation
- MINIMAL — brutalist không animate
- 1 strategic scroll-trigger (header reveal, hero text fade-in) max
- KHÔNG hover wiggle, KHÔNG parallax, KHÔNG marquee

## 9. Anti-Patterns Specific
- KHÔNG soft borders (`border-neutral-200`) — borders FULL ink
- KHÔNG rounded corners > 2px
- KHÔNG drop shadows
- KHÔNG gradients
- KHÔNG center hero — left-align dominant
- KHÔNG icons — typography carries it
- KHÔNG color tints (status pills) — use full color hoặc text-only
- KHÔNG decorative dividers — `border-t-2 border-fg` đủ
