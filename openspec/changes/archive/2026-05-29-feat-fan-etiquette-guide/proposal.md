## Why

Kickoff Buddy users — especially new football viewers — lack guidance on how to watch matches socially: when to cheer, how to explain rules without being condescending, how to avoid spoiling results for others, and how to behave at a sports bar. The Fan Etiquette Guide fills this gap with 7 short, friendly tips that complement the existing Rule Cards and Vocabulary features. All content is already written in `docs/future/03-fan-etiquette.md` and requires no backend or external data.

## What Changes

- A new `EtiquetteTip` data model and `EtiquetteRepository` (lazy-load from bundled JSON asset `assets/data/etiquette_tips.json`).
- A new `EtiquetteListScreen` at route `/etiquette` showing 7 tip cards.
- A new `EtiquetteDetailScreen` at route `/etiquette/:id` showing the full tip body.
- Both routes registered in `app_router.dart` outside the shell (push over nav bar).
- An entry tile added to the Settings screen "Resources & Reference" card, alongside the existing Vocabulary tile.
- 7 etiquette tips bundled as a JSON asset (content from `docs/future/03-fan-etiquette.md`).
- i18n strings for screen titles, navigation labels, and error states in both `app_en.arb` and `app_vi.arb`.

## Capabilities

### New Capabilities

- `fan-etiquette-guide`: Fan etiquette tip list and detail screens, bundled JSON data, repository, and Settings entry point.

### Modified Capabilities

<!-- No existing spec-level requirements change. -->

## Impact

- `app/assets/data/etiquette_tips.json` — new bundled JSON asset (7 tips).
- `app/pubspec.yaml` — register new asset path (if not already covered by wildcard).
- `app/lib/features/etiquette/data/etiquette_tip.dart` — new model.
- `app/lib/features/etiquette/data/etiquette_repository.dart` — new repository + Riverpod providers.
- `app/lib/features/etiquette/presentation/etiquette_list_screen.dart` — new list screen.
- `app/lib/features/etiquette/presentation/etiquette_detail_screen.dart` — new detail screen.
- `app/lib/core/routing/routes.dart` — add `/etiquette` and `/etiquette/:id` constants.
- `app/lib/core/routing/app_router.dart` — register two new GoRoutes outside the shell.
- `app/lib/features/settings/presentation/settings_screen.dart` — add etiquette tile to Resources card.
- `app/lib/l10n/app_en.arb` — add etiquette i18n strings.
- `app/lib/l10n/app_vi.arb` — add etiquette i18n strings.
