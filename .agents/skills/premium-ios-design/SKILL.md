---
name: premium-ios-design
description: Design, implement, refine, and visually verify polished premium iOS interfaces for MovieApp. Use for UIKit screens, Figma handoff, design systems, typography, color, spacing, imagery, motion, interaction states, accessibility, responsive layouts, visual QA, or requests for modern, Apple-native, cinematic, elegant, or expensive-looking product design.
---

# Premium iOS Design

Create a distinctive cinematic experience that still behaves like a native iOS app. Treat “premium” as clarity, restraint, craft, and consistency—not gradients, glass, shadows, or animation added by default.

## Establish direction

1. Read the root `AGENTS.md`, the affected screen, assets, localization, and adjacent UI components.
2. Read [references/movieapp-design-system.md](references/movieapp-design-system.md). For new screens, redesigns, or visual audits, also read [references/design-review-playbook.md](references/design-review-playbook.md).
3. If a Figma frame is provided, inspect its hierarchy, components, variables, spacing, typography, assets, and states. Treat it as intent, then reconcile it with platform behavior and accessibility.
4. If no design exists, define a concise visual thesis tied to the audience, content, emotional tone, and primary user action before coding.
5. Build a state-and-content inventory with realistic long titles, missing artwork, slow network, empty data, errors, and accessibility sizes.
6. Reuse existing components and tokens when they meet the intended quality; improve shared foundations when repetition proves the need.

## Design the complete experience

- Establish hierarchy with scale, weight, whitespace, contrast, and content—not decoration alone.
- Separate primitives, semantic tokens, and component tokens. Name by purpose, not appearance.
- Use semantic colors and system materials. Preserve legibility across light/dark appearance and increased contrast.
- Prefer Apple system typography unless a licensed brand typeface and complete Dynamic Type mapping exist.
- Use real movie artwork or approved assets when available. Never fabricate copyrighted poster art or ship placeholder imagery as final UI.
- Define loading, empty, error, offline, disabled, selected, focused, pressed, and long-content states where relevant.
- Make touch targets at least 44×44 points and support Dynamic Type without clipping.
- Add accessibility labels, values, traits, grouping, and logical reading order.
- Respect safe areas, keyboard avoidance, compact widths, landscape, and content-size changes.
- Preserve reading order from top/leading according to locale, and verify RTL mirroring without mirroring posters or brand imagery.
- Use haptics and motion only to explain state, navigation, or direct manipulation. Respect Reduce Motion.
- Make animations interruptible, preserve continuity, and avoid blocking input. Prefer opacity/transform-style changes over repeated layout work when the result is equivalent.
- Apply iOS 26 materials and Liquid Glass selectively to navigation and high-value controls; system components receive the design automatically. Respect Reduce Transparency and Increase Contrast, avoid stacked glass, and use clear glass only over visually rich content with proven legibility.

## Implement in MovieApp

- Use programmatic UIKit and SnapKit unless the task explicitly changes the UI technology.
- Keep visual constants in small semantic token types; avoid unexplained numbers scattered through controllers.
- Keep reusable views self-contained and state-driven. Keep networking and business decisions out of views.
- Prefer `UIButton.Configuration`, content configurations, diffable data sources, compositional layout, and modern UIKit APIs when they simplify behavior.
- Prefer native controls and interaction semantics over visually recreated substitutes.
- Configure images for correct scale, clipping, placeholder, failure, and reuse behavior.
- Localize all user-facing strings and test expansion rather than designing for English-only copy.
- Do not introduce a broad design-system framework for one screen. Extract components when reuse or consistency justifies it.

## Run a visual QA loop

1. Build and launch the affected flow in iOS Simulator.
2. Capture screenshots for the primary state and materially different states at the same device, appearance, content, and scale as the reference.
3. Compare against Figma with overlays or side-by-side evidence when available; otherwise review hierarchy, rhythm, alignment, contrast, density, affordance, and content realism.
4. Repeat at accessibility text sizes, dark and light appearances, Increase Contrast, Reduce Transparency, Differentiate Without Color, and Reduce Motion when the design uses the affected feature.
5. Exercise loading, empty, partial content, error, offline, keyboard, long localization, RTL, missing artwork, and narrow/landscape states that the screen can reach.
6. Run Accessibility Inspector and manually verify VoiceOver order and custom-control behavior.
7. Fix visible defects and repeat until the screen is coherent at a glance and under interaction.

Do not claim pixel accuracy without a rendered comparison. If Simulator or source assets are unavailable, say which parts remain unverified.

## Quality bar

Reject the implementation if it contains arbitrary gradients, excessive corner radii, weak contrast, clipped text, generic card grids without content rationale, inconsistent spacing, decorative motion, stock placeholders, controls that only look interactive, or “premium” styling that competes with movie content.

Finish with a compact description of the design direction, states covered, accessibility work, and visual verification performed.
