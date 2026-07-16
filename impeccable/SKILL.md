---
name: "impeccable"
description: "Use when designing, redesigning, critiquing, auditing, polishing, or otherwise improving a frontend interface — websites, landing pages, dashboards, product UI, components, forms, onboarding, empty states. Covers visual hierarchy, accessibility, typography, spacing, layout, color, motion, and avoiding AI-generated design \"slop\". Not for backend-only or non-UI tasks."
---

# Impeccable — design guidance for AI-generated frontends

Produce production-grade frontend interfaces: real working code, committed design choices, exceptional craft — not prototypes or starting points. Take no shortcuts unless the user asks. Don't stop until the result is beautiful, responsive, fast, precise, bug-free, and on-brand.

> Adapted from **Impeccable** by Paul Bakaus (github.com/pbakaus/impeccable, Apache-2.0). This is the self-contained design-guidance core. The full plugin — 23 slash-commands (`craft`, `audit`, `critique`, `polish`, `bolder`, `quieter`, `distill`, `animate`, `live`, …), a 46-rule deterministic detector CLI, edit-time hooks, and browser live-iteration — is meant for a coding harness. Install it there with `npx impeccable install` or, in Claude Code, `/plugin marketplace add pbakaus/impeccable`.

## The one test

If someone could look at the interface and say "AI made that" without doubt, it has failed. Every model was trained on the same SaaS templates, so the default output has the same tells: Inter for everything, purple-to-blue gradients, cards nested in cards, gray text on colored backgrounds, a rounded-square icon tile above every heading. Actively design *away* from those.

**Category-reflex check**, run at two altitudes:
- **First-order:** if someone could guess the theme + palette from the category alone ("it's a fintech, so navy-and-gold"), it's the first training-data reflex. Rework until the answer isn't obvious from the domain.
- **Second-order:** if someone could guess the aesthetic from category-plus-anti-reference ("AI tool that's *not* SaaS-cream → editorial-typographic"), it's the trap one tier deeper. Rework until neither answer is obvious.

## General rules

### Color
- **Verify contrast.** Body text ≥4.5:1 against its background; large text (≥18px, or bold ≥14px) ≥3:1. Placeholder text needs the same 4.5:1. The most common failure is muted gray body text on a tinted near-white — light gray "for elegance" is the single biggest reason AI designs feel hard to read. When close, bump the body color toward the ink end of the ramp.
- Gray text on a colored background looks washed out. Use a darker shade of the background's own hue, or a transparency of the text color.

### Typography
- Cap body line length at 65–75ch.
- Don't pair fonts that are similar-but-not-identical (two geometric sans, two humanist sans). Pair on a contrast axis (serif + sans, geometric + humanist) or use one family across multiple weights.
- Hero/display heading ceiling: `clamp()` max ≤ 6rem (~96px). Above that the page is shouting, not designing.
- Display letter-spacing floor: ≥ -0.04em. Tighter and letters touch — cramped, not "designed". -0.02 to -0.03em is plenty for tight display.
- Use `text-wrap: balance` on h1–h3; `text-wrap: pretty` on long prose to reduce orphans.

### Layout
- Vary spacing for rhythm — don't use one uniform gap everywhere.
- Cards are the lazy answer. Use them only when they're truly the best affordance. **Nested cards are always wrong.**
- Flexbox for 1D, Grid for 2D. Don't default to Grid when `flex-wrap` is simpler.
- Responsive grids without breakpoints: `repeat(auto-fit, minmax(280px, 1fr))`.
- Build a semantic z-index scale (dropdown → sticky → modal-backdrop → modal → toast → tooltip). Never arbitrary `999` / `9999`.

### Motion
- Motion is part of the build, not an afterthought — but it must be intentional.
- Don't animate CSS layout properties unless truly needed.
- Ease out with exponential curves (ease-out-quart/quint/expo). **No bounce, no elastic** — it feels dated.
- Reach for real libraries for advanced motion (motion, gsap, anime.js, lenis).
- **Reduced motion is not optional.** Every animation needs a `@media (prefers-reduced-motion: reduce)` alternative (crossfade or instant).
- Staggering items within one list is legitimate; the tell is the *uniform reflex* — one identical entrance on every section. Each reveal should fit what it reveals.
- Reveal animations must enhance an already-visible default. Don't gate content visibility on a class-triggered transition — transitions pause on hidden tabs and headless renderers, so the section ships blank.
- Premium motion isn't only transform/opacity: blur, backdrop-filter, clip-path, mask, and shadow/glow are part of the palette when they materially improve the effect and stay smooth.

### Interaction
- Dropdowns with `position: absolute` inside an `overflow: hidden`/`auto` container get clipped. Use native `<dialog>`/popover API, `position: fixed`, or a portal to escape the stacking context.
- Never animate an `<img>` on hover (including Tailwind `group-hover:scale/rotate/translate` on a child image via parent hover). The image isn't an action target; animate the card's background, border, or shadow instead.

## New projects only (no prior work exists)

### Color & theme
- Use **OKLCH** throughout.
- **The cream / sand / beige body background is the saturated AI default.** The whole warm-neutral band (OKLCH L 0.84–0.97, C < 0.06, hue 40–100) reads as cream/paper/parchment no matter what you name it — `--paper`, `--cream`, `--sand`, `--linen`, `--ivory` are tells in themselves. Don't translate "warm/editorial/traditional" into a near-white warm-tinted bg. Instead pick: (a) a saturated brand color as the body (terracotta, oxblood, deep ochre, near-black); (b) a true off-white at chroma 0, or tinted toward the brand's own hue; or (c) a darker mid-tone tinted neutral that's clearly the brand's. Carry "warmth" via accent + typography + imagery, not the body bg.
- Tinted neutrals: add only 0.005–0.015 chroma toward the brand's hue. Don't default-tint warm/cool "because the brand feels that way".
- Dark vs. light is never a default (not dark "because tools look cool", not light "to be safe"). Before choosing, write one sentence of physical scene: who uses this, where, under what ambient light, in what mood. If the sentence doesn't force the answer, add detail until it does.
- Pick a **color strategy** before picking colors, on a commitment axis:
  - **Restrained** — tinted neutrals + one accent ≤10%. Product default.
  - **Committed** — one saturated color carries 30–60% of the surface. Identity-driven pages.
  - **Full palette** — 3–4 named roles, each used deliberately. Campaigns, data viz.
  - **Drenched** — the surface IS the color. Heroes, campaign pages.

## Absolute bans

Match-and-refuse. If you're about to write any of these, rewrite the element with different structure.

- **Side-stripe borders** — `border-left`/`border-right` > 1px as a colored accent on cards, list items, callouts, or alerts. Rewrite with full borders, background tints, leading numbers/icons, or nothing.
- **Gradient text** — `background-clip: text` on a gradient. Use a single solid color; emphasis via weight or size.
- **Glassmorphism as default** — blur/glass cards used decoratively. Rare and purposeful, or nothing.
- **The hero-metric template** — big number, small label, supporting stats, gradient accent. SaaS cliché.
- **Identical card grids** — same-sized icon + heading + text cards repeated endlessly.
- **Tiny uppercase tracked eyebrow above every section** — the all-caps kicker ("ABOUT" / "PROCESS" / "PRICING") on every heading is AI grammar. One deliberate named kicker as a brand system is fine; one on every section is a tell.
- **Numbered section markers as default scaffolding (01 / 02 / 03)** above every section. Numbers earn their place only when the section genuinely IS an ordered sequence.
- **Text that overflows its container** — long heading words + large clamp scales + narrow grids overflow on tablet/mobile. Test heading copy at every breakpoint; reduce the clamp max or rewrite. The viewport is part of the design.
- **Ghost-card** — `border: 1px solid` + a soft wide `box-shadow` (blur ≥16px) on the same element. Pick one: a single solid border, OR a defined shadow ≤8px blur.
- **Over-rounding** — `border-radius` ≥24px on cards/sections/inputs. Cards top out at 12–16px; full-pill is fine only for tags/buttons.
- **Hand-drawn / sketchy SVG illustrations** — `feTurbulence`/`feDisplacementMap` "paper grain", crude multi-path scenes. Reads amateurish. If you can't render it with real assets, ship no illustration.
- **`repeating-linear-gradient` stripe backgrounds** and **decorative two-axis CSS grid overlays** (`linear-gradient(... 1px, transparent 1px)` + `background-size`) unless the surface is an actual canvas, map, blueprint, or measurement tool.

## Working method

When the task is substantial, shape before you build: plan the UX/IA and the color/type/layout decisions, then implement fully. Reuse what already exists in the codebase (tokens, theme, components) when it works; branch out when the UX wins. Battle-test the result with the tools available — screenshot the rendered page, check every breakpoint, verify contrast — and iterate until it's genuinely shippable.
