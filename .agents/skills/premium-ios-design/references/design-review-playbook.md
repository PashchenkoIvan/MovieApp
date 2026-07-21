# Premium iOS design review playbook

## 1. Frame the product decision

Write one sentence for each:

- audience and job to be done;
- primary action;
- information that must be understood first;
- intended emotional tone;
- content that provides the visual identity.

If these are unclear, do not compensate with ornament. Clarify the experience first.

## 2. Build the state matrix

Review only applicable states, but never design content-only happy paths:

| Dimension | States |
| --- | --- |
| Data | loading, empty, partial, content, stale/offline, error |
| Interaction | normal, highlighted, selected, disabled, focused, destructive |
| Content | long title, missing poster, extreme rating/date, localized/RTL |
| Environment | compact/regular width, portrait/landscape, keyboard, safe-area changes |
| Appearance | light, dark, increased contrast, reduced transparency |
| Accessibility | large text, VoiceOver, Reduce Motion, Differentiate Without Color |

Define recovery and continuity: what remains visible, what action is offered, and whether retry is valid.

## 3. Establish visual hierarchy

- Start with content and reading order, then add controls and decoration.
- Use a shared alignment spine and a small spacing scale.
- Limit simultaneous emphasis: one dominant focal point, one primary action, and restrained secondary metadata.
- Use typography roles mapped through `UIFontMetrics`; do not treat fixed point sizes as a type system.
- Prefer SF Symbols for system actions, with consistent weight and filled/outline state semantics.
- Keep touch targets at least 44×44 points without visually inflating every glyph.

## 4. Use materials and motion deliberately

- Let system navigation and controls adopt current platform appearance before creating custom glass.
- Use Liquid Glass for the interaction layer, not as wallpaper behind every card.
- Verify content contrast under every material and accessibility appearance.
- Use motion for feedback, orientation, focus, and continuity.
- Keep repeated motion subtle, interruptible, and disabled or simplified for Reduce Motion.
- Use haptics only for meaningful confirmation, selection, warning, or impact; never for every tap.

## 5. Figma-to-UIKit workflow

When Figma access is available:

1. Inspect component instances, variants, variables, text/effect styles, constraints, and prototype behavior before exporting anything.
2. Map Figma semantic variables to asset-catalog colors and Swift tokens; do not copy raw values into controllers.
3. Map components to existing UIKit views/configurations before creating new classes.
4. Export only non-system, approved assets at the correct vector/raster format and scale.
5. Render the implementation with identical content and device dimensions.
6. Compare via overlay or side-by-side; classify differences as intentional platform adaptation or defect.

Do not mechanically reproduce a web-like Figma layout that conflicts with safe areas, Dynamic Type, navigation conventions, or native controls.

## 6. Accessibility acceptance

- VoiceOver label, value, trait, hint, grouping, and reading order match the task.
- Dynamic Type does not clip, overlap, hide actions, or destroy information hierarchy.
- Meaning does not rely only on hue, position, motion, sound, or haptic feedback.
- Custom controls expose native semantics and support activation without gesture-only knowledge.
- Reduce Motion replaces large spatial/depth movement with calmer continuity such as fades.
- Reduce Transparency and Increase Contrast preserve boundaries and text legibility.
- Destructive or difficult-to-recover actions include proportionate confirmation and recovery.

## 7. Screenshot evidence

Capture a compact proof set rather than dozens of redundant screenshots:

- primary content state;
- one materially different data state;
- dark appearance;
- accessibility text size;
- one relevant stress state such as RTL, error, keyboard, or missing artwork.

Record device, OS, appearance, locale, content size, and state. Do not claim pixel accuracy from memory or code inspection.

## Research basis

This synthesis was informed by Apple Human Interface Guidelines; OpenAI's Figma design-system workflow; curated community skills including `mobile-ios-design`, `design-system-patterns`, `interaction-design`, `visual-design-and-contrast`, `error-messaging-and-empty-states`, and iOS accessibility skills. Generic web and SwiftUI prescriptions were translated to MovieApp's programmatic UIKit stack rather than copied directly.
