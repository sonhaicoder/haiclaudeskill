# DESIGN.md — Apple-inspired

> Direction: `modern-minimal` (premium variant)
> Reference: apple.com, MacOS Big Sur+
> Mode: brand + product

## 1. Visual Theme

San Francisco font system, near-monochrome palette, glassmorphism với inner refraction. Premium polish through pixel-perfect detail. Apple doesn't decorate — they engineer.

**Key Characteristics:**
- SF Pro Display headlines tracking-tighter
- Apple light: `#f5f5f7` page bg, white cards, no harsh borders
- Single saturated accent: `#0071e3` (links, primary CTA)
- Smooth radii: `8px` controls, `12px` cards, `18-22px` modals
- Hairline borders (`rgba(0,0,0,0.08)`)
- Glass nav: backdrop-blur `20px` + 1px inner border

## 2. Color Palette

### Backgrounds
- Page: `#f5f5f7` / `oklch(96% 0.002 250)`
- Surface: `#ffffff` / `oklch(100% 0 0)`
- Elevated: `#fbfbfd` / `oklch(98% 0.002 250)`
- Dark mode page: `#000000` (pure for OLED)
- Dark mode card: `#1d1d1f` / `oklch(20% 0.005 250)`

### Text
- Primary: `#1d1d1f` / `oklch(20% 0.005 250)`
- Secondary: `#6e6e73` / `oklch(50% 0.008 250)`
- Tertiary: `#86868b` / `oklch(58% 0.005 250)`

### Brand
- Apple Blue: `#0071e3` / `oklch(58% 0.18 255)`
- Hover: `#0077ed` / `oklch(60% 0.18 255)`

### Borders
- Hairline: `rgba(0,0,0,0.08)` / `oklch(0% 0 0 / 0.08)`
- Subtle: `rgba(0,0,0,0.04)`
- Glass border: `rgba(255,255,255,0.18)` (overlay on dark)

### Semantic
- Success: `#28cd41` / `oklch(72% 0.22 140)`
- Warning: `#ff9f0a` / `oklch(74% 0.18 65)`
- Danger: `#ff3b30` / `oklch(60% 0.24 25)`

## 3. Typography

### Font Family
- **Display:** `'SF Pro Display'`, -apple-system, BlinkMacSystemFont, system-ui, sans-serif
- **Body:** `'SF Pro Text'`, -apple-system, BlinkMacSystemFont, system-ui, sans-serif
- **Mono:** `'SF Mono'`, Menlo, monospace

### Hierarchy

| Role | Size | Weight | Tracking | Line Height |
|------|------|--------|----------|-------------|
| Hero | 80px | 600 | -0.025em | 1.05 |
| Display | 56px | 600 | -0.022em | 1.07 |
| H1 | 40px | 600 | -0.02em | 1.1 |
| H2 | 32px | 600 | -0.015em | 1.15 |
| H3 | 24px | 600 | -0.01em | 1.2 |
| Body Large | 19px | 400 | normal | 1.5 |
| Body | 17px | 400 | normal | 1.47 |
| Small | 14px | 400 | normal | 1.4 |
| Caption | 12px | 400 | normal | 1.3 |

### Principles
- Display tracking-tighter aggressive (-0.02em+)
- Body 17px là "Apple base" (16-18 range)
- Weight system: 400 (body), 500 (medium), 600 (semibold), 700 (bold rare)

## 4. Components

### Buttons (Primary — pill)
```css
background: #0071e3;
color: white;
padding: 12px 24px;
border-radius: 980px;  /* Pill */
font-weight: 400;
font-size: 17px;

&:hover { background: #0077ed; }
&:active { transform: scale(0.97); }
```

### Buttons (Secondary — link style)
```css
color: #0071e3;
background: transparent;
text-decoration: none;
padding: 12px 16px;

&:hover { text-decoration: underline; }
```

### Glass Navigation
```css
background: rgba(251,251,253,0.8);
backdrop-filter: saturate(180%) blur(20px);
border-bottom: 1px solid rgba(0,0,0,0.04);
position: sticky;
top: 0;
```

### Cards
```css
background: white;
border-radius: 18px;
padding: 32px;
/* No border, no shadow on white-on-grey */
```

### Hero Image (with subtle fade)
```css
background: white;
overflow: hidden;
position: relative;

&::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, transparent 70%, white 100%);
  pointer-events: none;
}
```

## 5. Layout

- Container: `max-width: 980px` text content, `1440px` full layouts
- Section padding: `py-32` desktop / `py-16` mobile
- Grid: 12-col với generous gaps

## 6. Motion

- Easing: `cubic-bezier(0.42, 0, 0.58, 1)` (Apple's signature ease)
- Duration: 400ms (page) / 200ms (UI)
- Scroll-driven product reveals: parallax với `transform: translateZ()`
- Sticky scroll: cards stack, scale, fade

## 7. Anti-Patterns Specific
- KHÔNG harsh shadows (`shadow-md/lg/xl`) — Apple dùng white-on-grey separation
- KHÔNG center text trên dark image — Apple asymmetric, image dominant
- KHÔNG decorative emoji icons — SF Symbols only
- KHÔNG random radii — strict `4 / 8 / 12 / 18 / 22 / 980 (pill)`
- KHÔNG generic "Inter" font — phải SF system stack
