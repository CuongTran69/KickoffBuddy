## Why

The 2026 FIFA World Cup is the first to expand to 48 teams across 12 groups, with a new advancement mechanic (top two per group plus the eight best third-placed teams) and a Round-of-32 knockout bracket. Casual fans — the core audience of Kickoff Buddy's "Understand" value layer — do not know how this new format works: how groups are scored, who advances, how ties are broken, or how the eight best third-placed teams are chosen. This is a high-impact, low-effort opportunity to explain the format in bite-sized, fully offline content while the tournament is approaching.

## What Changes

- Add a new **Format Guide** feature: an offline, read-only explainer for the WC2026 tournament format, surfaced under the "Understand" layer.
- New feature module `app/lib/features/format_guide/` (data / application / presentation), mirroring the existing `etiquette` static-content feature.
- New bundled asset `app/assets/data/format_guide.json` containing six ordered sections (overview, group stage, advancement, tiebreakers, best third-placed teams, knockout) with Vietnamese-primary content and optional ordered bullet lists for tiebreaker steps and knockout rounds.
- New list screen (section tiles) and detail screen (title + body + optional numbered bullets), reusing existing premium styling and the etiquette screen conventions.
- Two new routes outside the app shell: `/format-guide` (list) and `/format-guide/:id` (detail).
- New entry point: a third navigation tile in the Settings "Resources & Reference" card, alongside Vocabulary and Fan Etiquette.
- New localization keys (`formatGuide_*`) in both English and Vietnamese ARB files, plus regenerated localizations.
- Unit test for the repository and a widget test for the list screen, matching the existing bar for static-content features.

## Capabilities

### New Capabilities
- `format-guide`: Offline explainer of the WC2026 tournament format — content model, repository loading from a bundled JSON asset, list and detail presentation, routing, Settings entry point, and localized labels. Content accuracy (advancement numbers and tiebreaker order) must match official FIFA WC2026 sources, with a disclaimer that FIFA may update exact criteria.

### Modified Capabilities
<!-- None — this is purely additive. No existing spec requirements change. -->

## Impact

- **New code**: `app/lib/features/format_guide/**` (model, repository + providers, list screen, detail screen).
- **New asset**: `app/assets/data/format_guide.json` (the `assets/data/` directory is already registered in `app/pubspec.yaml`, so no pubspec change is required).
- **Modified code**:
  - `app/lib/core/routing/routes.dart` — add `formatGuide` path constant and `formatGuideDetail(id)` helper.
  - `app/lib/core/routing/app_router.dart` — register `/format-guide` and `/format-guide/:id` routes outside the shell.
  - `app/lib/features/settings/presentation/settings_screen.dart` — add a navigation tile in the "Resources & Reference" card.
  - `app/lib/l10n/app_en.arb`, `app/lib/l10n/app_vi.arb` — add `formatGuide_*` keys; regenerate `app_localizations*.dart` via `flutter gen-l10n`.
- **New tests**: `app/test/features/format_guide/format_guide_repository_test.dart`, `app/test/features/format_guide/format_guide_list_screen_test.dart`.
- **Dependencies**: none added. Uses existing `flutter_riverpod`, `go_router`, and bundled-asset loading already in the project.
- **Out of scope**: no animated/graphical bracket widget (clean stage list only), no English body content (VN-primary like etiquette), no home-screen surfacing, no quiz, no live data/API.
