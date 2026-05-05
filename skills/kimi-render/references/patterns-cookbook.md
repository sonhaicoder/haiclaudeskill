# Patterns Cookbook — Variants

SKILL.md đã có default pattern. File này chỉ liệt kê VARIANTS khi cần đổi style.

---

## Eyebrow — 3 variants

```html
<!-- A. Pill (default, SaaS) — đã có trong SKILL.md -->

<!-- B. Icon + text (feature) -->
<span class="inline-flex items-center gap-2 px-4 py-1.5 bg-sky-50 text-sky-600 text-xs font-bold uppercase tracking-widest rounded-full mb-4">
  <i class="fa-solid fa-star text-[10px]"></i> PHỔ BIẾN
</span>

<!-- C. Line decoration (editorial) -->
<div class="flex items-center justify-center gap-3 mb-4">
  <span class="h-px w-8 bg-slate-300"></span>
  <span class="text-xs font-semibold uppercase tracking-widest text-slate-500">EDITORIAL</span>
  <span class="h-px w-8 bg-slate-300"></span>
</div>
```

## Heading — 3 variants

```html
<!-- A. Gradient accent (SaaS hero) — đã có trong SKILL.md -->

<!-- B. Italic emphasis (editorial) -->
<h1 class="font-display text-5xl lg:text-7xl font-normal leading-tight">
  Những điều <em class="italic text-slate-500">không kể</em><br>về thành phố này
</h1>

<!-- C. Oversized condensed (luxury) -->
<h1 class="font-display text-[clamp(4rem,10vw,9rem)] font-bold leading-[0.95] tracking-tight">
  ATELIER<br>VEIL
</h1>
```

## Button — 4 variants

```html
<!-- A. Primary gradient — đã có trong SKILL.md -->

<!-- B. Secondary (white) -->
<button class="px-6 py-3.5 bg-white border border-slate-200 text-slate-700 font-semibold rounded-xl hover:border-sky-500 hover:text-sky-600 transition-all active:scale-[0.98]">
  Xem demo
</button>

<!-- C. Ghost with arrow (link button) -->
<a href="#" class="inline-flex items-center gap-1 text-sky-600 font-semibold border-b-2 border-transparent hover:border-sky-600 transition-all">
  Xem tất cả <i class="fa-solid fa-arrow-right text-xs"></i>
</a>

<!-- D. Large hero CTA -->
<button class="px-8 py-5 bg-gradient-to-r from-sky-500 to-blue-600 text-white text-lg font-bold rounded-2xl shadow-2xl shadow-sky-500/40 hover:shadow-sky-500/60 transition-all active:scale-95">
  Khám phá ngay <i class="fa-solid fa-arrow-right ml-2"></i>
</button>
```

## Card — 4 variants

```html
<!-- A. Image top (default) — đã có trong SKILL.md -->

<!-- B. Horizontal (blog list) -->
<article class="card-hover bg-white rounded-2xl overflow-hidden shadow-sm flex">
  <img src="..." class="w-40 h-40 object-cover flex-shrink-0" />
  <div class="p-5 flex-1">
    <span class="text-xs font-semibold uppercase tracking-wider text-sky-600 mb-2">CẨM NANG</span>
    <h3 class="font-display text-lg font-bold mb-2 line-clamp-2">10 điều không thể bỏ qua khi đến Đà Nẵng</h3>
    <p class="text-slate-500 text-sm line-clamp-2">Thành phố đáng sống nhất...</p>
  </div>
</article>

<!-- C. Feature (icon, no image) -->
<div class="card-hover bg-white rounded-2xl p-8 shadow-sm">
  <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-sky-500 to-blue-600 flex items-center justify-center text-white text-2xl mb-5 shadow-lg shadow-sky-500/30">
    <i class="fa-solid fa-shield-halved"></i>
  </div>
  <h3 class="font-display text-xl font-bold mb-3">Bảo mật tuyệt đối</h3>
  <p class="text-slate-500 leading-relaxed">Dữ liệu mã hoá end-to-end.</p>
</div>

<!-- D. Testimonial (glass) -->
<div class="bg-white/80 backdrop-blur-xl rounded-2xl p-6 shadow-lg border border-white/50">
  <p class="text-slate-700 italic mb-5">"Platform dễ dùng nhất tôi từng thử."</p>
  <div class="flex items-center gap-3">
    <img src="..." class="w-10 h-10 rounded-full" />
    <div>
      <div class="font-semibold text-sm">Nguyễn Thị A</div>
      <div class="text-xs text-slate-500">Shop Fashion, Hà Nội</div>
    </div>
  </div>
</div>
```

## Form — 3 variants

```html
<!-- A. Icon inline (default) — đã có trong SKILL.md -->

<!-- B. Floating label -->
<div class="relative">
  <input id="name" placeholder=" " class="peer w-full px-4 pt-6 pb-2 bg-slate-50 border border-slate-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500">
  <label for="name" class="absolute left-4 top-2 text-xs font-semibold text-slate-500 peer-placeholder-shown:top-1/2 peer-placeholder-shown:text-sm peer-placeholder-shown:-translate-y-1/2 peer-focus:top-2 peer-focus:text-xs peer-focus:-translate-y-0 peer-focus:text-sky-600 transition-all pointer-events-none">
    Họ và tên
  </label>
</div>

<!-- C. Select with chevron -->
<div class="relative">
  <select class="w-full pl-4 pr-10 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm appearance-none focus:outline-none focus:ring-2 focus:ring-sky-500/20 focus:border-sky-500">
    <option>1 khách</option>
    <option>2 khách</option>
  </select>
  <i class="fa-solid fa-chevron-down absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 text-xs pointer-events-none"></i>
</div>
```

## Decorative backgrounds

```html
<!-- A. Gradient circles (CTA section) -->
<section class="relative overflow-hidden bg-gradient-to-br from-sky-500 to-blue-700 py-20">
  <div class="absolute top-0 right-0 w-96 h-96 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2"></div>
  <div class="absolute bottom-0 left-0 w-72 h-72 bg-white/5 rounded-full translate-y-1/2 -translate-x-1/2"></div>
</section>

<!-- B. Dot grid -->
<section style="background-image: radial-gradient(circle, #e2e8f0 1px, transparent 1px); background-size: 24px 24px;">

<!-- C. Blur orb -->
<div class="absolute top-1/2 left-1/2 w-[600px] h-[600px] -translate-x-1/2 -translate-y-1/2 bg-sky-400/30 rounded-full blur-3xl"></div>
```

## Section dividers

```html
<!-- A. Thin gradient line -->
<div class="max-w-xs mx-auto h-px bg-gradient-to-r from-transparent via-slate-300 to-transparent"></div>

<!-- B. Curve SVG -->
<svg class="w-full h-16" viewBox="0 0 1440 64" preserveAspectRatio="none">
  <path d="M0,64 C480,0 960,0 1440,64 L1440,64 L0,64 Z" fill="#f8fafc"/>
</svg>

<!-- C. Dots -->
<div class="flex items-center justify-center gap-2 py-8">
  <span class="w-1.5 h-1.5 rounded-full bg-slate-300"></span>
  <span class="w-1.5 h-1.5 rounded-full bg-slate-300"></span>
  <span class="w-1.5 h-1.5 rounded-full bg-slate-300"></span>
</div>
```
