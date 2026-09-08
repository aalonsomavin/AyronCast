---
name: ayron-design-ios
description: Design and build AyronCast iOS UI using the Ayron design system ported to SwiftUI. Use when building screens, styling views, or when the user mentions Ayron branding on iOS. Canonical web tokens live in the linked Ayron repo at design_system/Ayron/.
---

# Ayron Design System (iOS)

AyronCast mirrors the Ayron web design system in SwiftUI. Canonical reference: `design_system/Ayron/` in [aalonsomavin/Ayron](https://github.com/aalonsomavin/Ayron).

## Workflow

1. Read `Ayron/design_system/Ayron/readme.md` and `ui_kits/ayron-app/` for product patterns.
2. Use `AyronCast/Design/AyronTokens.swift` for colors, spacing, radii, and button styles.
3. Match the four core screens: Chat, Dashboard, Sources, Automations (`Features/`).
4. Sentence case, plain copy, no emoji. Primary actions use ink/near-black buttons.

## Non-negotiables

- Light mode only. Near-monochrome surfaces.
- One restrained blue (`AyronColor.accent`) for focus, selection, links — not large fills.
- Primary button: ink background, white text — one per view when possible.
- Hairline borders over shadows for cards; soft elevation only for floating layers.
- Geist is not bundled yet; use system font with `.monospaced` for metrics.

## Source map

| Path | Purpose |
|------|---------|
| `AyronCast/Design/AyronTokens.swift` | Swift color/spacing/button tokens |
| `AyronCast/Features/` | Product screens |
| `Ayron/design_system/Ayron/ui_kits/ayron-app/` | Web UI kit reference (linked repo) |
