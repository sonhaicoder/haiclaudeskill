# Ready-to-copy Snippets

Các snippet này extract trực tiếp từ Kimi references — tested, proven, copy-paste là chạy đẹp ngay.

## 1. Tailwind v4 @theme config (CSS-first)

```css
/* app/globals.css hoặc src/index.css */
@import "tailwindcss";

@theme {
  /* Dark Luxury */
  --color-bg: #080808;
  --color-text: #F5F0EB;
  --color-text-muted: rgba(245, 240, 235, 0.55);
  --color-accent: rgba(200, 169, 126, 0.9);
  --color-accent-soft: rgba(200, 169, 126, 0.06);

  /* Fonts */
  --font-display: 'Cormorant Garamond', Georgia, serif;
  --font-body: 'Inter', system-ui, sans-serif;

  /* Spacing (landing scale) */
  --spacing-section: 8rem;
  --spacing-section-title: 4rem;

  /* Motion */
  --ease-premium: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-editorial: cubic-bezier(0.16, 1, 0.3, 1);
}

@layer base {
  body {
    font-family: var(--font-body);
    background: var(--color-bg);
    color: var(--color-text);
    font-weight: 300;
    -webkit-font-smoothing: antialiased;
  }
}

@layer components {
  .text-overline {
    font-size: 11px;
    font-weight: 400;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    line-height: 1.4;
  }

  .text-display {
    font-family: var(--font-display);
    font-size: clamp(44px, 8vw, 72px);
    font-weight: 400;
    letter-spacing: -0.02em;
    line-height: 1.05;
  }

  .text-body-small {
    font-size: 13px;
    font-weight: 300;
    letter-spacing: 0.01em;
    line-height: 1.5;
  }
}
```

## 2. Hero Section — full bg + text bottom-left

```tsx
'use client';
import { useRef, useEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export default function Hero() {
  const headingRef = useRef<HTMLHeadingElement>(null);
  const subtitleRef = useRef<HTMLParagraphElement>(null);
  const arrowRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const ctx = gsap.context(() => {
      gsap.from(headingRef.current, {
        opacity: 0, y: 30, duration: 3.0, ease: 'power3.out', delay: 0.2,
      });
      gsap.from(subtitleRef.current, {
        opacity: 0, y: 20, duration: 2.5, ease: 'power3.out', delay: 0.7,
      });
      gsap.from(arrowRef.current, {
        opacity: 0, duration: 2.0, ease: 'power2.out', delay: 1.2,
      });
    });
    return () => ctx.revert();
  }, []);

  return (
    <section className="relative w-full min-h-[100dvh] overflow-hidden">
      {/* Video/image background */}
      <video
        className="absolute inset-0 w-full h-full object-cover"
        style={{ objectPosition: 'center 70%' }}
        autoPlay muted loop playsInline
        poster="/hero-fallback.jpg"
      >
        <source src="/hero-bg.mp4" type="video/mp4" />
      </video>

      {/* Gradient overlay */}
      <div
        className="absolute inset-0 z-0"
        style={{ background: 'linear-gradient(180deg, rgba(8,8,8,0.50) 0%, rgba(8,8,8,0.85) 100%)' }}
      />

      {/* Content — bottom-left, NOT centered */}
      <div className="relative z-10 flex flex-col justify-end min-h-[100dvh] px-8 md:px-[8vw] pb-[15vh]">
        <div className="max-w-[700px]">
          <span className="text-overline text-[rgba(245,240,235,0.55)] block mb-6">
            Premium Commerce Platform
          </span>
          <h1 ref={headingRef} className="text-display text-[#F5F0EB]">
            Your brand.<br />Reimagined.
          </h1>
          <p ref={subtitleRef} className="font-body text-base md:text-lg font-light text-[rgba(245,240,235,0.55)] mt-6 leading-relaxed tracking-[0.02em]">
            Subtitle text here.
          </p>
        </div>
      </div>

      {/* Scroll indicator */}
      <div ref={arrowRef} className="absolute bottom-8 left-1/2 -translate-x-1/2 z-10">
        <span className="block text-[#F5F0EB] text-2xl">&rsaquo;</span>
      </div>
    </section>
  );
}
```

## 3. Liquid Glass Card component

```tsx
export function LiquidGlassCard({ children, className = '' }: { children: React.ReactNode; className?: string }) {
  return (
    <div className={`liquid-glass ${className}`}>
      {children}
    </div>
  );
}
```

```css
/* Add to globals.css */
.liquid-glass {
  background: rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(24px) saturate(140%);
  -webkit-backdrop-filter: blur(24px) saturate(140%);
  border: none;
  border-radius: 20px;
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.2),
    inset 0 -1px 0 rgba(0, 0, 0, 0.1),
    0 24px 48px -12px rgba(0, 0, 0, 0.3);
  position: relative;
  overflow: hidden;
}

.liquid-glass::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1.4px;
  background: linear-gradient(180deg,
    rgba(255,255,255,0.5) 0%,
    rgba(255,255,255,0.15) 20%,
    rgba(255,255,255,0) 40%,
    rgba(255,255,255,0) 60%,
    rgba(255,255,255,0.15) 80%,
    rgba(255,255,255,0.5) 100%);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  pointer-events: none;
  mix-blend-mode: screen;
  opacity: 0.25;
}

.liquid-glass::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  background:
    radial-gradient(ellipse 90% 40% at 50% 0%, rgba(255,255,255,0.18) 0%, transparent 55%),
    radial-gradient(ellipse 60% 35% at 65% 10%, rgba(255,255,255,0.08) 0%, transparent 50%);
  mix-blend-mode: overlay;
  pointer-events: none;
}
```

## 4. Noise Overlay

```tsx
// Mount once in root layout
export function NoiseOverlay() {
  return <div className="noise-overlay" aria-hidden="true" />;
}
```

```css
.noise-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  pointer-events: none;
  mix-blend-mode: overlay;
  opacity: 0.025;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
  background-repeat: repeat;
  background-size: 256px 256px;
  animation: noise-drift 20s ease-in-out infinite alternate;
}

@keyframes noise-drift {
  0%   { background-position: 0% 0%; }
  100% { background-position: 3% 5%; }
}
```

## 5. Lenis Smooth Scroll + ScrollTrigger bridge

```tsx
'use client';
import { useEffect } from 'react';
import Lenis from 'lenis';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export function SmoothScrollProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    const lenis = new Lenis({
      lerp: 0.08,
      duration: 1.2,
      smoothWheel: true,
    });

    lenis.on('scroll', ScrollTrigger.update);

    gsap.ticker.add((time) => {
      lenis.raf(time * 1000);
    });
    gsap.ticker.lagSmoothing(0);

    return () => {
      lenis.destroy();
    };
  }, []);

  return <>{children}</>;
}
```

## 6. Scroll-reveal wrapper (use on any section)

```tsx
'use client';
import { useRef, useEffect, ReactNode } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export function ScrollReveal({
  children,
  y = 60,
  duration = 1.2,
  stagger = 0,
}: {
  children: ReactNode;
  y?: number;
  duration?: number;
  stagger?: number;
}) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!ref.current) return;
    const targets = stagger > 0 ? ref.current.children : ref.current;

    const ctx = gsap.context(() => {
      gsap.from(targets, {
        opacity: 0,
        y,
        duration,
        ease: 'power3.out',
        stagger: stagger > 0 ? stagger : undefined,
        scrollTrigger: {
          trigger: ref.current,
          start: 'top 85%',
          toggleActions: 'play none none none',
        },
      });
    }, ref);

    return () => ctx.revert();
  }, [y, duration, stagger]);

  return <div ref={ref}>{children}</div>;
}
```

## 7. Package.json dependencies

```json
{
  "dependencies": {
    "next": "^15.0.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "gsap": "^3.12.7",
    "lenis": "^1.2.3",
    "react-fast-marquee": "^1.6.5"
  },
  "devDependencies": {
    "tailwindcss": "^4.0.0",
    "@tailwindcss/postcss": "^4.0.0",
    "typescript": "^5.7.0"
  }
}
```

## 8. Google Fonts import (root layout)

```tsx
// app/layout.tsx
import { Inter, Cormorant_Garamond, Playfair_Display } from 'next/font/google';

const inter = Inter({ subsets: ['latin'], weight: ['300', '400', '500', '600'], variable: '--font-inter' });
const cormorant = Cormorant_Garamond({ subsets: ['latin'], weight: ['300', '400', '500', '600', '700'], variable: '--font-cormorant' });
const playfair = Playfair_Display({ subsets: ['latin'], weight: ['400', '500', '600', '700'], variable: '--font-playfair' });

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="vi" className={`${inter.variable} ${cormorant.variable} ${playfair.variable}`}>
      <body>{children}</body>
    </html>
  );
}
```

## 9. Product card — luxury style

```tsx
export function ProductCard({ image, overline, title, description, price }: {
  image: string;
  overline: string;
  title: string;
  description: string;
  price: string;
}) {
  return (
    <article className="group cursor-pointer">
      <div className="aspect-[4/5] overflow-hidden bg-[#1a1a1a] mb-6">
        <img
          src={image}
          alt={title}
          className="w-full h-full object-cover transition-transform duration-[1200ms] ease-out group-hover:scale-[1.05]"
        />
      </div>
      <div className="space-y-2">
        <span className="text-overline text-[rgba(245,240,235,0.55)]">{overline}</span>
        <h3 className="font-display text-2xl text-[#F5F0EB] leading-tight">{title}</h3>
        <p className="text-body-small text-[rgba(245,240,235,0.55)]">{description}</p>
        <p className="text-overline text-[#F5F0EB] pt-2">{price}</p>
      </div>
    </article>
  );
}
```

## 10. Section divider (animated line)

```tsx
'use client';
import { useRef, useEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function SectionDivider() {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!ref.current) return;
    gsap.from(ref.current, {
      scaleX: 0,
      transformOrigin: 'left center',
      duration: 1.5,
      ease: 'power3.out',
      scrollTrigger: {
        trigger: ref.current,
        start: 'top 85%',
      },
    });
  }, []);

  return (
    <div className="w-full px-[8vw] py-24">
      <div ref={ref} className="h-px bg-[rgba(245,240,235,0.2)]" />
    </div>
  );
}
```
