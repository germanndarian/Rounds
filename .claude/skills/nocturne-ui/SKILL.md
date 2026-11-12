---
name: nocturne-ui
description: Use when creating or changing any SwiftUI view, color, font, button, divider, toast or full-screen cover in Rounds, or when matching the Claude Design "Rounds Prototype" (Nocturne design system).
---

# Nocturne UI

Names below exist in `Rounds/DesignSystem/Theme.swift` and `Components.swift`. Read them there before adding anything new.

## Tokens (Theme only, never ad-hoc colors)
- Core: `Theme.bg`, `.surface`, `.text`, `.accent` (#9184D9), `.divider`, `.muted`.
- Ramps: `Theme.neutral100`-`neutral900` (all nine); accent has `accent100/200/300` and `accent600/700/800/900` (no 400/500).
- Sections: `Theme.section`, `Theme.sectionGlow`. Radii: `Theme.radiusCard`, `Theme.radiusTile`.
- Fonts: `.heading(size)`, `.body(size, weight:)`, `.mono(size)` (film-stamp metadata).
- Hero gradient: `.nocturneHeroBackground(height:)`.

## Components
- Primary action: `.buttonStyle(AccentPillStyle())` (outlined, accent line and glow).
- Secondary action: `.buttonStyle(OutlinePillStyle())` (hairline).
- `FadingDivider()` for rules; also `CircleIconButton`, `Avatar`, `AvatarStack`, `Kicker`, `Tag`, `LiveDot`,
  `FilmPhoto`, `SealedPhoto`, `Polaroid`, `BadgeMedal`, `StatTile` in Components.swift. Reuse before writing new views.
- Toasts: `app.show(toast:)` shows via `.toasts()`. Put `.toasts()` on the root of every `fullScreenCover` (see `RootView.swift`).

## Look and rules
- Dark mode only. Near-black grounds, one blurple accent as line and glow, polaroid photo frames.
- SF Pro and SF Symbols (not Inter or Phosphor). Shot and cocktail glyphs are stand-ins: keep `// TODO(design):`.
- Minimum 44pt tap targets; primary actions in the bottom third (one-handed, in the dark, sometimes tipsy).
- Never show drink totals in profile stats or rank by drink count (see AGENTS.md hard rules).

## Design source
- Claude Design project **"Rounds Prototype"**: `https://claude.ai/design/p/12366273-24ae-40ff-acf5-25d84067897a`,
  file `Rounds Prototype.dc.html`, system **Nocturne**. Readable via the DesignSync tool after `/design-login`.
- Use the prototype's **A** variants: Home "Recap hero", Live "Feed + grid", Recap "Type-led".

## Worked when
`grep -rn "Color(" Rounds/Features` shows no new raw colors, the build passes, and the view looks right in a `-startScreen` launch.
