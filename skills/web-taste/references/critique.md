# 5-Dimensional Self-Critique

> Source: distilled từ [open-design](https://github.com/nexu-io/open-design) discovery prompt § "5-dimensional critique" + huashu-design self-review framework.

> Run critique ở **Step 8** workflow (sau Step 7 anti-slop audit, trước emit artifact).

---

## Triết lý

```
LLM mặc định ship "trung bình đẹp" — nhìn OK, không có taste.
Self-critique force agent suy nghĩ về 5 dimensions trước khi ship:
  philosophy / hierarchy / execution / specificity / restraint

Bất kỳ dimension < 3/5 → REGRESSION → fix → re-score.
2 passes là normal. Đừng skip.
```

---

## 5 Dimensions với scoring rubric

### 1. PHILOSOPHY (1-5) — Có match cái user yêu cầu không?

```
5/5: Visual posture đúng 100% với brief — editorial brief → editorial output
     (serif display, generous whitespace, restrained palette)
4/5: Posture đúng nhưng có vài lapses (1 anti-pattern slip)
3/5: Half-match — execution OK nhưng hơi drift về "modern minimal default"
2/5: Drift mạnh — brief brutalist nhưng output rounded cards Linear-style
1/5: Hoàn toàn off — brief editorial nhưng output dashboard utility
```

**Câu hỏi check:**
- "Brief nói 'editorial magazine'. Output có serif display, generous whitespace, kicker uppercase, accent rust/clay không?"
- "Brief nói 'brutalist'. Output có loud serif, mono body, asymmetric 70/30 layout không?"
- Hay đã drift về Linear-vibe default Modern Minimal?

**Drift thường gặp:**
- Brief warm-soft → output cool blue minimal (LLM bias toward cool grays)
- Brief brutalist → output rounded cards (LLM bias toward "safe")
- Brief editorial → output system sans display (LLM bias against serif)

---

### 2. HIERARCHY (1-5) — Eye land vào MỘT chỗ rõ ràng?

```
5/5: Squint test → 1 focal point ngay lập tức (hero CTA, key metric, hero image)
4/5: 1 primary + 1 secondary focal — clear ranking
3/5: 2-3 elements compete, eye scan không ổn định
2/5: Everything competing — không có visual leader
1/5: Wall of equal-weight content, không có entry point
```

**Câu hỏi check:**
- Squint test (narrow eye, blur image): điểm gì pop ra trước? Đúng cái user muốn nhấn không?
- Hero section có ONE primary CTA, hay 3 CTA equal weight?
- Type scale có ratio rõ (h1 vs h2 vs body): tối thiểu 1.5x giữa cấp?
- Color contrast có dẫn eye: accent color CHỈ 1-2 chỗ trên screen?

**Fix khi < 3:**
- Bump primary action 2x size + accent color
- Demote secondary actions thành ghost button hoặc text link
- Increase whitespace quanh focal point
- Bỏ decorative element competing

---

### 3. EXECUTION (1-5) — Typography, spacing, alignment, contrast đúng hay just close?

```
5/5: Mathematical perfection — gap consistent (4/8/16/24/32 scale), align pixel-perfect, contrast WCAG AA
4/5: 95% perfect, 1-2 spacing inconsistencies
3/5: "Looks fine" but có gap awkward (gap-3, gap-5, gap-7 random)
2/5: Multiple alignment issues, contrast borderline
1/5: Visibly off — gap mismatch, text bleeding, contrast fail
```

**Câu hỏi check:**
- Spacing scale có nhất quán? (4/8/12/16/24/32 hoặc 4/6/8/12/16/24)
- Gap giữa form fields đều nhau? Padding card đều? Section padding nhất quán?
- Text contrast: body có pass WCAG AA (4.5:1)? Muted text có ≥ 3:1?
- Alignment: edge của image align với text container? Button center align với label?
- Letter-spacing: display có tracking-tighter, body có normal/wide?
- Line-height: body 1.6, display 1.0-1.1?

**Fix khi < 3:**
- Run grid overlay (Chrome DevTools) — check alignment
- Replace gap-3/gap-5/gap-7 với gap-4/gap-6/gap-8
- Bump muted text contrast nếu < 3:1
- Tighten display tracking nếu loose

---

### 4. SPECIFICITY (1-5) — Mỗi word/number/image specific cho brief NÀY?

```
5/5: Mọi copy reflects user's specific product/audience. No filler.
4/5: 90% specific, 1-2 placeholder slips
3/5: Half real, half generic ("Smart features", "Modern design")
2/5: Mostly generic with brief-specific intro only
1/5: Pure lorem ipsum / "Feature One / Feature Two"
```

**Câu hỏi check:**
- Hero headline reflect user's actual value prop, hay generic "Build faster"?
- Feature names có specific verb+noun ("Cut billing time 2h → 15min"), hay generic ("Easy to use")?
- Numbers từ user data, hay AI invented "10× faster, 99.9% uptime"?
- Customer logos = real? Hay generic "Acme/Nexus" placeholder?
- Avatar names: real ("Linh Nguyen") hay "John Doe"?
- Image: relevant to product, hay generic stock?

**Fix khi < 3:**
- Replace generic features với 3-5 specific use cases từ brief
- Replace fake metrics với honest placeholder (`—`, `[your metric]`)
- Replace placeholder names với realistic variant
- Add 1 quote/testimonial với context (real or labelled stub)

---

### 5. RESTRAINT (1-5) — One accent ≤ 2 lần, one decisive flourish?

```
5/5: 1 accent color, 1 hero flourish, rest neutral. Quiet confidence.
4/5: 1 accent + 1 secondary tint, 1 flourish. Still controlled.
3/5: 2 accents competing, 1-2 flourishes. Slightly noisy.
2/5: 3+ colors, multiple flourishes. Visual chaos starting.
1/5: Rainbow palette, 5 flourishes, every section has unique decoration.
```

**Câu hỏi check:**
- Đếm accent color trên 1 screen — > 2 lần xuất hiện? Trim xuống.
- Bao nhiêu "decorative flourishes" (gradient bg, animated blob, hero illustration, custom shape)? Hơn 1 → trim.
- Có "feature creep visually" — mỗi section unique pattern? → Restrain xuống 1 visual rhythm cho cả page.
- Animations: > 3 animation types trên 1 page? Trim xuống 1-2 (entrance reveal + hover state).

**Fix khi < 3:**
- Pick 1 hero flourish, kill rest
- Limit accent color usage = 2 instances per screen (links + 1 CTA)
- Section divider: thay `bg-gradient` bằng `border-t border-neutral-200`
- Animation: keep entrance reveal, kill marquee/parallax/glow loops

---

## Critique workflow

```
1. Score self silently (1-5 mỗi dimension)
2. Identify weakest dimension
3. Fix that dimension specifically
4. Re-score (entire page, không chỉ fixed area)
5. Repeat until ALL ≥ 3/5
6. Then emit <artifact>
```

**Time budget:** 2-5 min critique, 5-10 min fixes. Tổng pass tối đa 2 lần — pass 3+ = scope creep, ship version pass 2.

---

## Common patterns by weak dimension

### Weak Philosophy → Drift
**Fix:** Re-read direction spec. Bind palette/font verbatim. Apply 2-3 posture cues explicitly.

### Weak Hierarchy → No focal point
**Fix:** Bump primary CTA. Reduce competing accents. Increase whitespace around focal area.

### Weak Execution → Sloppy details
**Fix:** Grid overlay audit. Standardize spacing scale. Recheck contrast ratios.

### Weak Specificity → Generic copy
**Fix:** Replace top 3 generic phrases với brief-specific. Replace fake numbers với honest placeholder.

### Weak Restraint → Too noisy
**Fix:** Pick 1 flourish, kill rest. Limit accent to 2 instances. Use border-t instead of decorative dividers.

---

## Why critique > "trust the model"

LLM được train trên web data trung bình → output mặc định trung bình. Critique force model output ABOVE its training distribution.

Without critique:
- Output: "decent landing page, looks like Bootstrap template"
- User: "ship it" (settles)

With critique:
- Pass 1: Score hierarchy 2/5 → fix CTA prominence
- Pass 2: Score specificity 2/5 → replace fake metrics với honest stub
- Output: "actually feels like a senior designer made this"

5 minutes critique = 5x output quality. Always worth it.
