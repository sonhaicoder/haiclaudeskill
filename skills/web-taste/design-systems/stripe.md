# DESIGN.md — Stripe-inspired (pre-2020)

> Direction: `warm-soft`
> Reference: stripe.com (pre-2020 era), Mercury, Headspace
> Mode: brand + product

## 1. Visual Theme

Cream backgrounds, soft accent, gentle radii. Reads like a thoughtful product magazine — friendly without being cute. Premium fintech feel through restraint, not opulence.

**Key Characteristics:**
- Warm cream bg (`#fdfaf6`), not stark white
- Tiempos Headline display (serif), Söhne body (sans)
- Single terracotta/coral accent, used sparingly
- Soft inner glow on hero cards (no drop shadow)
- Gentle radii (12-16px), no hard corners
- 1 decisive editorial flourish per page (quote mark, stat callout)

## 2. Color Palette

### Backgrounds
- Cream: `#fdfaf6` / `oklch(97% 0.018 70)`
- Surface: `#ffffff` / `oklch(99% 0.008 70)`
- Subtle: `#f7f3ed` / `oklch(94% 0.02 70)`

### Text
- Primary: `#1a1a1a` / `oklch(22% 0.02 50)`
- Secondary: `#666666` / `oklch(50% 0.018 50)`
- Tertiary: `#999999` / `oklch(65% 0.012 50)`

### Accent
- Terracotta: `#c84e2c` / `oklch(64% 0.13 28)` (CTA, links)
- Hover: `#b03d1f` / `oklch(58% 0.14 28)`

### Borders
- Default: `#e8e3dc` / `oklch(90% 0.014 70)`
- Subtle: `#f0ebe3` / `oklch(93% 0.012 70)`

### Status
- Success: `#2d7a4f` / `oklch(50% 0.13 145)`
- Warning: `#c47a00` / `oklch(60% 0.14 70)`
- Danger: `#b83a3a` / `oklch(48% 0.16 25)`

## 3. Typography

### Font Family
- **Display:** `Tiempos Headline`, `Newsreader`, `Iowan Old Style`, Georgia, serif
- **Body:** `Söhne`, `Inter`, -apple-system, system-ui, sans-serif
- **Mono:** `Söhne Mono`, ui-monospace, Menlo

### Hierarchy

| Role | Size | Weight | Tracking | Line Height |
|------|------|--------|----------|-------------|
| Display | clamp(48px, 6vw, 84px) | 400 | -0.02em | 1.05 |
| H1 (serif) | 40px | 400 | -0.015em | 1.1 |
| H2 (serif) | 28px | 400 | -0.01em | 1.2 |
| H3 (sans) | 20px | 600 | normal | 1.3 |
| Body Large | 19px | 400 | normal | 1.6 |
| Body | 16px | 400 | normal | 1.55 |
| Small | 14px | 400 | normal | 1.5 |
| Caption | 13px | 500 | 0.02em | 1.4 |

### Principles
- Display SERIF lớn, body SANS — clear pairing
- Body line-height generous (1.55-1.6)
- Numbers `font-variant-numeric: tabular-nums` cho data tables

## 4. Components

### Buttons (Primary)
```css
background: #1a1a1a;
color: white;
padding: 12px 20px;
border-radius: 8px;
font-weight: 500;
font-size: 15px;

&:hover { background: #333333; }
```

### Buttons (Accent — used sparingly)
```css
background: #c84e2c;
color: white;
&:hover { background: #b03d1f; }
```

### Hero Cards
```css
background: white;
border: 1px solid #e8e3dc;
border-radius: 16px;
padding: 32px;
/* Inner glow instead of drop shadow */
box-shadow: inset 0 1px 0 rgba(255,255,255,0.6);
```

### Inputs
```css
background: white;
border: 1px solid #e8e3dc;
border-radius: 8px;
padding: 10px 14px;
font-size: 16px;

&:focus {
  border-color: #c84e2c;
  box-shadow: 0 0 0 3px rgba(200,78,44,0.15);
}
```

## 5. Imagery
- Real product screenshots (no abstract illustrations)
- Photography: warm-toned, human-centered (founder portraits, customer stories)
- Avoid: stock photos, generic 3D shapes, abstract gradients

## 6. Anti-Patterns Specific
- KHÔNG tech-bro voice ("Unleash", "Game-changer") — Stripe voice là calm, expert
- KHÔNG bright vibrant accent — terracotta nhẹ nhàng, không pop
- KHÔNG oversized H1 — display dùng restraint, weight 400 (không bold)
- KHÔNG icon-decorated headings — text confidence enough
