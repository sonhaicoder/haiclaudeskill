# Hero Patterns — 7 Ready-to-Paste Heroes

> Mỗi pattern là **complete HTML + CSS**, copy-paste ngay được. TailwindCSS class-based, không cần custom config.
> Target: **Kimi-tier hoặc Lovable-tier** quality.

---

## Pattern 1 — Oversized Display (Editorial Premium / Kimi-tier)

**Best for:** Editorial site, AI tool landing, content magazine.
**Vibe:** Confident, quietly intelligent. Display dominates, image secondary.

```html
<section class="relative overflow-hidden bg-[#fafaf7] px-6 py-32 md:py-40">
  <!-- Ambient gradient blob (Kimi signature) -->
  <div class="pointer-events-none absolute inset-0 -z-10 opacity-[0.04]">
    <div class="absolute left-1/4 top-1/3 h-[600px] w-[600px] rounded-full bg-gradient-to-br from-orange-500 via-pink-500 to-rose-500 blur-3xl animate-pulse-slow"></div>
  </div>

  <div class="mx-auto max-w-5xl">
    <!-- Eyebrow -->
    <p class="mb-8 font-mono text-[11px] uppercase tracking-[0.2em] text-neutral-500">
      — VOL 03 / 2026
    </p>

    <!-- Display headline (clamp scaling) -->
    <h1 class="font-serif font-medium leading-[0.95] tracking-tight text-neutral-900"
        style="font-size: clamp(56px, 9vw, 144px);">
      Design without<br>
      <em class="italic font-normal text-neutral-500">apology.</em>
    </h1>

    <!-- Lede -->
    <p class="mt-12 max-w-2xl text-xl leading-relaxed text-neutral-600">
      A working space for ideas that haven't been compromised by committees,
      KPIs, or "what works." Read essays, see work, hire studios.
    </p>

    <!-- Subtle CTA pair -->
    <div class="mt-16 flex flex-wrap items-center gap-x-8 gap-y-4">
      <a href="#" class="group inline-flex items-center gap-2 text-base font-medium text-neutral-900 underline decoration-1 underline-offset-[6px] hover:decoration-2">
        Start reading
        <span class="transition-transform group-hover:translate-x-0.5">→</span>
      </a>
      <a href="#" class="text-base text-neutral-500 hover:text-neutral-900">
        About this project
      </a>
    </div>

    <!-- Footer meta -->
    <div class="mt-32 flex items-center justify-between border-t border-neutral-200 pt-6 font-mono text-xs text-neutral-500">
      <span>Issue 03 — Spring 2026</span>
      <span>12 essays / 4 interviews</span>
    </div>
  </div>
</section>

<style>
  @keyframes pulse-slow {
    0%, 100% { transform: scale(1) rotate(0deg); }
    50% { transform: scale(1.1) rotate(180deg); }
  }
  .animate-pulse-slow { animation: pulse-slow 24s ease-in-out infinite; }
</style>
```

**Why Kimi-tier:** clamp display, italic emphasis, mono eyebrow, ambient pulse, underline link decoration với offset, generous py-32+ padding, single accent (rose) used subtly in pulse only.

---

## Pattern 2 — Bento Hero (Lovable-tier)

**Best for:** AI builder, dev tool, product launch.
**Vibe:** Energy + density, "watch it come to life" feel.

```html
<section class="bg-[#0a0a0a] px-6 py-24 md:py-32">
  <div class="mx-auto max-w-7xl">
    <!-- Hero text top -->
    <div class="mx-auto mb-16 max-w-3xl text-center">
      <span class="mb-6 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-4 py-1.5 text-xs font-medium text-white/80 backdrop-blur">
        <span class="size-1.5 rounded-full bg-emerald-400 animate-pulse"></span>
        2.6 just shipped — try it free
      </span>

      <h1 class="bg-gradient-to-b from-white to-white/70 bg-clip-text text-transparent font-bold leading-[1.05] tracking-tight"
          style="font-size: clamp(48px, 7vw, 96px);">
        Build something<br>
        <em class="not-italic bg-gradient-to-r from-violet-400 to-fuchsia-400 bg-clip-text text-transparent">
          impossible
        </em>
      </h1>

      <p class="mx-auto mt-8 max-w-xl text-lg leading-relaxed text-white/60">
        Type a sentence. Watch a real, deployable app appear.
        From idea to production in minutes, not months.
      </p>
    </div>

    <!-- Bento grid (6-tile asymmetric) -->
    <div class="grid grid-cols-12 gap-4 md:gap-6">
      <!-- Tile 1: Large feature (4-col, span 2 rows) -->
      <div class="col-span-12 row-span-2 rounded-3xl border border-white/10 bg-gradient-to-br from-violet-500/20 to-transparent p-8 md:col-span-6 md:p-10">
        <div class="mb-6 inline-flex size-12 items-center justify-center rounded-2xl bg-white/10 backdrop-blur">
          <svg class="size-6 text-violet-300" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9.813 15.904 9 18.75l-.813-2.846a4.5 4.5 0 0 0-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 0 0 3.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 0 0 3.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 0 0-3.09 3.09Z"/></svg>
        </div>
        <h3 class="mb-3 text-2xl font-semibold text-white">Real apps from real prompts</h3>
        <p class="text-base leading-relaxed text-white/60">
          No mockups. The output is a working React app deployed to Vercel
          with auth, DB, and a real domain.
        </p>
        <!-- Mock product preview -->
        <div class="mt-8 aspect-[16/10] overflow-hidden rounded-2xl border border-white/10 bg-neutral-900">
          <img src="https://picsum.photos/seed/lovable-hero/800/500" alt="" class="size-full object-cover opacity-80"/>
        </div>
      </div>

      <!-- Tile 2: Stat (3-col) -->
      <div class="col-span-6 rounded-3xl border border-white/10 bg-white/[0.03] p-8 md:col-span-3">
        <div class="font-mono text-5xl font-bold text-white tabular-nums">847k</div>
        <div class="mt-2 text-sm text-white/50">apps shipped this month</div>
      </div>

      <!-- Tile 3: Quote (3-col) -->
      <div class="col-span-6 rounded-3xl border border-white/10 bg-gradient-to-br from-emerald-500/10 to-transparent p-8 md:col-span-3">
        <p class="text-sm leading-relaxed text-white/80">
          "Replaced two contractors and a Figma designer in one weekend."
        </p>
        <div class="mt-6 flex items-center gap-3">
          <img src="https://picsum.photos/seed/avatar1/40/40" class="size-8 rounded-full" alt=""/>
          <div class="text-xs">
            <div class="font-medium text-white/90">Maya Gokhan</div>
            <div class="text-white/50">Founder, Brewlab</div>
          </div>
        </div>
      </div>

      <!-- Tile 4: Live demo (4-col) -->
      <div class="col-span-12 rounded-3xl border border-white/10 bg-white/[0.03] p-8 md:col-span-4">
        <div class="mb-4 flex items-center gap-2 text-xs text-white/50">
          <span class="size-1.5 rounded-full bg-red-500"></span>
          <span class="size-1.5 rounded-full bg-yellow-500"></span>
          <span class="size-1.5 rounded-full bg-green-500"></span>
          <span class="ml-2 font-mono">prompt.txt</span>
        </div>
        <code class="block font-mono text-sm leading-relaxed text-white/80">
          "Build a marketplace<br>for vintage cameras with<br>seller verification"
        </code>
        <button class="mt-6 w-full rounded-xl bg-gradient-to-r from-violet-500 to-fuchsia-500 px-4 py-2.5 text-sm font-medium text-white hover:from-violet-400 hover:to-fuchsia-400">
          Run prompt
        </button>
      </div>

      <!-- Tile 5: Feature pill list (4-col) -->
      <div class="col-span-12 rounded-3xl border border-white/10 bg-white/[0.03] p-8 md:col-span-4">
        <h4 class="mb-4 text-sm font-medium text-white/90">Stack ready out of box</h4>
        <div class="flex flex-wrap gap-2">
          <span class="rounded-full bg-white/5 px-3 py-1 text-xs text-white/70">Next.js</span>
          <span class="rounded-full bg-white/5 px-3 py-1 text-xs text-white/70">TypeScript</span>
          <span class="rounded-full bg-white/5 px-3 py-1 text-xs text-white/70">Tailwind</span>
          <span class="rounded-full bg-white/5 px-3 py-1 text-xs text-white/70">Supabase</span>
          <span class="rounded-full bg-white/5 px-3 py-1 text-xs text-white/70">Stripe</span>
          <span class="rounded-full bg-white/5 px-3 py-1 text-xs text-white/70">Resend</span>
        </div>
      </div>

      <!-- Tile 6: Visual flourish (4-col) -->
      <div class="col-span-12 relative overflow-hidden rounded-3xl border border-white/10 bg-gradient-to-br from-fuchsia-500/20 via-violet-500/10 to-transparent p-8 md:col-span-4">
        <h4 class="mb-3 text-lg font-semibold text-white">Deployed in 47s</h4>
        <p class="text-sm text-white/60">From prompt to live URL on the auto-allocated subdomain.</p>
      </div>
    </div>
  </div>
</section>
```

**Why Lovable-tier:** Bento 6-tile asymmetric, gradient text emphasis, real product preview tile, stat tile prominent, quote with avatar, live demo mock, deploy time callout. Animated pulse on status dot. Dark theme native.

---

## Pattern 3 — Asymmetric Split (Modern Minimal / Lovable-tier)

**Best for:** SaaS landing, dev tool, productivity app.
**Vibe:** Functional, content-led, no decoration.

```html
<section class="border-b border-neutral-200 bg-white px-6 py-24 md:py-32">
  <div class="mx-auto grid max-w-7xl grid-cols-12 gap-8 md:gap-16">
    <!-- Left: Text 7-col -->
    <div class="col-span-12 md:col-span-7">
      <span class="mb-6 inline-flex items-center gap-2 rounded-full border border-neutral-200 bg-neutral-50 px-3 py-1 text-xs font-medium text-neutral-700">
        <span class="size-1.5 rounded-full bg-emerald-500"></span>
        Now in public beta
      </span>

      <h1 class="text-5xl font-semibold leading-[1.05] tracking-tight text-neutral-900 md:text-7xl">
        Cut the time you spend on bookkeeping by <span class="text-emerald-600">87%</span>.
      </h1>

      <p class="mt-8 max-w-xl text-lg leading-relaxed text-neutral-600">
        Receipt → categorized expense in 0.4s. No CSV imports.
        No spreadsheet exports. No Tuesdays lost to "doing the books."
      </p>

      <!-- Email capture -->
      <form class="mt-10 flex max-w-md gap-3">
        <input type="email" placeholder="you@company.com"
               class="flex-1 rounded-xl border border-neutral-300 bg-white px-4 py-3 text-base placeholder:text-neutral-400 focus:border-neutral-900 focus:outline-none focus:ring-2 focus:ring-neutral-900/10"/>
        <button class="rounded-xl bg-neutral-900 px-6 py-3 text-base font-medium text-white hover:bg-neutral-800 active:scale-[0.98]">
          Get early access
        </button>
      </form>

      <p class="mt-4 text-sm text-neutral-500">
        Free for the first 47 teams. No card. No spam.
      </p>

      <!-- Logo strip -->
      <div class="mt-16">
        <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-400">
          Trusted by founders at
        </p>
        <div class="flex flex-wrap items-center gap-x-8 gap-y-4 opacity-60">
          <span class="text-base font-semibold text-neutral-700">Brewlab</span>
          <span class="text-base font-semibold text-neutral-700">Northwind</span>
          <span class="text-base font-semibold text-neutral-700">Atelier 47</span>
          <span class="text-base font-semibold text-neutral-700">Folder</span>
          <span class="text-base font-semibold text-neutral-700">Linhden</span>
        </div>
      </div>
    </div>

    <!-- Right: Product visual 5-col -->
    <div class="col-span-12 md:col-span-5">
      <div class="aspect-[4/5] overflow-hidden rounded-2xl border border-neutral-200 bg-gradient-to-b from-neutral-50 to-white">
        <img src="https://picsum.photos/seed/saas-product/600/750" alt=""
             class="size-full object-cover"/>
      </div>

      <!-- Floating data callouts -->
      <div class="relative -mt-12 ml-4 max-w-xs rounded-2xl border border-neutral-200 bg-white p-4 shadow-sm">
        <div class="text-xs text-neutral-500">Last receipt processed</div>
        <div class="mt-1 font-mono text-2xl font-semibold tabular-nums text-neutral-900">0.3s</div>
        <div class="mt-2 flex items-center gap-2 text-xs text-emerald-600">
          <span class="size-1.5 rounded-full bg-emerald-500"></span>
          Categorized as Travel · Meals
        </div>
      </div>
    </div>
  </div>
</section>
```

**Why Lovable-tier:** specific number (87%), asymmetric split 7/5, email capture inline (no separate page), real logos (no Acme), product image với floating data callout, mono numerics tabular, single accent (emerald) used 3x meaningful.

---

## Pattern 4 — Cinematic Dark Hero (Brand mode)

**Best for:** Premium product, agency portfolio, fintech.
**Vibe:** Luxury, restrained, intentional.

```html
<section class="relative min-h-[100dvh] bg-[#080808] px-6 py-24">
  <!-- Cinematic image overlay -->
  <div class="absolute inset-0 -z-10">
    <img src="https://picsum.photos/seed/cinematic/1920/1080" alt=""
         class="size-full object-cover opacity-40"/>
    <div class="absolute inset-0 bg-gradient-to-b from-transparent via-[#080808]/60 to-[#080808]"></div>
  </div>

  <!-- Top nav floats -->
  <nav class="mx-auto flex max-w-7xl items-center justify-between">
    <span class="text-base font-semibold tracking-tight text-white">ATELIER<sup class="text-xs text-white/40">47</sup></span>
    <div class="flex items-center gap-8 text-sm text-white/70">
      <a href="#" class="hover:text-white">Work</a>
      <a href="#" class="hover:text-white">Studio</a>
      <a href="#" class="hover:text-white">Journal</a>
      <a href="#" class="rounded-full border border-white/20 px-4 py-1.5 hover:bg-white/5">Contact</a>
    </div>
  </nav>

  <!-- Hero content (bottom-aligned, asymmetric) -->
  <div class="mx-auto mt-32 grid max-w-7xl grid-cols-12 gap-8 md:mt-48">
    <div class="col-span-12 md:col-span-9">
      <p class="mb-8 font-mono text-[11px] uppercase tracking-[0.25em] text-white/50">
        — Independent design studio · est. 2019
      </p>
      <h1 class="font-serif font-light leading-[0.95] tracking-tight text-white"
          style="font-size: clamp(56px, 9vw, 132px);">
        We make brands<br>
        worth <em class="italic text-white/70">remembering.</em>
      </h1>
    </div>

    <div class="col-span-12 md:col-span-3 md:flex md:items-end">
      <p class="text-sm leading-relaxed text-white/70">
        Identity, packaging, digital. For fintech, fashion, F&amp;B, and the occasional restaurant.
      </p>
    </div>
  </div>

  <!-- Bottom meta strip -->
  <div class="absolute bottom-8 left-6 right-6 mx-auto max-w-7xl">
    <div class="flex items-center justify-between border-t border-white/10 pt-4 font-mono text-xs text-white/50">
      <span>Selected works 2019—2026</span>
      <span class="flex items-center gap-2">
        Currently booking Q3 2026
        <span class="size-1.5 rounded-full bg-emerald-400"></span>
      </span>
    </div>
  </div>
</section>
```

**Why brand-mode-tier:** Min-h-100dvh full screen, cinematic image với gradient mask, italic emphasis, asymmetric 9/3 split, mono eyebrow + meta strip, status dot booking, font-serif font-light (premium luxury weight).

---

## Pattern 5 — Animated Gradient Pulse (AI tool / Kimi-tier)

**Best for:** AI tool, ML platform, developer SDK landing.
**Vibe:** Energy + intellect.

```html
<section class="relative overflow-hidden bg-[#0a0a0a] px-6 py-32">
  <!-- Multi-layer animated pulse -->
  <div class="pointer-events-none absolute inset-0">
    <!-- Layer 1: Slow violet blob -->
    <div class="absolute left-1/4 top-1/4 h-[700px] w-[700px] rounded-full bg-violet-600/20 blur-[120px] animate-blob-slow"></div>
    <!-- Layer 2: Counter-rotating cyan -->
    <div class="absolute right-1/4 bottom-1/4 h-[600px] w-[600px] rounded-full bg-cyan-500/15 blur-[100px] animate-blob-medium"></div>
    <!-- Layer 3: Subtle grain texture -->
    <div class="absolute inset-0 opacity-[0.015]" style="background-image: url('data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22><filter id=%22n%22><feTurbulence type=%22fractalNoise%22 baseFrequency=%221.5%22/></filter><rect width=%22100%25%22 height=%22100%25%22 filter=%22url(%23n)%22/></svg>');"></div>
  </div>

  <div class="relative mx-auto max-w-5xl text-center">
    <span class="mb-8 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/[0.03] px-4 py-1.5 backdrop-blur-xl">
      <span class="font-mono text-xs text-white/70">v2.6 · 14ms p50 latency</span>
    </span>

    <h1 class="bg-gradient-to-b from-white via-white to-white/40 bg-clip-text text-transparent font-semibold leading-[0.95] tracking-tighter"
        style="font-size: clamp(56px, 9vw, 128px);">
      The fastest LLM<br>
      that doesn't <em class="italic font-light">cheat.</em>
    </h1>

    <p class="mx-auto mt-10 max-w-2xl text-lg leading-relaxed text-white/60">
      32B parameters. Open weights. Beats GPT-4 on 7 of 9 reasoning benchmarks
      while running locally on a 4090.
    </p>

    <!-- Inline prompt input (the "hero CTA") -->
    <div class="mx-auto mt-12 max-w-2xl">
      <div class="rounded-2xl border border-white/10 bg-white/[0.03] backdrop-blur-xl">
        <div class="flex items-center gap-3 px-5 py-4">
          <span class="font-mono text-xs text-white/40">$</span>
          <input type="text" placeholder="Ask anything — try 'explain attention to a 5yr old'"
                 class="flex-1 bg-transparent text-base text-white placeholder:text-white/30 focus:outline-none"/>
          <button class="rounded-xl bg-white px-4 py-2 text-sm font-medium text-neutral-900 hover:bg-white/90">
            Run →
          </button>
        </div>
        <div class="border-t border-white/5 px-5 py-3 text-xs text-white/40">
          Ctrl+K to focus · Esc to cancel · Free up to 1k tokens/day
        </div>
      </div>
    </div>

    <!-- Benchmark strip -->
    <div class="mt-20 grid grid-cols-3 gap-8 md:grid-cols-5">
      <div class="text-center">
        <div class="font-mono text-3xl font-semibold tabular-nums text-white">87.3</div>
        <div class="mt-1 text-xs uppercase tracking-wider text-white/50">MMLU</div>
      </div>
      <div class="text-center">
        <div class="font-mono text-3xl font-semibold tabular-nums text-white">94.1</div>
        <div class="mt-1 text-xs uppercase tracking-wider text-white/50">HumanEval</div>
      </div>
      <div class="text-center">
        <div class="font-mono text-3xl font-semibold tabular-nums text-white">14ms</div>
        <div class="mt-1 text-xs uppercase tracking-wider text-white/50">P50 latency</div>
      </div>
      <div class="text-center">
        <div class="font-mono text-3xl font-semibold tabular-nums text-white">32B</div>
        <div class="mt-1 text-xs uppercase tracking-wider text-white/50">Params</div>
      </div>
      <div class="text-center">
        <div class="font-mono text-3xl font-semibold tabular-nums text-white">$0</div>
        <div class="mt-1 text-xs uppercase tracking-wider text-white/50">Open weights</div>
      </div>
    </div>
  </div>
</section>

<style>
  @keyframes blob-slow {
    0%, 100% { transform: translate(0,0) scale(1); }
    33% { transform: translate(60px,-40px) scale(1.1); }
    66% { transform: translate(-30px,40px) scale(0.95); }
  }
  @keyframes blob-medium {
    0%, 100% { transform: translate(0,0) scale(1); }
    50% { transform: translate(-50px,30px) scale(1.15); }
  }
  .animate-blob-slow { animation: blob-slow 25s ease-in-out infinite; }
  .animate-blob-medium { animation: blob-medium 18s ease-in-out infinite; }
</style>
```

**Why Kimi-tier:** Multi-layer ambient pulse, grain texture overlay, inline prompt input là focal point (như Kimi/ChatGPT), benchmark strip với mono tabular nums, italic emphasis "cheat", v2.6 + latency badge concrete, gradient text màu trắng-fade-trắng (premium signature).

---

## Pattern 6 — Magazine Editorial (Monocle-tier)

**Best for:** Long-form essay, content site, journalism.

```html
<article class="bg-[#f7f3ed] px-6 py-32">
  <div class="mx-auto max-w-4xl">
    <!-- Eyebrow + meta -->
    <div class="mb-8 flex items-center justify-between">
      <span class="font-mono text-[11px] uppercase tracking-[0.25em] text-[#b04832]">
        — ESSAY · ISSUE 47
      </span>
      <span class="font-mono text-xs text-neutral-500">12 min read</span>
    </div>

    <!-- Display headline serif -->
    <h1 class="font-serif font-medium leading-[1.05] tracking-tight text-neutral-900"
        style="font-size: clamp(48px, 7vw, 88px);">
      The slow death of design<br>
      <em class="italic text-neutral-600">— and what comes after.</em>
    </h1>

    <!-- Byline -->
    <div class="mt-10 flex items-center gap-4 border-y border-neutral-300 py-4">
      <img src="https://picsum.photos/seed/author47/48/48" class="size-10 rounded-full" alt=""/>
      <div class="text-sm">
        <div class="font-medium text-neutral-900">By Linh Nguyễn</div>
        <div class="text-neutral-500">Editor-at-large · 2026-04-14</div>
      </div>
      <div class="ml-auto flex gap-3 text-neutral-500">
        <button class="hover:text-neutral-900">↗</button>
        <button class="hover:text-neutral-900">⌘</button>
      </div>
    </div>

    <!-- Hero image (cropped at bottom) -->
    <figure class="mt-16">
      <img src="https://picsum.photos/seed/editorial/1200/700"
           alt=""
           class="aspect-[16/9] w-full object-cover"/>
      <figcaption class="mt-3 text-sm italic text-neutral-500">
        A dropped Letraset sheet, 1972. Photo from the Cooper Hewitt archives.
      </figcaption>
    </figure>

    <!-- Lede paragraph (drop cap) -->
    <p class="mt-16 text-xl leading-[1.7] text-neutral-800 first-letter:float-left first-letter:mr-3 first-letter:font-serif first-letter:text-7xl first-letter:font-medium first-letter:leading-[0.85] first-letter:text-[#b04832]">
      The first thing you notice walking into Pentagram's London office is how
      quiet it is. Not silent — there's the low hum of trackpads, an occasional
      laser printer — but quiet in the way a library is quiet. Twenty years ago
      you would have heard the slap of cardboard against light tables.
    </p>
  </div>
</article>
```

**Why Monocle-tier:** Eyebrow `tracking-[0.25em]`, serif display với italic emphasis, byline trong border-y, image cropped 16:9 với italic caption, drop cap first-letter (magazine signature), accent rust used 2x (eyebrow + drop cap), `leading-[1.7]` body super generous.

---

## Pattern 7 — Dual-Tone Split (Brand storytelling)

**Best for:** Brand site, manifesto, premium product.

```html
<section class="grid min-h-[100dvh] grid-cols-1 md:grid-cols-2">
  <!-- Left: Light side -->
  <div class="flex flex-col justify-between bg-[#fafaf7] p-12 md:p-20">
    <span class="font-mono text-xs uppercase tracking-[0.2em] text-neutral-500">
      Yesterday
    </span>

    <div>
      <h2 class="font-serif font-medium leading-[0.95] tracking-tight text-neutral-900"
          style="font-size: clamp(48px, 6vw, 88px);">
        Spreadsheets,<br>
        Slack threads,<br>
        <em class="italic text-neutral-500">guesswork.</em>
      </h2>
      <p class="mt-8 max-w-md text-base leading-relaxed text-neutral-600">
        Five tools. Three Tuesdays per month spent reconciling. Numbers
        nobody trusted because nobody could trace them.
      </p>
    </div>

    <div class="font-mono text-xs text-neutral-400">2019—2024</div>
  </div>

  <!-- Right: Dark side -->
  <div class="relative flex flex-col justify-between bg-[#080808] p-12 md:p-20">
    <span class="font-mono text-xs uppercase tracking-[0.2em] text-emerald-400">
      Today
    </span>

    <div>
      <h2 class="bg-gradient-to-b from-white to-white/60 bg-clip-text text-transparent font-medium leading-[0.95] tracking-tight"
          style="font-size: clamp(48px, 6vw, 88px);">
        One source<br>
        of <em class="italic">truth.</em>
      </h2>
      <p class="mt-8 max-w-md text-base leading-relaxed text-white/60">
        Replace 5 tools with 1. Numbers update in 0.3s. Audit trail
        on every row. Trust restored.
      </p>
      <a href="#" class="mt-10 inline-flex items-center gap-2 rounded-full bg-white px-6 py-3 text-sm font-medium text-neutral-900 hover:bg-white/90">
        See it in 90 seconds
        <span>→</span>
      </a>
    </div>

    <div class="font-mono text-xs text-emerald-400">2026 →</div>
  </div>
</section>
```

**Why brand-tier:** 50/50 split storytelling, italic emphasis 2 sides ("guesswork" / "truth"), color contrast (light vs dark), specific tools count "5 → 1", "0.3s" specific, mono date markers, gradient text on dark, status color emerald only on right side.

---

## Hero Selection Heuristic

```
brief có "AI tool / SDK / LLM"            → Pattern 5 (animated pulse)
brief có "AI builder / app gen"           → Pattern 2 (bento)
brief có "SaaS / dev-tool / productivity" → Pattern 3 (asymmetric split)
brief có "agency / portfolio / luxury"    → Pattern 4 (cinematic dark)
brief có "magazine / editorial / essay"   → Pattern 6 (drop cap)
brief có "brand / manifesto / story"      → Pattern 7 (dual-tone split)
default editorial                          → Pattern 1 (oversized display)
```

---

## Common Hero Anti-Patterns (REVIEW after building)

```
□ Hero không có < 480px display size (< text-5xl) → BUMP UP
□ Hero text centered trên dark image generic → SWAP to asymmetric
□ 3 CTAs equal weight → DEMOTE 2 to ghost/text-link
□ "Welcome to..." / "Hello" generic copy → REPLACE with specific verb
□ Stock photo trong hero → REPLACE with product/screenshot/seed Picsum
□ No animated element → ADD subtle pulse/gradient/status dot
□ No status indicator (online/beta/launching) → ADD if relevant
□ No specific number/metric → ADD if claim made
```

**If any ✗ → fix before moving to next section.**
