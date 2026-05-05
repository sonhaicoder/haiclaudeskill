# DESIGN.md — Linear-inspired

> Direction: `modern-minimal` (dark variant)
> Reference: linear.app
> Mode: product

## 1. Visual Theme

Dark-mode-first product design. Near-black canvas (`#08090a`) where content emerges from darkness like starlight. Extreme precision engineering: every element exists in carefully calibrated hierarchy of luminance. Information density managed through subtle gradations of white opacity, not color variation.

**Key Characteristics:**
- Dark-mode-native: `#08090a` marketing bg, `#0f1011` panel bg, `#191a1b` elevated surfaces
- Inter Variable với OpenType `cv01, ss03` enabled — geometric alternates
- Signature weight 510 cho UI text (between regular và medium)
- Aggressive negative letter-spacing at display sizes (-1.584px at 72px)
- Brand indigo-violet `#5e6ad2` / `#7170ff` — only chromatic color
- Semi-transparent white borders (`rgba(255,255,255,0.05-0.08)`)
- Berkeley Mono cho code/IDs

## 2. Color Palette

### Backgrounds
- Marketing Black: `#08090a` / `oklch(13% 0.005 250)`
- Panel: `#0f1011` / `oklch(15% 0.005 250)`
- Elevated: `#191a1b` / `oklch(20% 0.005 250)`
- Hover Surface: `#28282c` / `oklch(25% 0.008 250)`

### Text
- Primary: `#f7f8f8` / `oklch(96% 0.005 100)`
- Secondary: `#d0d6e0` / `oklch(85% 0.012 240)`
- Tertiary: `#8a8f98` / `oklch(60% 0.012 240)`
- Disabled: `#62666d` / `oklch(45% 0.01 240)`

### Brand
- Indigo: `#5e6ad2` / `oklch(55% 0.18 270)` (primary CTA bg)
- Accent Violet: `#7170ff` / `oklch(60% 0.22 275)` (links, active states)
- Hover: `#828fff` / `oklch(65% 0.2 275)`

### Borders
- Subtle: `rgba(255,255,255,0.05)` (default)
- Standard: `rgba(255,255,255,0.08)` (cards, inputs)
- Solid: `#23252a` / `oklch(22% 0.008 250)` (prominent)

### Status
- Success: `#27a644` / `oklch(60% 0.18 145)`
- Emerald: `#10b981` / `oklch(65% 0.16 165)`

## 3. Typography

### Font Family
- **Primary:** `Inter Variable`, fallbacks: SF Pro Display, system-ui
- **Mono:** `Berkeley Mono`, fallbacks: SF Mono, Menlo, ui-monospace
- **OpenType features:** `"cv01", "ss03"` enabled GLOBALLY

### Hierarchy

| Role | Size | Weight | Tracking |
|------|------|--------|----------|
| Display XL | 72px | 510 | -1.584px |
| Display | 48px | 510 | -1.056px |
| H1 | 32px | 400 | -0.704px |
| H2 | 24px | 400 | -0.288px |
| H3 | 20px | 590 | -0.24px |
| Body Large | 18px | 400 | -0.165px |
| Body | 16px | 400 | normal |
| Body Medium | 16px | 510 | normal |
| Small | 15px | 400 | -0.165px |
| Caption | 13px | 400 | -0.13px |

### Principles
- **510 = signature weight** cho UI text
- Display tracking aggressive negative (-1.5px at 72px)
- Inter Variable với cv01/ss03 = Linear's distinctive feel

## 4. Components

### Buttons (Ghost Default)
```css
background: rgba(255,255,255,0.02);
color: #e2e4e7;
border: 1px solid rgba(255,255,255,0.08);
padding: 0.5rem 1rem;
border-radius: 8px;
font-weight: 510;

&:hover { background: rgba(255,255,255,0.05); }
```

### Buttons (Primary)
```css
background: #5e6ad2;
color: white;
&:hover { background: #7170ff; }
```

### Cards
```css
background: #0f1011;
border: 1px solid rgba(255,255,255,0.08);
border-radius: 12px;
padding: 24px;
```

## 5. Anti-Patterns Specific
- KHÔNG color tints (xanh/đỏ/cam) ngoài indigo brand — Linear là achromatic system
- KHÔNG drop shadows lớn — Linear dùng inset shadows + border layers
- KHÔNG center hero — Linear dùng asymmetric với product screenshots dominant
