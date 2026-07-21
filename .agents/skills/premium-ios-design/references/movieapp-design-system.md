# MovieApp design foundation

Use this as a starting direction, not an immutable brand specification. Prefer project/Figma tokens when they exist and update this reference when the product establishes approved values.

## Product character

Aim for a cinematic editorial feel:

- imagery carries emotion;
- typography and spacing establish confidence;
- chrome stays quiet so movies remain the focus;
- interactions feel immediate, tactile, and intentional;
- dense information remains scannable.

Avoid copying a streaming service's visual identity. MovieApp should feel native to iOS and recognizable on its own.

## Token strategy

Define semantic tokens in code rather than naming raw appearances:

- surfaces: canvas, elevated, overlay, selected;
- text: primary, secondary, tertiary, on-media, destructive;
- accents: action, favorite, rating, success;
- spacing: 4, 8, 12, 16, 24, 32 points, with exceptions justified by composition;
- radius: small for controls, medium for artwork/cards, capsule only for pill-shaped controls;
- motion: quick feedback, standard transition, emphasized reveal.

Use semantic dynamic `UIColor` values and verify contrast. Do not hard-code separate ad-hoc light and dark colors inside each screen.

Use three tiers only when each tier earns its existence:

1. Primitive values describe the available palette and scales.
2. Semantic tokens express product meaning such as `textPrimary`, `surfaceElevated`, or `actionFavorite`.
3. Component tokens exist only for a stable reusable component with a real variant need.

Treat token changes like API changes: find consumers, migrate coherently, and avoid aliases that preserve dead names indefinitely.

## Typography

- Map roles to Dynamic Type text styles.
- Use bold display roles sparingly; preserve readable line length and hierarchy.
- Prefer tabular figures for ratings, dates, and changing numeric values when alignment matters.
- Allow titles and localized labels to wrap where meaning would be lost by truncation.

## Movie-specific composition

- Preserve poster aspect ratios and avoid stretching artwork.
- Keep text legible over imagery with intentional crops and localized contrast treatment.
- Present metadata in a stable order; do not turn every attribute into a badge.
- Make favorite/watch actions unmistakable and expose their selected state to VoiceOver.
- Use skeletons only when layout stability materially helps; otherwise prefer a calm loading treatment.
- Empty states should explain the benefit and offer one relevant next action.
- Errors should preserve context, explain recovery, and provide retry only when retry can work.
- Use metadata chips selectively; a wall of pills weakens hierarchy and scanning.
- Downsample artwork to display size, cancel requests during reuse, and avoid image decode work on the main actor.
- Make poster loading stable: reserve aspect-ratio space and avoid content jumps.

## Visual acceptance checklist

- The primary action and current state are obvious within two seconds.
- Spacing follows a visible rhythm and alignments share common anchors.
- Text survives accessibility sizes and realistic localization.
- Posters remain crisp, correctly cropped, and stable during loading/reuse.
- Light/dark appearances and increased contrast remain readable.
- VoiceOver order matches visual and task order.
- Motion communicates cause and effect and honors Reduce Motion.
- Loading, empty, error, offline, and pressed/selected states feel designed rather than appended.
- Reduce Transparency and Increase Contrast retain usable separation and legibility.
- The interface remains understandable without color and without motion.
