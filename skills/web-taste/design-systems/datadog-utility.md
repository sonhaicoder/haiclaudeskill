# DESIGN.md — Datadog / GitHub Utility

> Direction: `tech-utility`
> Reference: Datadog, GitHub, Cloudflare dashboard, Sentry, Grafana
> Mode: product (data-heavy admin/dashboard)

## 1. Visual Theme

Information per square inch. Made for engineers and operators who want data visible, không vibes. No marketing voice. No hero illustrations. Show the product instead.

**Key Characteristics:**
- Cool near-white bg với hairline borders (no shadows)
- Inter / Geist sans family — display + body cùng family OK
- JetBrains Mono / Geist Mono cho code, IDs, hashes
- Tabular numerics everywhere
- Signal green accent (`#27a644`) cho success/active states
- Dense tables with hairline borders, NO row striping
- Inline status pills với restrained tinted bg
- High info density (VISUAL_DENSITY 7-9)

## 2. Color Palette

### Backgrounds
- Page: `#fafbfc` / `oklch(98% 0.005 250)`
- Surface (card): `#ffffff` / `oklch(100% 0 0)`
- Subtle (hover): `#f3f5f7` / `oklch(96% 0.005 250)`
- Code block: `#f6f8fa` / `oklch(97% 0.005 250)`

### Text
- Primary: `#1f2328` / `oklch(22% 0.02 240)`
- Secondary: `#656d76` / `oklch(50% 0.018 240)`
- Tertiary: `#8c959f` / `oklch(65% 0.012 240)`
- Inverted (on dark): `#f0f6fc`

### Accent (signal green)
- Primary: `#1f883d` / `oklch(50% 0.16 145)`
- Hover: `#1a7f37` / `oklch(48% 0.16 145)`
- Bg tint: `#dcfce7` / `oklch(94% 0.06 145)` (for success pills)

### Brand Blue (links, interactive)
- Primary: `#0969da` / `oklch(52% 0.2 252)`
- Hover: `#0860ca` / `oklch(48% 0.2 252)`

### Borders
- Default: `#d1d9e0` / `oklch(88% 0.008 240)`
- Subtle: `#e1e7ed` / `oklch(92% 0.008 240)`
- Strong: `#b1bac4` / `oklch(78% 0.012 240)`

### Status (inline pills)
- Success: bg `#dcfce7`, text `#15803d`
- Warning: bg `#fef3c7`, text `#a16207`
- Danger: bg `#fecaca`, text `#b91c1c`
- Info: bg `#dbeafe`, text `#1e40af`
- Neutral: bg `#f3f4f6`, text `#4b5563`

## 3. Typography

### Font Family
- **Display & Body:** `'Inter Variable'`, `'Geist'`, -apple-system, system-ui (SAME family OK)
- **Mono:** `'JetBrains Mono'`, `'IBM Plex Mono'`, `'Geist Mono'`, ui-monospace, Menlo

### Hierarchy

| Role | Font | Size | Weight | Tracking | Line Height |
|------|------|------|--------|----------|-------------|
| Page Title | sans | 24px | 600 | -0.01em | 1.25 |
| H1 (section) | sans | 20px | 600 | normal | 1.3 |
| H2 | sans | 16px | 600 | normal | 1.4 |
| H3 | sans | 14px | 600 | normal | 1.4 |
| Body | sans | 14px | 400 | normal | 1.5 |
| Body Medium | sans | 14px | 500 | normal | 1.5 |
| Small | sans | 12px | 400 | normal | 1.4 |
| Caption | sans | 12px | 500 | 0.02em | 1.4 |
| Mono Code | mono | 13px | 400 | normal | 1.5 |
| Mono Numeric | mono | 14px | 400 | normal | 1.4 |

### Principles
- ONE font family cho display + body — utility trumps editorial
- Tabular numerics MẶC ĐỊNH cho mọi data table: `font-variant-numeric: tabular-nums`
- Mono cho: code blocks, IDs, hashes, kbd shortcuts, terminal output
- Display sizes RESTRAINED (24px max page title, không hero 60px+)

## 4. Components

### Data Tables (dense, hairline borders)
```css
table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

thead {
  border-top: 1px solid #d1d9e0;
  border-bottom: 1px solid #d1d9e0;
}

th {
  text-align: left;
  padding: 8px 12px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: #656d76;
  background: #f6f8fa;
}

td {
  padding: 10px 12px;
  border-bottom: 1px solid #e1e7ed;  /* Hairline only */
  vertical-align: top;
}

td.numeric {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-family: var(--mono);
}

tbody tr:hover {
  background: #f6f8fa;
}

/* NO row striping — clean separation */
```

### Status Pills (inline)
```html
<span class="pill pill-success">Active</span>
<span class="pill pill-warning">Pending</span>
<span class="pill pill-danger">Failed</span>
```

```css
.pill {
  display: inline-flex;
  align-items: center;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
  line-height: 1.4;
}

.pill-success { background: #dcfce7; color: #15803d; }
.pill-warning { background: #fef3c7; color: #a16207; }
.pill-danger  { background: #fecaca; color: #b91c1c; }
.pill-neutral { background: #f3f4f6; color: #4b5563; }
```

### Buttons (compact, no flair)
```css
.btn {
  height: 32px;
  padding: 0 12px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.btn-primary {
  background: #1f883d;
  color: white;
  border: 1px solid rgba(0,0,0,0.1);
}

.btn-secondary {
  background: white;
  color: #1f2328;
  border: 1px solid #d1d9e0;
}

.btn-secondary:hover {
  background: #f6f8fa;
  border-color: #b1bac4;
}
```

### Code Block
```css
.code {
  background: #f6f8fa;
  border: 1px solid #d1d9e0;
  border-radius: 6px;
  padding: 12px 16px;
  font-family: var(--mono);
  font-size: 13px;
  line-height: 1.45;
  color: #1f2328;
  overflow-x: auto;
}

.code-inline {
  background: rgba(175, 184, 193, 0.2);
  padding: 0.2em 0.4em;
  border-radius: 4px;
  font-family: var(--mono);
  font-size: 0.85em;
}
```

### Cards (TỐI THIỂU — dùng khi elevation = hierarchy)
```css
.card {
  background: white;
  border: 1px solid #d1d9e0;
  border-radius: 8px;
  padding: 16px;
}

/* Mặc định KHÔNG dùng card — dùng border-t / divide-y cho data grouping */
.section-divider {
  border-top: 1px solid #d1d9e0;
  margin: 24px 0;
}
```

### KBD shortcuts
```css
kbd {
  display: inline-block;
  padding: 2px 6px;
  font-family: var(--mono);
  font-size: 12px;
  background: white;
  border: 1px solid #d1d9e0;
  border-bottom-width: 2px;
  border-radius: 4px;
  color: #1f2328;
}
```

## 5. Layout

- Container: `max-width: 1280px` cho dashboard, `1440px` cho data tables full-bleed
- Section padding: `py-6` (24px) desktop, `py-4` mobile (DENSE)
- Page padding: `px-4` mobile, `px-6` desktop
- Sidebar: `width: 260px` fixed, dark variant `bg-neutral-900`

## 6. Information Density

```
Goal: VISUAL_DENSITY = 7-9
- Tiny padding (8-12px cell padding, không 24px)
- Hairline borders (1px, không 2px)
- 14px body (không 17-18px)
- Compact buttons (h-32px, không h-44px)
- Mono numerics tabular
- KHÔNG card overuse — dùng border-t / divide-y
```

## 7. Anti-Patterns Specific
- KHÔNG hero section với image — show product/dashboard ngay
- KHÔNG oversized H1 — page title max 24px
- KHÔNG marketing copy ("Elevate", "Seamless") — technical voice
- KHÔNG decorative shadows — hairline borders only
- KHÔNG row striping in tables — hover state đủ
- KHÔNG icon next to every label — icons CHỈ khi semantic
- KHÔNG generous whitespace — đây là cockpit, không gallery
- KHÔNG serif headlines — sans dominant
