# Discovery Form — Full Pattern Reference

> Source: distilled từ [open-design](https://github.com/nexu-io/open-design) `packages/contracts/src/prompts/discovery.ts` (turn-1 discovery directive).

## Triết lý

```
"30 giây radio buttons beats 30 phút redirects"

User nhanh ở radio button. Chậm ở việc redirect khi AI gen sai hướng.
Discovery form lock những thứ AI hay đoán bậy:
  - Output type (deck vs landing vs dashboard)
  - Surface (mobile vs desktop vs responsive)
  - Audience (B2B exec vs consumer mom vs dev)
  - Tone (editorial vs minimal vs brutalist)
  - Brand context (have spec / pick / match reference)
  - Scale (1 page vs 8 slides vs 4 screens)
  - Constraints (real copy, deadline, must-avoid)
```

---

## Khi nào emit form (LUẬT)

```
EMIT khi:
  ✓ User mở task mới (không có active design)
  ✓ User gửi brief design mới
  ✓ Brief có vẻ phong phú nhưng vẫn còn open decisions

KHÔNG emit khi:
  ✗ User đang reply với tweak ("headline to hơn", "đổi màu accent")
  ✗ User explicit nói "skip form", "just build", "no questions, go"
  ✗ Message bắt đầu bằng [form answers — discovery] (đã có answers từ turn trước)
```

---

## Format chuẩn

```
1 dòng prose ngắn ("Got it — landing page cho SaaS B2B. Tell me the rest:")
+
<question-form id="discovery" title="Quick brief — 30 giây">
{ ... JSON body ... }
</question-form>
+
STOP TURN. KHÔNG narrate. KHÔNG "I'll wait."
```

---

## Default JSON template

```json
{
  "title": "Quick brief — 30 giây",
  "description": "Lock những cái này trước khi build. Skip cái không cần — fill default.",
  "questions": [
    {
      "id": "output",
      "label": "Build cái gì?",
      "type": "radio",
      "required": true,
      "options": [
        "Landing/marketing page",
        "App prototype (multi-screen)",
        "Dashboard / tool UI",
        "Editorial / content page",
        "Slide deck / pitch",
        "Khác — describe"
      ]
    },
    {
      "id": "platform",
      "label": "Surface chính",
      "type": "radio",
      "options": [
        "Mobile (375px first)",
        "Desktop web",
        "Responsive — all sizes",
        "Tablet",
        "Fixed canvas (1920×1080)"
      ]
    },
    {
      "id": "audience",
      "label": "Cho ai?",
      "type": "text",
      "placeholder": "VD: nhà đầu tư seed, dev-tools buyer, exec review nội bộ, người tiêu dùng 25-35"
    },
    {
      "id": "tone",
      "label": "Visual tone (chọn ≤2)",
      "type": "checkbox",
      "maxSelections": 2,
      "options": [
        "Editorial / magazine",
        "Modern minimal",
        "Tech / utility",
        "Luxury / refined",
        "Brutalist / experimental",
        "Soft / warm",
        "Playful / illustrative"
      ]
    },
    {
      "id": "brand",
      "label": "Brand context",
      "type": "radio",
      "required": true,
      "options": [
        "Pick a direction for me",
        "I have brand spec — sẽ share file",
        "Match reference site/screenshot — sẽ attach"
      ]
    },
    {
      "id": "scale",
      "label": "Quy mô",
      "type": "text",
      "placeholder": "VD: 1 hero + 4 sections, 8 slides, 4 mobile screens, 1 dashboard với 6 widget"
    },
    {
      "id": "constraints",
      "label": "Khác? (optional)",
      "type": "textarea",
      "placeholder": "Real copy có sẵn, font bắt buộc, thứ phải tránh, deadline, integration cần thiết…"
    }
  ]
}
```

---

## Authoring rules

- **JSON valid** — no comments, no trailing commas
- **`type` chỉ là 1 trong**: `radio`, `checkbox`, `select`, `text`, `textarea`
- **`checkbox` PHẢI có `maxSelections`** khi user chỉ chọn limited options. KHÔNG encode limit chỉ trong label
- **≤7 questions**, batch 2 nếu cần thêm
- **Tailor theo brief** — drop default user đã trả lời
- **ADD field tailored** cho cái brief unique cần (số slides, list mobile screens, sections của landing)
- **Lead 1 dòng prose ngắn** trước form. KHÔNG long preamble
- **Sau `</question-form>` STOP** — KHÔNG code, KHÔNG tools, KHÔNG narrate

---

## Tailoring examples

### Brief: "Build pitch deck cho seed round, magazine style"

Drop questions: `output` (đã biết deck), `tone` (đã biết editorial)
Add: `slide_count`, `speaker_notes`, `presenter_mode`

```json
{
  "questions": [
    { "id": "audience", "label": "Investor type?", "type": "radio",
      "options": ["Angels", "Pre-seed VCs", "Seed VCs", "Both" ] },
    { "id": "slide_count", "label": "Số slides", "type": "radio",
      "options": ["≤ 8", "10-12", "15-20", "20+"] },
    { "id": "speaker_notes", "label": "Speaker notes?", "type": "radio",
      "options": ["Có", "Không"] },
    { "id": "presenter_mode", "label": "Presenter mode (clicker/keyboard)?", "type": "radio",
      "options": ["Có", "Không"] },
    { "id": "brand", "label": "Brand", "type": "radio",
      "options": ["Pick direction for me", "Có brand spec sẵn"] },
    { "id": "constraints", "label": "Real numbers/copy/quotes?", "type": "textarea",
      "placeholder": "Paste real metrics, customer quotes, traction data…" }
  ]
}
```

### Brief: "Build dashboard cho admin"

Drop: `output` (dashboard), `tone` (default tech-utility)
Add: `widget_list`, `data_source`, `density`

```json
{
  "questions": [
    { "id": "platform", "label": "Surface", "type": "radio",
      "options": ["Desktop only", "Responsive", "Both"] },
    { "id": "audience", "label": "Ai dùng?", "type": "text",
      "placeholder": "VD: ops manager, customer support, finance team" },
    { "id": "widgets", "label": "Widgets cần có", "type": "textarea",
      "placeholder": "VD: revenue chart, top products, recent orders, low stock alerts" },
    { "id": "density", "label": "Density", "type": "radio",
      "options": ["Spacious (overview)", "Medium (daily ops)", "Cockpit (power user)"] },
    { "id": "data_source", "label": "Data từ đâu?", "type": "text",
      "placeholder": "VD: REST API, mock data, JSON file" },
    { "id": "brand", "label": "Brand", "type": "radio",
      "options": ["Tech-utility default", "Match company brand", "Pick direction"] }
  ]
}
```

---

## Edge cases

### User trả lời incomplete

User submit form chỉ điền vài field — coi field trống là "default":
- `tone` trống → infer từ `output` (landing → modern-minimal, deck → editorial, dashboard → tech-utility)
- `audience` trống → "general user"
- `scale` trống → use sensible default (landing = 1 hero + 4 sections, deck = 10 slides)
- `constraints` trống → no extra constraints

### User nói "just build, skip form"

Skip form → goto Turn 3 với tone-based default direction (xem `directions.md` § Selecting direction).

### User attach Figma / screenshot

Brief context có file attachment → vẫn emit form NHƯNG drop `brand` question (assumed Branch B = match reference). Add field `extraction_priority`:

```json
{
  "id": "extraction_priority",
  "label": "Match reference exactly hay adapt?",
  "type": "radio",
  "options": [
    "Exact — pixel-match",
    "Adapt — same vibe, my content",
    "Inspire — chỉ lấy palette/typography, layout của tôi"
  ]
}
```

### User reply với tweak ("make it bigger")

KHÔNG form. Direct apply tweak. Nếu tweak ambiguous ("better", "modern") → ask 1 câu cụ thể, KHÔNG form full.

---

## Why form > prose chat

| | Form | Prose chat |
|---|------|------------|
| User effort | 30s click radio | 3-5 min typing |
| Coverage | Locks ALL key decisions | Misses defaults |
| Clarity | Discrete options visible | Ambiguous wording |
| Iteration | Easy redirect (re-submit) | Re-explain whole brief |
| AI cost | Less back-and-forth tokens | More turns of clarification |

User không skill design → form GIÚP họ biết cần quyết định gì.
User skill design → form TIẾT KIỆM thời gian explain.

Win-win. **Always emit form on turn 1.**
