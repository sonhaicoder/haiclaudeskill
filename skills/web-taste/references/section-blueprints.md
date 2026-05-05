# Section Blueprints — Ready-to-Paste

> 10 section patterns mạnh nhất cho landing/marketing site. Copy-paste TailwindCSS class-based.
> Target Kimi/Lovable-tier.

---

## 1. Bento Feature Grid (6-tile asymmetric)

**Use case:** Feature showcase thay cho 3-column equal cards generic.

```html
<section class="bg-white px-6 py-24 md:py-32">
  <div class="mx-auto max-w-7xl">
    <div class="mb-16 max-w-2xl">
      <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">— Capabilities</p>
      <h2 class="text-4xl font-semibold leading-tight tracking-tight text-neutral-900 md:text-5xl">
        Built for the way real teams ship work.
      </h2>
    </div>

    <div class="grid grid-cols-12 gap-4 md:gap-6">
      <!-- Tile A: Large feature span 7-col + 2-row -->
      <div class="col-span-12 row-span-2 rounded-3xl bg-gradient-to-br from-neutral-900 to-neutral-800 p-10 text-white md:col-span-7">
        <div class="mb-8 inline-flex size-12 items-center justify-center rounded-2xl bg-white/10 backdrop-blur">
          <svg class="size-6" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3.75 13.5l10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75z"/></svg>
        </div>
        <h3 class="mb-4 text-3xl font-semibold tracking-tight">Real-time everything.</h3>
        <p class="max-w-md text-base leading-relaxed text-white/70">
          Updates propagate in 47ms across all clients. No "refresh to see"
          dialogs. No "loading spinners" after every action.
        </p>
        <div class="mt-12 aspect-video overflow-hidden rounded-2xl border border-white/10">
          <img src="https://picsum.photos/seed/feature1/800/450" alt="" class="size-full object-cover opacity-90"/>
        </div>
      </div>

      <!-- Tile B: 5-col -->
      <div class="col-span-12 rounded-3xl border border-neutral-200 bg-white p-8 md:col-span-5">
        <h3 class="mb-3 text-xl font-semibold text-neutral-900">Audit trail by default</h3>
        <p class="text-sm leading-relaxed text-neutral-600">
          Every row carries who-did-what-when. No add-on. No SOC2 surcharge.
        </p>
        <div class="mt-6 space-y-2 font-mono text-xs">
          <div class="flex justify-between text-neutral-500">
            <span>linh@brewlab updated price</span>
            <span>2m ago</span>
          </div>
          <div class="flex justify-between text-neutral-500">
            <span>maya@brewlab archived SKU</span>
            <span>14m ago</span>
          </div>
          <div class="flex justify-between text-neutral-500">
            <span>system: backup completed</span>
            <span>1h ago</span>
          </div>
        </div>
      </div>

      <!-- Tile C: 5-col with stat -->
      <div class="col-span-12 rounded-3xl bg-neutral-100 p-8 md:col-span-5">
        <div class="font-mono text-6xl font-semibold tabular-nums text-neutral-900">99.97<span class="text-2xl text-neutral-400">%</span></div>
        <div class="mt-2 text-sm text-neutral-600">verified uptime over the last 90 days.</div>
        <a href="#" class="mt-6 inline-flex items-center gap-1 text-sm font-medium text-neutral-900 underline decoration-1 underline-offset-4">
          See status page <span>↗</span>
        </a>
      </div>

      <!-- Tile D: 4-col emoji-free icon -->
      <div class="col-span-6 rounded-3xl border border-neutral-200 bg-white p-8 md:col-span-4">
        <div class="mb-6 inline-flex size-10 items-center justify-center rounded-xl bg-emerald-50 text-emerald-700">
          <svg class="size-5" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
        </div>
        <h3 class="mb-2 text-base font-semibold text-neutral-900">SOC2 Type II</h3>
        <p class="text-sm text-neutral-600">Audited annually since 2023.</p>
      </div>

      <!-- Tile E: 4-col -->
      <div class="col-span-6 rounded-3xl border border-neutral-200 bg-white p-8 md:col-span-4">
        <div class="mb-6 inline-flex size-10 items-center justify-center rounded-xl bg-violet-50 text-violet-700">
          <svg class="size-5" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M3 7.5L7.5 3m0 0L12 7.5M7.5 3v13.5m13.5 0L16.5 21m0 0L12 16.5m4.5 4.5V7.5"/></svg>
        </div>
        <h3 class="mb-2 text-base font-semibold text-neutral-900">CSV / API / Webhooks</h3>
        <p class="text-sm text-neutral-600">Move data in / out without engineering.</p>
      </div>

      <!-- Tile F: 4-col -->
      <div class="col-span-12 rounded-3xl border border-neutral-200 bg-white p-8 md:col-span-4">
        <div class="mb-6 inline-flex size-10 items-center justify-center rounded-xl bg-orange-50 text-orange-700">
          <svg class="size-5" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M9.75 3.104a18.66 18.66 0 015.487 0..."/></svg>
        </div>
        <h3 class="mb-2 text-base font-semibold text-neutral-900">EU + US data residency</h3>
        <p class="text-sm text-neutral-600">Pick at signup. Free to switch.</p>
      </div>
    </div>
  </div>
</section>
```

---

## 2. Asymmetric Feature Row (Zig-Zag)

**Use case:** 3-4 feature alternating, replace generic 3-col equal.

```html
<section class="space-y-32 bg-[#fafafa] px-6 py-24 md:py-32">
  <!-- Feature 1: Image left, text right -->
  <div class="mx-auto grid max-w-7xl grid-cols-12 items-center gap-8 md:gap-16">
    <div class="col-span-12 md:col-span-7">
      <div class="aspect-[4/3] overflow-hidden rounded-3xl border border-neutral-200 bg-white">
        <img src="https://picsum.photos/seed/zig1/800/600" alt="" class="size-full object-cover"/>
      </div>
    </div>
    <div class="col-span-12 md:col-span-5">
      <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">— 01 / Inbox</p>
      <h3 class="mb-6 text-3xl font-semibold leading-tight tracking-tight text-neutral-900 md:text-4xl">
        One inbox.<br>Every channel.
      </h3>
      <p class="text-base leading-relaxed text-neutral-600">
        Email, in-app chat, X, Discord — they land in the same triage queue
        with the same keyboard shortcuts. Reply once, archive everywhere.
      </p>
      <a href="#" class="mt-6 inline-flex items-center gap-2 text-sm font-medium text-neutral-900 underline decoration-1 underline-offset-4">
        How triage works <span>→</span>
      </a>
    </div>
  </div>

  <!-- Feature 2: Text left, image right -->
  <div class="mx-auto grid max-w-7xl grid-cols-12 items-center gap-8 md:gap-16">
    <div class="col-span-12 md:col-span-5 md:order-1">
      <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">— 02 / Macros</p>
      <h3 class="mb-6 text-3xl font-semibold leading-tight tracking-tight text-neutral-900 md:text-4xl">
        Templates that<br>actually adapt.
      </h3>
      <p class="text-base leading-relaxed text-neutral-600">
        Macros recognise the customer's plan, last ticket, and tone before
        suggesting the reply. You edit one line, not five paragraphs.
      </p>
    </div>
    <div class="col-span-12 md:col-span-7 md:order-2">
      <div class="aspect-[4/3] overflow-hidden rounded-3xl border border-neutral-200 bg-white">
        <img src="https://picsum.photos/seed/zig2/800/600" alt="" class="size-full object-cover"/>
      </div>
    </div>
  </div>

  <!-- Feature 3 -->
  <div class="mx-auto grid max-w-7xl grid-cols-12 items-center gap-8 md:gap-16">
    <div class="col-span-12 md:col-span-7">
      <div class="aspect-[4/3] overflow-hidden rounded-3xl border border-neutral-200 bg-white">
        <img src="https://picsum.photos/seed/zig3/800/600" alt="" class="size-full object-cover"/>
      </div>
    </div>
    <div class="col-span-12 md:col-span-5">
      <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">— 03 / Reports</p>
      <h3 class="mb-6 text-3xl font-semibold leading-tight tracking-tight text-neutral-900 md:text-4xl">
        Reports without<br>"reporting day."
      </h3>
      <p class="text-base leading-relaxed text-neutral-600">
        Slack-ready summaries every Monday at 9am. Customizable weekly digest
        for execs. CSV export for the audit trail nobody asked for.
      </p>
    </div>
  </div>
</section>
```

---

## 3. Pricing Tier (3-tier với "popular" highlight)

```html
<section class="bg-white px-6 py-24 md:py-32">
  <div class="mx-auto max-w-7xl">
    <div class="mx-auto mb-20 max-w-2xl text-center">
      <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">— Pricing</p>
      <h2 class="text-4xl font-semibold leading-tight tracking-tight text-neutral-900 md:text-5xl">
        Pay only when<br>your team grows.
      </h2>
      <p class="mx-auto mt-6 max-w-md text-base leading-relaxed text-neutral-600">
        No seat counting. No "contact sales" pricing. Cancel from settings,
        not from a four-step retention flow.
      </p>
    </div>

    <div class="mx-auto grid max-w-5xl grid-cols-1 gap-6 md:grid-cols-3">
      <!-- Tier 1 -->
      <div class="rounded-3xl border border-neutral-200 bg-white p-8">
        <h3 class="text-lg font-semibold text-neutral-900">Free</h3>
        <p class="mt-2 text-sm text-neutral-600">For trying it out solo.</p>
        <div class="mt-8 flex items-baseline gap-1">
          <span class="font-mono text-5xl font-semibold tabular-nums text-neutral-900">$0</span>
          <span class="text-sm text-neutral-500">/forever</span>
        </div>
        <button class="mt-8 w-full rounded-xl border border-neutral-300 bg-white px-4 py-3 text-sm font-medium text-neutral-900 hover:bg-neutral-50">
          Start free
        </button>
        <ul class="mt-8 space-y-3 text-sm text-neutral-600">
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>Up to 3 projects</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>1 team member</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>Community support</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>30-day data retention</li>
        </ul>
      </div>

      <!-- Tier 2: Popular (highlighted) -->
      <div class="relative rounded-3xl bg-neutral-900 p-8 text-white">
        <span class="absolute -top-3 left-1/2 -translate-x-1/2 rounded-full bg-emerald-500 px-3 py-1 font-mono text-[10px] uppercase tracking-widest text-white">
          Most teams
        </span>
        <h3 class="text-lg font-semibold">Pro</h3>
        <p class="mt-2 text-sm text-white/70">For small teams shipping fast.</p>
        <div class="mt-8 flex items-baseline gap-1">
          <span class="font-mono text-5xl font-semibold tabular-nums">$24</span>
          <span class="text-sm text-white/60">/month flat</span>
        </div>
        <button class="mt-8 w-full rounded-xl bg-white px-4 py-3 text-sm font-medium text-neutral-900 hover:bg-white/90">
          Start 14-day trial
        </button>
        <ul class="mt-8 space-y-3 text-sm text-white/80">
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-emerald-400"></span>Unlimited projects</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-emerald-400"></span>Up to 10 team members</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-emerald-400"></span>Priority email support (4h SLA)</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-emerald-400"></span>1-year data retention</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-emerald-400"></span>Audit log + SSO</li>
        </ul>
      </div>

      <!-- Tier 3 -->
      <div class="rounded-3xl border border-neutral-200 bg-white p-8">
        <h3 class="text-lg font-semibold text-neutral-900">Business</h3>
        <p class="mt-2 text-sm text-neutral-600">For teams that need agreements.</p>
        <div class="mt-8 flex items-baseline gap-1">
          <span class="font-mono text-3xl font-semibold tabular-nums text-neutral-900">From $4/seat</span>
        </div>
        <button class="mt-8 w-full rounded-xl border border-neutral-300 bg-white px-4 py-3 text-sm font-medium text-neutral-900 hover:bg-neutral-50">
          Talk to sales
        </button>
        <ul class="mt-8 space-y-3 text-sm text-neutral-600">
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>Everything in Pro</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>Unlimited team members</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>Dedicated CSM</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>Custom DPA + MSA</li>
          <li class="flex items-start gap-3"><span class="mt-1 size-1.5 shrink-0 rounded-full bg-neutral-400"></span>Self-hosted option</li>
        </ul>
      </div>
    </div>
  </div>
</section>
```

---

## 4. Testimonial Wall (Masonry với real quotes)

```html
<section class="bg-[#fafafa] px-6 py-24 md:py-32">
  <div class="mx-auto max-w-7xl">
    <div class="mb-16 max-w-2xl">
      <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">— What teams say</p>
      <h2 class="text-4xl font-semibold leading-tight tracking-tight text-neutral-900 md:text-5xl">
        Receipts, not testimonials.
      </h2>
    </div>

    <div class="columns-1 gap-6 space-y-6 md:columns-2 lg:columns-3">
      <!-- Quote 1 -->
      <figure class="break-inside-avoid rounded-3xl border border-neutral-200 bg-white p-8">
        <blockquote class="text-base leading-relaxed text-neutral-800">
          "We replaced two contractors and a Figma seat in one weekend.
          The CFO asked if we'd accidentally fired someone."
        </blockquote>
        <figcaption class="mt-6 flex items-center gap-3">
          <img src="https://picsum.photos/seed/q1/40/40" class="size-10 rounded-full" alt=""/>
          <div class="text-sm">
            <div class="font-medium text-neutral-900">Maya Gokhan</div>
            <div class="text-neutral-500">Founder, Brewlab Coffee</div>
          </div>
        </figcaption>
      </figure>

      <!-- Quote 2 (longer) -->
      <figure class="break-inside-avoid rounded-3xl bg-neutral-900 p-8 text-white">
        <blockquote class="text-lg leading-relaxed">
          "Three years ago I would have called this 'too good to be true.'
          Now I just call it Tuesday."
        </blockquote>
        <figcaption class="mt-6 flex items-center gap-3">
          <img src="https://picsum.photos/seed/q2/40/40" class="size-10 rounded-full" alt=""/>
          <div class="text-sm">
            <div class="font-medium">Linh Nguyễn</div>
            <div class="text-white/60">CTO, Northwind Studio</div>
          </div>
        </figcaption>
      </figure>

      <!-- Quote 3 -->
      <figure class="break-inside-avoid rounded-3xl border border-neutral-200 bg-white p-8">
        <blockquote class="text-base leading-relaxed text-neutral-800">
          "The audit log alone saved us during our SOC2 prep. Three weeks
          of work compressed into 'oh, it's all there already.'"
        </blockquote>
        <figcaption class="mt-6 flex items-center gap-3">
          <img src="https://picsum.photos/seed/q3/40/40" class="size-10 rounded-full" alt=""/>
          <div class="text-sm">
            <div class="font-medium text-neutral-900">Thuy Pham</div>
            <div class="text-neutral-500">Head of Eng, Atelier 47</div>
          </div>
        </figcaption>
      </figure>

      <!-- Quote 4: Stat callout -->
      <div class="break-inside-avoid rounded-3xl bg-emerald-50 p-8">
        <div class="font-mono text-5xl font-semibold tabular-nums text-emerald-700">87%</div>
        <p class="mt-3 text-base leading-relaxed text-emerald-900">
          of users report cutting their bookkeeping time by more than half
          within 30 days.
        </p>
        <p class="mt-3 font-mono text-xs text-emerald-600">— Internal usage data, Q1 2026</p>
      </div>

      <!-- More quotes... -->
      <figure class="break-inside-avoid rounded-3xl border border-neutral-200 bg-white p-8">
        <blockquote class="text-base leading-relaxed text-neutral-800">
          "I trust the numbers I see here more than the ones from our
          ERP, and we pay $80k/year for the ERP."
        </blockquote>
        <figcaption class="mt-6 flex items-center gap-3">
          <img src="https://picsum.photos/seed/q5/40/40" class="size-10 rounded-full" alt=""/>
          <div class="text-sm">
            <div class="font-medium text-neutral-900">Hai Le</div>
            <div class="text-neutral-500">CFO, Folder Studios</div>
          </div>
        </figcaption>
      </figure>
    </div>
  </div>
</section>
```

---

## 5. FAQ Accordion (no card, divide-y minimal)

```html
<section class="bg-white px-6 py-24 md:py-32">
  <div class="mx-auto max-w-3xl">
    <div class="mb-12">
      <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">— FAQ</p>
      <h2 class="text-4xl font-semibold leading-tight tracking-tight text-neutral-900 md:text-5xl">
        The questions everyone asks before buying.
      </h2>
    </div>

    <div class="divide-y divide-neutral-200 border-y border-neutral-200">
      <details class="group py-6">
        <summary class="flex cursor-pointer list-none items-start justify-between gap-6 text-left">
          <span class="text-lg font-medium text-neutral-900">
            How is this different from $competitor?
          </span>
          <span class="mt-1 shrink-0 font-mono text-xl text-neutral-400 group-open:rotate-45 transition-transform">+</span>
        </summary>
        <div class="mt-4 max-w-2xl pr-12 text-base leading-relaxed text-neutral-600">
          We're not. We're better at three specific things and worse at five
          others. If you need feature A, B, or C, you'll like us. If you need
          X, Y, or Z, $competitor stays the right call.
        </div>
      </details>

      <details class="group py-6">
        <summary class="flex cursor-pointer list-none items-start justify-between gap-6 text-left">
          <span class="text-lg font-medium text-neutral-900">
            Can I import data from Notion / Airtable / our internal tool?
          </span>
          <span class="mt-1 shrink-0 font-mono text-xl text-neutral-400 group-open:rotate-45 transition-transform">+</span>
        </summary>
        <div class="mt-4 max-w-2xl pr-12 text-base leading-relaxed text-neutral-600">
          Notion + Airtable have one-click import. CSV works for everything
          else. There's a free migration team that does it for you above
          1k rows — DM us.
        </div>
      </details>

      <details class="group py-6">
        <summary class="flex cursor-pointer list-none items-start justify-between gap-6 text-left">
          <span class="text-lg font-medium text-neutral-900">
            What happens to my data if I cancel?
          </span>
          <span class="mt-1 shrink-0 font-mono text-xl text-neutral-400 group-open:rotate-45 transition-transform">+</span>
        </summary>
        <div class="mt-4 max-w-2xl pr-12 text-base leading-relaxed text-neutral-600">
          Full export available from settings — JSON + CSV — for 90 days
          after cancellation. Then it's deleted. No "data lock-in" tax.
        </div>
      </details>

      <details class="group py-6">
        <summary class="flex cursor-pointer list-none items-start justify-between gap-6 text-left">
          <span class="text-lg font-medium text-neutral-900">
            SOC2? GDPR? HIPAA?
          </span>
          <span class="mt-1 shrink-0 font-mono text-xl text-neutral-400 group-open:rotate-45 transition-transform">+</span>
        </summary>
        <div class="mt-4 max-w-2xl pr-12 text-base leading-relaxed text-neutral-600">
          SOC2 Type II since 2023, audited annually. GDPR-ready by default.
          HIPAA available on Business plan.
        </div>
      </details>
    </div>

    <p class="mt-12 text-center text-sm text-neutral-500">
      Still have questions? <a href="mailto:hello@brand.com" class="text-neutral-900 underline decoration-1 underline-offset-4">hello@brand.com</a>
    </p>
  </div>
</section>
```

---

## 6. Stat Strip (Big numbers, minimal chrome)

```html
<section class="border-y border-neutral-200 bg-[#fafafa] px-6 py-20">
  <div class="mx-auto max-w-7xl">
    <div class="grid grid-cols-2 gap-8 md:grid-cols-4">
      <div>
        <div class="font-mono text-5xl font-semibold tabular-nums text-neutral-900">847k</div>
        <div class="mt-3 text-sm text-neutral-500">teams shipping daily</div>
      </div>
      <div>
        <div class="font-mono text-5xl font-semibold tabular-nums text-neutral-900">14ms</div>
        <div class="mt-3 text-sm text-neutral-500">p50 query latency</div>
      </div>
      <div>
        <div class="font-mono text-5xl font-semibold tabular-nums text-neutral-900">99.97%</div>
        <div class="mt-3 text-sm text-neutral-500">uptime, last 12 months</div>
      </div>
      <div>
        <div class="font-mono text-5xl font-semibold tabular-nums text-neutral-900">$0</div>
        <div class="mt-3 text-sm text-neutral-500">for the first 47 teams this quarter</div>
      </div>
    </div>
  </div>
</section>
```

---

## 7. CTA Footer Band (Large gradient, single CTA)

```html
<section class="relative overflow-hidden bg-neutral-900 px-6 py-24 md:py-32">
  <!-- Subtle gradient orb -->
  <div class="pointer-events-none absolute left-1/2 top-1/2 -z-0 size-[800px] -translate-x-1/2 -translate-y-1/2 rounded-full bg-gradient-to-br from-violet-500/20 via-fuchsia-500/10 to-transparent blur-[120px]"></div>

  <div class="relative mx-auto max-w-3xl text-center">
    <h2 class="bg-gradient-to-b from-white to-white/70 bg-clip-text text-transparent font-semibold leading-tight tracking-tight"
        style="font-size: clamp(40px, 6vw, 72px);">
      Ship something<br>
      <em class="not-italic bg-gradient-to-r from-violet-400 to-fuchsia-400 bg-clip-text text-transparent">worth shipping.</em>
    </h2>
    <p class="mx-auto mt-8 max-w-xl text-lg leading-relaxed text-white/60">
      14-day trial. No credit card. Onboarding migration included.
    </p>
    <div class="mt-12 flex flex-wrap items-center justify-center gap-4">
      <a href="#" class="rounded-full bg-white px-8 py-4 text-base font-medium text-neutral-900 hover:bg-white/90 active:scale-[0.98]">
        Start 14-day trial
      </a>
      <a href="#" class="rounded-full border border-white/20 px-8 py-4 text-base font-medium text-white hover:bg-white/5">
        Book a demo →
      </a>
    </div>
  </div>
</section>
```

---

## 8. Footer (Editorial structured)

```html
<footer class="border-t border-neutral-200 bg-white px-6 py-20">
  <div class="mx-auto max-w-7xl">
    <div class="grid grid-cols-2 gap-12 md:grid-cols-5">
      <!-- Brand -->
      <div class="col-span-2">
        <div class="flex items-center gap-2">
          <span class="size-8 rounded-lg bg-neutral-900"></span>
          <span class="text-lg font-semibold tracking-tight text-neutral-900">Northwind</span>
        </div>
        <p class="mt-4 max-w-xs text-sm leading-relaxed text-neutral-600">
          Operations software for teams that ship. Made in Singapore + Hà Nội since 2023.
        </p>
        <div class="mt-6 flex items-center gap-2">
          <span class="size-2 rounded-full bg-emerald-500"></span>
          <span class="font-mono text-xs text-neutral-500">All systems operational</span>
        </div>
      </div>

      <!-- Product -->
      <div>
        <h4 class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">Product</h4>
        <ul class="space-y-3 text-sm text-neutral-700">
          <li><a href="#" class="hover:text-neutral-900">Features</a></li>
          <li><a href="#" class="hover:text-neutral-900">Pricing</a></li>
          <li><a href="#" class="hover:text-neutral-900">Changelog</a></li>
          <li><a href="#" class="hover:text-neutral-900">Roadmap</a></li>
        </ul>
      </div>

      <!-- Company -->
      <div>
        <h4 class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">Company</h4>
        <ul class="space-y-3 text-sm text-neutral-700">
          <li><a href="#" class="hover:text-neutral-900">About</a></li>
          <li><a href="#" class="hover:text-neutral-900">Hiring (3)</a></li>
          <li><a href="#" class="hover:text-neutral-900">Press kit</a></li>
          <li><a href="#" class="hover:text-neutral-900">Contact</a></li>
        </ul>
      </div>

      <!-- Legal -->
      <div>
        <h4 class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">Legal</h4>
        <ul class="space-y-3 text-sm text-neutral-700">
          <li><a href="#" class="hover:text-neutral-900">Terms</a></li>
          <li><a href="#" class="hover:text-neutral-900">Privacy</a></li>
          <li><a href="#" class="hover:text-neutral-900">Security</a></li>
          <li><a href="#" class="hover:text-neutral-900">DPA</a></li>
        </ul>
      </div>
    </div>

    <div class="mt-16 flex flex-col items-start justify-between gap-4 border-t border-neutral-200 pt-8 md:flex-row md:items-center">
      <p class="font-mono text-xs text-neutral-500">© 2026 Northwind Operations Inc.</p>
      <div class="flex gap-4 text-neutral-500">
        <a href="#" class="hover:text-neutral-900">Twitter</a>
        <a href="#" class="hover:text-neutral-900">GitHub</a>
        <a href="#" class="hover:text-neutral-900">LinkedIn</a>
      </div>
    </div>
  </div>
</footer>
```

---

## 9. Logo Strip (Social proof minimal)

```html
<section class="border-y border-neutral-200 bg-white px-6 py-12">
  <div class="mx-auto max-w-7xl">
    <p class="mb-6 text-center font-mono text-xs uppercase tracking-widest text-neutral-500">
      Used by teams at
    </p>
    <div class="flex flex-wrap items-center justify-center gap-x-12 gap-y-6 opacity-70 grayscale transition-all hover:opacity-100 hover:grayscale-0">
      <span class="text-lg font-semibold text-neutral-700">Brewlab</span>
      <span class="text-lg font-semibold text-neutral-700">Northwind</span>
      <span class="text-lg font-semibold text-neutral-700">Atelier 47</span>
      <span class="text-lg font-semibold text-neutral-700">Folder</span>
      <span class="text-lg font-semibold text-neutral-700">Linhden</span>
      <span class="text-lg font-semibold text-neutral-700">Supplyhouse</span>
    </div>
  </div>
</section>
```

---

## 10. Comparison Table (vs competitors)

```html
<section class="bg-white px-6 py-24 md:py-32">
  <div class="mx-auto max-w-5xl">
    <div class="mb-16 max-w-xl">
      <p class="mb-4 font-mono text-xs uppercase tracking-widest text-neutral-500">— Honest comparison</p>
      <h2 class="text-4xl font-semibold leading-tight tracking-tight text-neutral-900 md:text-5xl">
        Where we win, where we don't.
      </h2>
    </div>

    <div class="overflow-x-auto">
      <table class="w-full border-collapse text-sm">
        <thead>
          <tr class="border-b border-neutral-300">
            <th class="px-4 py-4 text-left font-mono text-xs uppercase tracking-widest text-neutral-500">Feature</th>
            <th class="px-4 py-4 text-left font-semibold text-neutral-900">Us</th>
            <th class="px-4 py-4 text-left font-medium text-neutral-500">Bigco SaaS</th>
            <th class="px-4 py-4 text-left font-medium text-neutral-500">Indie tool</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-neutral-200">
          <tr>
            <td class="px-4 py-4 text-neutral-700">Setup time</td>
            <td class="px-4 py-4 font-medium text-emerald-700">Under 5 minutes</td>
            <td class="px-4 py-4 text-neutral-600">2 weeks (sales call required)</td>
            <td class="px-4 py-4 text-neutral-600">30 minutes</td>
          </tr>
          <tr>
            <td class="px-4 py-4 text-neutral-700">Audit trail</td>
            <td class="px-4 py-4 font-medium text-emerald-700">Default, on every row</td>
            <td class="px-4 py-4 text-neutral-600">Enterprise add-on, $200/mo</td>
            <td class="px-4 py-4 text-neutral-600">Not available</td>
          </tr>
          <tr>
            <td class="px-4 py-4 text-neutral-700">Integrations</td>
            <td class="px-4 py-4 text-neutral-600">12 native</td>
            <td class="px-4 py-4 font-medium text-emerald-700">200+ via Zapier</td>
            <td class="px-4 py-4 text-neutral-600">3 native</td>
          </tr>
          <tr>
            <td class="px-4 py-4 text-neutral-700">Mobile app</td>
            <td class="px-4 py-4 text-red-700">Not yet (Q3 2026)</td>
            <td class="px-4 py-4 font-medium text-emerald-700">iOS + Android</td>
            <td class="px-4 py-4 text-neutral-600">iOS only</td>
          </tr>
          <tr>
            <td class="px-4 py-4 text-neutral-700">Self-hosted</td>
            <td class="px-4 py-4 font-medium text-emerald-700">Yes, Docker + K8s</td>
            <td class="px-4 py-4 text-neutral-600">Enterprise only</td>
            <td class="px-4 py-4 text-red-700">Cloud only</td>
          </tr>
          <tr>
            <td class="px-4 py-4 text-neutral-700">Price (10 seats)</td>
            <td class="px-4 py-4 font-mono font-medium text-emerald-700 tabular-nums">$240/mo flat</td>
            <td class="px-4 py-4 font-mono text-neutral-600 tabular-nums">$1,200/mo + setup</td>
            <td class="px-4 py-4 font-mono text-neutral-600 tabular-nums">$120/mo</td>
          </tr>
        </tbody>
      </table>
    </div>

    <p class="mt-8 text-sm italic text-neutral-500">
      Last updated 2026-04-01. We update this page when competitors ship things — last 14 changes
      <a href="#" class="text-neutral-900 underline decoration-1 underline-offset-4">on GitHub</a>.
    </p>
  </div>
</section>
```

**Why honest comparison wins:** showing where you LOSE (mobile app, Bigco integrations) makes the wins more credible. Removes "this looks like marketing" smell.

---

## SECTION COMBO RECIPES (build full landing fast)

### Lovable-tier landing (8 sections)
1. Hero pattern 2 (Bento)
2. Logo strip
3. Bento feature grid (#1)
4. Asymmetric feature row (#2)
5. Stat strip (#6)
6. Testimonial wall (#4)
7. Pricing tier (#3)
8. CTA footer band (#7) + Footer (#8)

### Kimi-tier landing (6 sections)
1. Hero pattern 5 (Animated pulse)
2. Logo strip (subtle)
3. Asymmetric feature row (#2)
4. Comparison table (#10)
5. CTA footer band (#7)
6. Footer (#8)

### Editorial site (4 sections)
1. Hero pattern 6 (Magazine drop cap)
2. Long-form essay body
3. Related articles
4. Newsletter signup
5. Footer minimal

---

## QUICK SECTION FIX REFERENCE

```
Output có 3-col equal generic       → Replace với Bento grid (#1)
Output có centered hero text        → Replace với Asymmetric split (Hero pattern 3)
Output có "Get Started" CTA generic → Replace với specific verb
Output có Acme/John Doe placeholder → Replace với contextual specific names
Output có FAQ trong card border-l   → Replace với divide-y minimal (#5)
Output có generic stat 99.9%         → Replace với organic 99.97%
Output thiếu social proof            → Add Logo strip (#9)
Output thiếu honesty                 → Add Comparison table (#10)
```
