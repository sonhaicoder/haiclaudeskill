# DESIGN.md — Monocle Editorial

> Direction: `editorial-monocle`
> Reference: Monocle magazine, FT Weekend, NYT Magazine, It's Nice That
> Mode: brand (editorial-only)

## 1. Visual Theme

Print-magazine feel translated to web. Generous whitespace, large serif headlines, restrained palette of off-white paper + ink + single warm accent. Confident, quietly intelligent. The page reads like an essay, not a product pitch.

**Key Characteristics:**
- Off-white "paper" background (`#f7f3ed`)
- Iowan Old Style / Charter serif display
- System sans body (16-18px, generous line-height)
- Warm rust accent, used at most twice per spread
- NO shadows. NO rounded cards. Borders + whitespace do the work
- Mono UPPERCASE eyebrows / kickers
- One decisive image, cropped only at bottom

## 2. Color Palette

### Backgrounds
- Paper: `#f7f3ed` / `oklch(97% 0.012 80)`
- Surface: `#fdfbf7` / `oklch(99% 0.005 80)`
- Sidebar/aside: `#f0ece4` / `oklch(94% 0.014 80)`

### Text
- Ink (primary): `#1a1612` / `oklch(20% 0.02 60)`
- Muted: `#6b6357` / `oklch(48% 0.015 60)`
- Tertiary: `#a39d8e` / `oklch(70% 0.012 80)`

### Accent (warm rust / clay)
- Primary: `#b04832` / `oklch(58% 0.16 35)`
- Hover: `#9a3e2a` / `oklch(53% 0.16 35)`

### Borders
- Default: `#e0d9cc` / `oklch(89% 0.012 80)`
- Strong (rule lines): `#1a1612` / `oklch(20% 0.02 60)` (full ink)

## 3. Typography

### Font Family
- **Display:** `'Iowan Old Style'`, `'Charter'`, Georgia, `'Times New Roman'`, serif
- **Body:** -apple-system, BlinkMacSystemFont, `'Segoe UI'`, system-ui, sans-serif
- **Mono:** `'IBM Plex Mono'`, ui-monospace, Menlo, monospace

### Hierarchy

| Role | Font | Size | Weight | Tracking | Line Height |
|------|------|------|--------|----------|-------------|
| Hero | serif | clamp(56px, 8vw, 120px) | 400 | -0.015em | 0.95 |
| Display | serif | 64px | 400 | -0.01em | 1.05 |
| H1 | serif | 40px | 500 | -0.005em | 1.15 |
| H2 | serif | 28px | 500 | normal | 1.25 |
| H3 (sans) | sans | 18px | 600 | -0.005em | 1.4 |
| Body Large | sans | 19px | 400 | normal | 1.7 |
| Body | sans | 17px | 400 | normal | 1.65 |
| Small | sans | 14px | 400 | normal | 1.5 |
| **Eyebrow** | mono | 11px | 500 | 0.15em | 1.4 (UPPERCASE) |
| Caption | sans | 13px | 400 | normal | 1.4 |

### Principles
- Display SERIF dominant — never compete với body sans
- Body line-height GENEROUS (1.65-1.7) for long-form readability
- Eyebrow/kicker dùng MONO UPPERCASE wide tracking — magazine signature
- Numbers in body: tabular-nums

## 4. Components

### Article Header
```html
<header>
  <p class="eyebrow">— ESSAY · ISSUE 47</p>
  <h1 class="display-serif">The art of typography in the digital age</h1>
  <p class="byline">By Linh Nguyen — 2026-04-15 — 12 min read</p>
</header>
```

```css
.eyebrow {
  font-family: var(--mono);
  font-size: 11px;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--accent);
  margin-bottom: 24px;
}

.display-serif {
  font-family: var(--serif);
  font-size: clamp(48px, 6vw, 84px);
  font-weight: 400;
  line-height: 1.05;
  letter-spacing: -0.012em;
  margin-bottom: 16px;
}

.byline {
  font-size: 14px;
  color: var(--muted);
  font-style: italic;
}
```

### Pull Quote
```css
blockquote {
  border-left: 2px solid var(--accent);
  padding-left: 24px;
  margin: 48px 0;
  font-family: var(--serif);
  font-size: 24px;
  line-height: 1.4;
  font-style: italic;
}
```

### Buttons (subtle, no flash)
```css
.btn-primary {
  background: var(--ink);
  color: var(--paper);
  padding: 12px 20px;
  border-radius: 0;  /* SHARP corners */
  font-weight: 500;
}

.btn-link {
  color: var(--accent);
  border-bottom: 1px solid var(--accent);
  padding-bottom: 1px;
}
```

### Image (newspaper crop)
```css
.editorial-image {
  width: 100%;
  aspect-ratio: 4/5;
  object-fit: cover;
  /* Dùng raw image, KHÔNG border-radius, KHÔNG shadow */
}

.editorial-image-caption {
  font-size: 13px;
  color: var(--muted);
  margin-top: 8px;
  font-style: italic;
}
```

## 5. Layout

- Container: `max-width: 720px` cho prose (optimal reading width)
- Grid: 12-col with `gap-8`. 2-col text + sidebar pattern common
- Section padding: `py-32` (massive whitespace mimics magazine spread)
- Text columns: long-form `column-count: 2` desktop, single-col mobile

## 6. Imagery

- B&W or muted-tone photography
- Documentary style: real people, real places, no stock smiley
- Aspect ratios: 4:5 portrait, 16:9 landscape, 1:1 square (mix for variety)
- Image captions in italic muted text BELOW image

## 7. Voice & Copy

- Tone: thoughtful, slow, considered. Long sentences OK
- 1st-person essay voice, or 3rd-person reportage
- Real bylines (author photo + bio at bottom)
- Numbers spelled out when small ("twenty years", not "20 years")
- Em-dashes — not hyphens — for parenthetical thought

## 8. Anti-Patterns Specific
- KHÔNG rounded cards — borders OR pure whitespace separation
- KHÔNG drop shadows — print magazines don't have shadows
- KHÔNG icon next to heading — typography enough
- KHÔNG CTA button trên hero — soft text link đủ
- KHÔNG sidebar promotional widgets — keep page clean cho prose
- KHÔNG accent color spam — rust accent xuất hiện ≤2 lần per spread
