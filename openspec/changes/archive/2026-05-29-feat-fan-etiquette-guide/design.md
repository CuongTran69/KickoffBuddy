## Context

Kickoff Buddy already has two content-only features built on the same pattern: Rule Cards (21 cards, JSON asset, `RuleCardRepository`, list + detail screens) and Vocabulary (17 terms, JSON asset, `VocabularyRepository`, list + search screen). Fan Etiquette Guide follows the same architecture: bundled JSON, lazy-load repository with in-memory cache, two screens, GoRouter routes outside the shell.

The nav bar (`AppShell`) currently has 5 tabs. Adding a 6th tab would break the `_PremiumFloatingNavBar` sliding indicator, which computes position as `-1.0 + (selectedIndex * (2.0 / (destinations.length - 1)))`. The Settings screen already has a "Resources & Reference" card with a Vocabulary tile — this is the natural entry point for Etiquette Guide.

Content for all 7 tips is fully written in `docs/future/03-fan-etiquette.md`. The tips are Vietnamese-first (the app's primary audience) with no EN/VI toggle needed — unlike Rule Cards which have bilingual body text.

## Goals / Non-Goals

**Goals:**
- Bundle 7 etiquette tips as a JSON asset.
- Implement `EtiquetteTip` model and `EtiquetteRepository` following the `RuleCardRepository` pattern.
- Build `EtiquetteListScreen` (list of 7 tip tiles) and `EtiquetteDetailScreen` (full tip body).
- Register `/etiquette` and `/etiquette/:id` routes outside the shell in `app_router.dart`.
- Add an "Etiquette Guide" navigation tile to the Settings screen Resources card.
- Fully localize screen titles and error strings in vi + en.

**Non-Goals:**
- Adding a new bottom nav tab.
- EN/VI toggle on detail screen (content is Vietnamese-only for MVP).
- Search/filter on the list screen (7 items, no filter needed).
- Persisting read/unread state.
- Linking etiquette tips from other screens (e.g., Match Detail).

## Decisions

**D1: Navigation entry point — Settings Resources card**
The Settings screen already has a "Resources & Reference" `_PremiumSettingsCard` with a Vocabulary tile. Adding an Etiquette tile here is consistent and avoids touching the nav bar. The Vocabulary route is already outside the shell (`/vocabulary` in `app_router.dart`), so the same pattern applies.

**D2: Data model — EtiquetteTip (no level field)**
Unlike `RuleCard` which has `level` (newbie/casual/advanced), etiquette tips have no level. The model needs: `id`, `titleVi`, `bodyVi`, `icon` (Material icon name string for display). No EN fields for MVP — content is Vietnamese-only.

**D3: Repository pattern — identical to RuleCardRepository**
`EtiquetteRepository` with `_cache`, `getAll()`, `getById(String id)`. Provider: `etiquetteRepositoryProvider` (Provider) + `etiquetteTipsProvider` (FutureProvider). No Isar — content is read-only.

**D4: List screen — simple ListView, no filter chips**
7 items don't need filtering. Each tile shows the tip icon + title. Tapping navigates to detail. Error state: inline error + retry button (same pattern as `RuleCardsScreen`).

**D5: Detail screen — body text only, no EN/VI toggle**
`EtiquetteDetailScreen` shows title + full body text. No toggle. Uses `PremiumScreenBackground` + `Scaffold` + `SingleChildScrollView` — same as `RuleCardDetailScreen`.

**D6: JSON asset structure**
```json
{
  "tips": [
    { "id": "no_spoil", "titleVi": "...", "bodyVi": "...", "icon": "block" },
    ...
  ]
}
```
Asset path: `assets/data/etiquette_tips.json`. Check `pubspec.yaml` — if `assets/data/` is already declared as a directory, no change needed.

**D7: Routes**
- `Routes.etiquette = '/etiquette'` (list)
- `Routes.etiquetteDetail(String id) => '/etiquette/$id'` (detail)
Both registered outside the shell in `app_router.dart`, same as `/vocabulary` and `/rules/:id`.

## Risks / Trade-offs

- [Risk] `pubspec.yaml` may need updating if `assets/data/` is not already a wildcard asset declaration. → Mitigation: check pubspec before writing; add entry only if missing.
- [Risk] Vietnamese-only content limits EN users. → Mitigation: acceptable for MVP; Phase 2 can add EN translations. The app's primary audience is Vietnamese.
- [Risk] Settings screen Resources card grows to 2 tiles — layout must handle vertical stacking. → Mitigation: the card already uses a `Column` child; adding a second `_SettingsNavigationTile` with a `SizedBox(height: 10)` separator follows the existing Language section pattern.
