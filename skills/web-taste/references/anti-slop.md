# 27 Anti-Patterns — Audit Checklist

> Source: distilled từ [impeccable.style](https://impeccable.style/) (27 deterministic rules) + [taste-skill](https://github.com/Leonxlnx/taste-skill) (AI Tells) + [open-design](https://github.com/nexu-io/open-design) anti-AI-slop.

> Run audit này ở **Step 7** của workflow (trước Step 8 critique, trước emit artifact). P0 PHẢI all pass.

---

## Cách đọc

```
P0 = MUST FIX before ship (regression)
P1 = SHOULD FIX (degrades quality)
P2 = NICE TO FIX (polish)

Mỗi pattern có:
  ✗ Anti-pattern (cấm)
  → Fix recommendation
  ─ Reason (tại sao là slop)
```

---

## VISUAL & CSS (8 patterns)

### 1. [P0] Purple/violet gradient backgrounds — "AI Purple"
✗ `bg-gradient-to-br from-purple-500 to-pink-500` cho hero
→ Dùng neutral base (Zinc/Slate/Stone) + 1 desaturated accent
─ "AI Purple" là signature của ChatGPT/Midjourney default — instantly tells AI-generated

### 2. [P0] Gradient text cho large headers
✗ `bg-clip-text text-transparent bg-gradient-to-r from-blue-500 to-purple-500` cho H1
→ Solid color, control hierarchy bằng weight + size
─ Reads cheap, không có brand identity

### 3. [P0] Pure black `#000000`
✗ `text-black`, `bg-black`
→ Off-black: `text-neutral-900` (`#171717`), `bg-zinc-950` (`#09090b`), `bg-stone-950`
─ Pure black quá harsh trên light bg, eye strain trên dark mode

### 4. [P0] Neon/outer glows
✗ `box-shadow: 0 0 20px rgba(168, 85, 247, 0.5)` (default purple glow)
→ Inner border (`shadow-[inset_0_1px_0_rgba(255,255,255,0.1)]`) hoặc tinted shadow
─ Outer glow = slop signature, không có grounding

### 5. [P1] Excessive shadows / `shadow-md`/`shadow-lg`/`shadow-xl` default
✗ Dùng Tailwind shadow defaults trên mọi card
→ Custom diffuse shadow tinted theo background hue: `shadow-[0_20px_40px_-15px_rgba(0,0,0,0.05)]`
─ Default shadows dày, đen, không có character

### 6. [P1] Custom mouse cursors
✗ `cursor: url(...)` custom emoji cursor
→ Default `cursor: pointer/default/text`. Magnetic effect OK với Framer Motion
─ Outdated 2010s tactic, ruins accessibility

### 7. [P1] Glassmorphism without inner refraction
✗ `backdrop-blur-md bg-white/30` — flat fake glass
→ Add 1px inner border (`border-white/10`) + inset shadow (`shadow-[inset_0_1px_0_rgba(255,255,255,0.1)]`)
─ Real glass có edge refraction, fake glass thiếu depth

### 8. [P2] Gradient on every background
✗ Mọi section có gradient bg
→ 1 gradient max per page, dùng làm focal point
─ Gradient overuse = noise, không có hierarchy

---

## TYPOGRAPHY (5 patterns)

### 9. [P0] Inter / Roboto / Arial làm DISPLAY face
✗ `<h1 class="font-inter text-6xl">` (Inter là body font, không phải display)
→ Display: `Geist`, `Outfit`, `Cabinet Grotesk`, `Satoshi`, `Newsreader`, `Tiempos`, `Iowan Old Style`
─ Inter cho body OK (built for screen body text), display cần character

### 10. [P0] Serif headlines trên Dashboard / Software UI
✗ `<h1 class="font-serif">` trong product/admin UI
→ Sans-serif strict cho dashboard. Serif chỉ dùng cho editorial/marketing
─ Serif breaks data-density vibe, conflict với mono numerics

### 11. [P1] Italic-serif display headers
✗ `<h1 class="italic font-serif">` (cliché editorial fake)
→ Roman (regular) hoặc weight 510-590, KHÔNG italic
─ Italic-serif cho headline reads như "fake luxury" template

### 12. [P1] Oversized H1 ngoài kiểm soát
✗ `text-9xl` mọi lúc cho impact
→ Control hierarchy bằng weight + color, không chỉ scale. Display max `text-6xl`/`text-7xl` mặc định
─ Oversize H1 = compensating, không có taste

### 13. [P2] Body line-height < 1.5
✗ `leading-tight` cho body paragraph
→ Body: `leading-relaxed` (1.6-1.7) cho readability
─ Tight body = unreadable cho long-form

---

## LAYOUT & SPACING (4 patterns)

### 14. [P0] Centered Hero text trên dark image
✗ `<section class="bg-black"><h1 class="text-center">...` (template default)
→ Asymmetric Hero: text left/right aligned, image với subtle fade
─ Centered hero = stock template signature

### 15. [P0] 3-column equal cards generic feature row
✗ `grid-cols-3 gap-6` với 3 cards icon+title+desc identical
→ Bento Grid asymmetric, Zig-Zag (text|image alternating), horizontal scroll, hoặc 2-col offset
─ "3-column features" là YouTube template default

### 16. [P1] `h-screen` cho full-height Hero (mobile bug)
✗ `<section class="h-screen">` — iOS Safari layout jump
→ `min-h-[100dvh]` (dynamic viewport height)
─ `h-screen` = catastrophic layout jump khi browser chrome show/hide

### 17. [P1] Complex flexbox percentage math
✗ `w-[calc(33%-1rem)]` cho 3-col layout
→ CSS Grid (`grid grid-cols-1 md:grid-cols-3 gap-6`)
─ Flex math = brittle, breaks responsive

---

## CONTENT & DATA — "Jane Doe Effect" (5 patterns)

### 18. [P0] Generic placeholder names
✗ "John Doe", "Sarah Chan", "Jack Smith", "Acme Corp"
→ Realistic specific names: "Linh Nguyen", "Maya Gokhan", "Thuy Pham". Brands: contextual ("Northwind Studio", "Brewlab Coffee")
─ Generic names = AI gen signature

### 19. [P0] Fake metrics without source
✗ "10× faster", "99.9% uptime", "trusted by 1M+ users" (no proof)
→ Real numbers từ user, hoặc honest placeholder (`—`, `[your metric here]`, grey block)
─ **Honest placeholder beats fake stat.** Fake number = trust killer

### 20. [P0] Predictable/round numbers
✗ "50%", "99.99%", "$1,234", "1,000,000 users"
→ Organic data: "47.2%", "+1 (312) 847-1928", "$1,247", "843K users"
─ Round numbers = lazy AI default

### 21. [P1] AI copywriting clichés
✗ "Elevate your workflow", "Seamless integration", "Unleash potential", "Next-gen platform", "Game-changing", "Delve into..."
→ Concrete verbs: "Cut billing time from 2h to 15min", "Replace 5 tools with 1"
─ Cliché filler = ChatGPT essay smell

### 22. [P2] Generic SVG egg avatars / Lucide user icons
✗ `<User />` icon từ Lucide cho mọi avatar slot
→ Real photos (Picsum.photos) hoặc styled initials với branded colors
─ Egg avatars = placeholder hell

---

## ICONS (2 patterns)

### 23. [P0] Emoji feature icons (✨ 🚀 🎯 🔥 ⚡ 💡)
✗ Section header: "✨ Smart features" / "🚀 Lightning fast"
→ Phosphor/Radix/Heroicons với consistent stroke width. Hoặc bỏ icon hẳn
─ Emoji icons = AI gen signature mạnh nhất

### 24. [P1] Icon next to every heading
✗ Mọi `<h2>` có icon prefix
→ Icons CHỈ khi adds info (status, action, category). KHÔNG decoration
─ Decorative icons = visual noise

---

## EXTERNAL RESOURCES (2 patterns)

### 25. [P0] Unsplash placeholder URLs
✗ `<img src="https://images.unsplash.com/photo-XXXXX">`
→ `https://picsum.photos/seed/{string}/800/600` (deterministic, không bị deleted) hoặc real assets
─ Unsplash links broken hàng tháng

### 26. [P1] shadcn/ui generic default state
✗ `import { Button } from "@/components/ui/button"` mà không customize
→ Customize radii, colors, shadows match project aesthetic
─ Default shadcn = "I just bootstrap'd an AI app"

---

## CARDS & CONTAINERS (1 pattern)

### 27. [P1] Rounded card với left coloured border accent
✗ `<div class="rounded-lg border-l-4 border-blue-500 p-4">` (Bootstrap alert vibe)
→ Hairline border `border border-neutral-200`, hoặc `border-t` với hover state
─ Left-colored-border = Bootstrap alert pattern, dated

---

## QUICK AUDIT (chạy trước khi emit artifact)

```
□ Không có purple/pink gradient bg?
□ Không có neon/outer glow?
□ Không pure black `#000000`?
□ Display font không phải Inter/Roboto/Arial?
□ Không serif trên dashboard?
□ Không centered hero trên dark image?
□ Không 3-col equal feature cards?
□ Không Jane Doe / Acme placeholder?
□ Không fake "99%" metrics?
□ Không "Elevate/Seamless/Unleash" filler?
□ Không emoji feature icons?
□ Không Unsplash URLs?
□ Không default shadcn?
```

**Bất kỳ ✗ → fix trước Step 8 critique. P0 fail → KHÔNG được emit.**

---

## Deeper checklist khi audit (5-min review)

1. **Open file trên browser** — KHÔNG chỉ trust build pass
2. **Squint test** — narrow eye nhìn page. Hierarchy có rõ không? 1 focal point?
3. **Mobile 375px** — mở Chrome DevTools mobile, scroll qua hết. Có overflow? Layout vỡ?
4. **Read aloud** — copy có sound như AI gen? Có placeholder filler không?
5. **Screenshot test** — chụp full page, gửi cho design friend qua Slack. Hỏi: "AI generate hay human design?" Nếu họ đoán AI → fix.

---

## Khi gặp anti-pattern không tránh được

Đôi khi user explicit yêu cầu pattern bị banned (vd: "tôi muốn purple gradient hero").

Cách handle:
1. **Comply** — user là boss, không lecture
2. **Push back NHẸ** ngay sau khi build: "Em đã build với purple gradient. FYI cái này thường tells AI-gen mạnh — nếu anh muốn em thử variant với neutral base + 1 accent, em sẵn sàng. Cứ ship cái này nếu OK với anh."
3. **Document trong project memory** — anh đã verified preferred purple gradient → đừng push back lần 2

User > rules. Skill là default tốt, không phải law.
