# Motion Recipes — Animation Patterns

> Premium animation snippets cho Kimi/Lovable-tier. CSS-first when possible, Framer Motion khi cần physics.
> **Rule:** animate ONLY `transform` và `opacity`. Use `IntersectionObserver`, KHÔNG `window.addEventListener('scroll')`.

---

## 1. Ambient Background Pulse (Kimi signature)

**Use case:** Hero ambient depth without distraction.

```html
<div class="pointer-events-none absolute inset-0 -z-10">
  <div class="absolute left-1/4 top-1/4 size-[600px] rounded-full bg-violet-600/15 blur-[120px] animate-blob-1"></div>
  <div class="absolute right-1/4 bottom-1/4 size-[500px] rounded-full bg-cyan-500/10 blur-[100px] animate-blob-2"></div>
</div>

<style>
@keyframes blob-1 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33%      { transform: translate(60px, -40px) scale(1.1); }
  66%      { transform: translate(-30px, 40px) scale(0.95); }
}
@keyframes blob-2 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50%      { transform: translate(-50px, 30px) scale(1.15); }
}
.animate-blob-1 { animation: blob-1 25s ease-in-out infinite; }
.animate-blob-2 { animation: blob-2 18s ease-in-out infinite; }

@media (prefers-reduced-motion: reduce) {
  .animate-blob-1, .animate-blob-2 { animation: none; }
}
</style>
```

**Performance notes:**
- `pointer-events-none` để không bắt clicks
- `-z-10` để stay behind content
- `blur-[120px]` heavy nên KHÔNG đặt trên scrolling container (chỉ trên `position: absolute` trong fixed/relative parent)
- Slow durations (18-25s) để feel calm, không jittery
- Counter-rotating directions (blob-1 vs blob-2) cho ambient depth

---

## 2. Entrance Reveal — IntersectionObserver

**Use case:** Sections fade in khi scroll into view.

```html
<script>
  // Vanilla JS — works without framework
  const reveal = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('revealed');
        reveal.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1, rootMargin: '0px 0px -10% 0px' });

  document.querySelectorAll('.reveal').forEach(el => reveal.observe(el));
</script>

<style>
.reveal {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 700ms cubic-bezier(0.16, 1, 0.3, 1),
              transform 700ms cubic-bezier(0.16, 1, 0.3, 1);
}
.reveal.revealed {
  opacity: 1;
  transform: translateY(0);
}

/* Stagger với CSS variable */
.reveal { transition-delay: calc(var(--reveal-delay, 0) * 80ms); }
</style>

<!-- Usage with stagger -->
<div class="reveal" style="--reveal-delay: 0">First</div>
<div class="reveal" style="--reveal-delay: 1">Second (80ms later)</div>
<div class="reveal" style="--reveal-delay: 2">Third (160ms later)</div>
```

**Why this works:**
- IntersectionObserver = no scroll listener performance hit
- `cubic-bezier(0.16, 1, 0.3, 1)` = easeOutExpo (premium feel)
- 700ms duration = perceptible but not slow
- `unobserve` after reveal = no re-trigger on scroll back
- Stagger via CSS var = no JavaScript loop needed

---

## 3. Sticky Scroll Stack (cards stack as you scroll)

**Use case:** Feature highlight với 3-5 cards thay nhau "stick".

```html
<section class="px-6 py-32">
  <div class="mx-auto max-w-4xl">
    <div class="space-y-32">
      <div class="sticky top-24 rounded-3xl border border-neutral-200 bg-white p-12 shadow-sm">
        <h3 class="text-3xl font-semibold">Card 1 — sticks first</h3>
        <p class="mt-4 text-neutral-600">Subsequent cards stack OVER this one as user scrolls.</p>
      </div>
      <div class="sticky top-32 rounded-3xl border border-neutral-200 bg-white p-12 shadow-sm">
        <h3 class="text-3xl font-semibold">Card 2 — stacks 32px below</h3>
      </div>
      <div class="sticky top-40 rounded-3xl border border-neutral-200 bg-white p-12 shadow-sm">
        <h3 class="text-3xl font-semibold">Card 3 — stacks 40px below</h3>
      </div>
    </div>
  </div>
</section>
```

**Trick:** Each card has SLIGHTLY different `top` value (24/32/40px). Creates visual "step" effect when stacked.

---

## 4. Magnetic Button (Framer Motion)

**Use case:** Premium CTA — button slightly pulls toward cursor.

```jsx
'use client'
import { motion, useMotionValue, useSpring, useTransform } from 'framer-motion'
import { useRef } from 'react'

export function MagneticButton({ children, ...props }) {
  const ref = useRef(null)
  const x = useMotionValue(0)
  const y = useMotionValue(0)

  const springConfig = { stiffness: 150, damping: 15, mass: 0.1 }
  const springX = useSpring(x, springConfig)
  const springY = useSpring(y, springConfig)

  const handleMouseMove = (e) => {
    const rect = ref.current.getBoundingClientRect()
    const centerX = rect.left + rect.width / 2
    const centerY = rect.top + rect.height / 2
    x.set((e.clientX - centerX) * 0.3)  // 30% pull strength
    y.set((e.clientY - centerY) * 0.3)
  }

  const handleMouseLeave = () => {
    x.set(0)
    y.set(0)
  }

  return (
    <motion.button
      ref={ref}
      onMouseMove={handleMouseMove}
      onMouseLeave={handleMouseLeave}
      style={{ x: springX, y: springY }}
      className="rounded-full bg-neutral-900 px-8 py-4 text-white"
      {...props}
    >
      {children}
    </motion.button>
  )
}
```

**Why useMotionValue, không useState:** state updates trigger React re-render mỗi frame → performance collapse. `useMotionValue` updates outside React render cycle.

---

## 5. Gradient Text Mask Reveal

**Use case:** Hero headline reveals char-by-char với gradient.

```html
<h1 class="bg-gradient-to-r from-neutral-900 via-neutral-900 to-neutral-900/30 bg-[length:200%_100%] bg-clip-text text-transparent animate-shimmer text-7xl font-semibold">
  Build something impossible
</h1>

<style>
@keyframes shimmer {
  0%   { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
.animate-shimmer { animation: shimmer 3s linear infinite; }
</style>
```

**Restraint:** 3s loop, không faster (jittery). Use SPARINGLY — 1 hero per page, nếu nhiều thì quay về static text.

---

## 6. Tactile Button Press

**Use case:** Every interactive button.

```css
button, .btn, a.cta {
  transition: transform 100ms ease-out;
}
button:active, .btn:active, a.cta:active {
  transform: scale(0.97);
}
button:hover, .btn:hover, a.cta:hover {
  transform: translateY(-1px);
  transition: transform 200ms cubic-bezier(0.16, 1, 0.3, 1);
}
```

Combined effect: hover lift + press squish. Restrained but premium.

---

## 7. Counter-Up (numbers animate to value)

**Use case:** Stat strip — "847k teams" counts up khi scroll vào view.

```jsx
'use client'
import { motion, useInView, useMotionValue, useSpring, useTransform } from 'framer-motion'
import { useEffect, useRef } from 'react'

export function CountUp({ to, suffix = '', duration = 2 }) {
  const ref = useRef(null)
  const isInView = useInView(ref, { once: true })
  const motionValue = useMotionValue(0)
  const springValue = useSpring(motionValue, { duration: duration * 1000, bounce: 0 })
  const display = useTransform(springValue, (latest) =>
    new Intl.NumberFormat().format(Math.round(latest))
  )

  useEffect(() => {
    if (isInView) motionValue.set(to)
  }, [isInView, motionValue, to])

  return (
    <span ref={ref} className="font-mono tabular-nums">
      <motion.span>{display}</motion.span>{suffix}
    </span>
  )
}

// Usage
<CountUp to={847000} suffix="+" />
<CountUp to={99.97} suffix="%" />
```

---

## 8. Page Load Choreography (cascade reveal)

**Use case:** Hero load — eyebrow → headline → lede → CTA reveal sequentially.

```jsx
'use client'
import { motion } from 'framer-motion'

const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: { staggerChildren: 0.12, delayChildren: 0.1 }
  }
}

const item = {
  hidden: { opacity: 0, y: 20 },
  show: {
    opacity: 1,
    y: 0,
    transition: { duration: 0.7, ease: [0.16, 1, 0.3, 1] }
  }
}

export function HeroChoreographed() {
  return (
    <motion.div variants={container} initial="hidden" animate="show">
      <motion.p variants={item} className="eyebrow">— ESSAY · 2026</motion.p>
      <motion.h1 variants={item} className="display">Design without apology.</motion.h1>
      <motion.p variants={item} className="lede">Long body text...</motion.p>
      <motion.div variants={item} className="cta-row">
        <button>Start reading</button>
      </motion.div>
    </motion.div>
  )
}
```

**Stagger key:** `staggerChildren: 0.12` (120ms between children) feels luxurious. Faster = jumpy. Slower = feels broken.

---

## 9. Image Parallax (scroll-driven, không scroll listener)

**Use case:** Hero image moves slower than text on scroll.

```jsx
'use client'
import { motion, useScroll, useTransform } from 'framer-motion'
import { useRef } from 'react'

export function ParallaxImage({ src, alt }) {
  const ref = useRef(null)
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ['start end', 'end start']
  })
  const y = useTransform(scrollYProgress, [0, 1], ['-10%', '10%'])

  return (
    <div ref={ref} className="relative h-[600px] overflow-hidden">
      <motion.img
        src={src}
        alt={alt}
        style={{ y }}
        className="absolute inset-0 size-full scale-110 object-cover"
      />
    </div>
  )
}
```

**Subtle is key:** `-10%` to `10%` (20% total range). More than that = motion sickness.

---

## 10. Cursor Spotlight (premium card hover)

**Use case:** Card có gradient highlight follow cursor.

```jsx
'use client'
import { motion, useMotionValue, useMotionTemplate } from 'framer-motion'

export function SpotlightCard({ children }) {
  const mouseX = useMotionValue(0)
  const mouseY = useMotionValue(0)

  const handleMouseMove = ({ currentTarget, clientX, clientY }) => {
    const { left, top } = currentTarget.getBoundingClientRect()
    mouseX.set(clientX - left)
    mouseY.set(clientY - top)
  }

  return (
    <div
      onMouseMove={handleMouseMove}
      className="group relative rounded-3xl border border-white/10 bg-white/[0.02] p-8"
    >
      <motion.div
        className="pointer-events-none absolute -inset-px rounded-3xl opacity-0 transition-opacity duration-300 group-hover:opacity-100"
        style={{
          background: useMotionTemplate`
            radial-gradient(400px circle at ${mouseX}px ${mouseY}px, rgba(120, 119, 198, 0.15), transparent 80%)
          `
        }}
      />
      {children}
    </div>
  )
}
```

---

## ANIMATION CHOREOGRAPHY GUIDE (when use what)

| Pattern | When to use | Avoid when |
|---------|-------------|------------|
| Ambient pulse (#1) | Hero, premium landing | Dashboard, dense content |
| Entrance reveal (#2) | Section transitions, bento tiles | Above-the-fold (delays content) |
| Sticky stack (#3) | Long landing với 3-5 product features | Site có < 3 sections |
| Magnetic button (#4) | Primary CTA, agency portfolio | Mobile (no cursor), accessibility-first |
| Shimmer text (#5) | 1 hero headline | Multiple elements (overload) |
| Tactile press (#6) | EVERY button | Never skip |
| Counter-up (#7) | Stat strip, social proof | Decorative-only stats |
| Page choreography (#8) | Hero entrance | Sub-pages (overkill) |
| Parallax (#9) | Editorial, agency hero | Dashboards, mobile |
| Cursor spotlight (#10) | Bento grid premium | Mobile, > 12 tiles (perf) |

---

## PERFORMANCE BUDGET

```
Page load JS budget for animations:  < 50KB
Animation duration:                   < 800ms (anything longer = feels broken)
Stagger delay:                        80-120ms between siblings
Active animations onscreen:           ≤ 5 (pulse, scroll reveal counts as 1 each)
Animation pause on prefers-reduced-motion: ALWAYS

@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## CRITICAL DON'TS

```
❌ window.addEventListener('scroll', ...)        → Use IntersectionObserver / useScroll
❌ useState for cursor position                  → Use useMotionValue
❌ useEffect with rAF loop                        → Use Framer Motion useTransform
❌ animating top/left/width/height                → animate transform/opacity ONLY
❌ box-shadow animated on every frame             → expensive, use opacity layer
❌ animation on scrolling container               → moves to fixed/sticky parent
❌ multiple parallax effects same page            → choose 1 max
❌ stagger > 200ms between children               → feels broken, not luxurious
❌ infinite loops > 5s                            → slow loops feel premium
❌ any animation without prefers-reduced-motion check → accessibility fail
```
