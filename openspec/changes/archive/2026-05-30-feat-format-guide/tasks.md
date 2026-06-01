## 1. Content asset

- [x] 1.1 Create `app/assets/data/format_guide.json` with root `{ "sections": [...] }`
- [x] 1.2 Author the six ordered sections (`overview`, `groups`, `advancement`, `tiebreakers`, `best_thirds`, `knockout`) with Vietnamese-primary `titleVi`/`bodyVi` and Material `icon` names (`public`, `groups`, `trending_up`, `compare_arrows`, `format_list_numbered`, `emoji_events`)
- [x] 1.3 Add ordered `bullets` to the `tiebreakers` section (goal difference, goals scored, head-to-head, fair-play points, FIFA ranking/draw) and a closing disclaimer line in its body that FIFA may update exact criteria
- [x] 1.4 Add ordered `bullets` to the `knockout` section (Round of 32, Round of 16, Quarter-finals, Semi-finals, Third-place match, Final) ← (verify: advancement numbers 24+8=32 and tiebreaker order match FIFA WC2026 sources)

## 2. Data layer

- [x] 2.1 Create `app/lib/features/format_guide/data/format_guide_section.dart` — immutable `FormatGuideSection` with `id`, `titleVi`, `bodyVi`, `icon`, `bullets` (default `const []`), `fromJson` factory, value equality on `id` (mirror `EtiquetteTip`)
- [x] 2.2 Create `app/lib/features/format_guide/data/format_guide_repository.dart` — `FormatGuideRepository` with `_cache`, lazy `getAll()` loading `assets/data/format_guide.json` (`sections` array), `getById(id)`; plus `formatGuideRepositoryProvider` (Provider) and `formatGuideSectionsProvider` (FutureProvider) (mirror `EtiquetteRepository`) ← (verify: lazy cache, getById hit/miss, error propagation match spec)

## 3. Presentation layer

- [x] 3.1 Create `app/lib/features/format_guide/presentation/format_guide_list_screen.dart` — `ConsumerWidget` watching `formatGuideSectionsProvider`, `PremiumScreenBackground`, loading/error(+retry via `ref.invalidate`)/data states, section tiles with icon + `titleVi` pushing `Routes.formatGuideDetail(id)` (mirror `EtiquetteListScreen`)
- [x] 3.2 Create `app/lib/features/format_guide/presentation/format_guide_detail_screen.dart` — `ConsumerStatefulWidget` caching `getById` future in `didChangeDependencies`; render `titleVi` headline + `bodyVi` body; render `bullets` as an ordered numbered list when non-empty, body-only when empty; loading/error(+back)/not-found(+back) states (mirror `EtiquetteDetailScreen`) ← (verify: numbered bullets render only when non-empty; not-found and error states present)

## 4. Routing

- [x] 4.1 Add `Routes.formatGuide = '/format-guide'` and `Routes.formatGuideDetail(String id) => '/format-guide/$id'` to `app/lib/core/routing/routes.dart`
- [x] 4.2 Register `/format-guide` (list) and `/format-guide/:id` (detail) GoRoutes outside the shell in `app/lib/core/routing/app_router.dart` (mirror etiquette routes)

## 5. Localization

- [x] 5.1 Add `formatGuide_appBar_title`, `formatGuide_error_load`, `formatGuide_btn_retry`, `formatGuide_notFound`, `formatGuide_btn_back` (with `@`-metadata) to `app/lib/l10n/app_en.arb` — app-bar title "Tournament Format"
- [x] 5.2 Add the same keys to `app/lib/l10n/app_vi.arb` — app-bar title "Thể thức giải đấu"
- [x] 5.3 Run `flutter gen-l10n` to regenerate `app_localizations*.dart` ← (verify: generated getters exist, no missing-key errors)

## 6. Entry point

- [x] 6.1 Add a third `_SettingsNavigationTile` to the "Resources & Reference" card in `app/lib/features/settings/presentation/settings_screen.dart` (after Vocabulary and Etiquette), label `l10n.formatGuide_appBar_title`, icon `Icons.emoji_events_outlined`, `onTap` pushes `Routes.formatGuide`

## 7. Tests

- [x] 7.1 Create `app/test/features/format_guide/format_guide_repository_test.dart` — loads sections, getById hit/miss, parses bullets (mirror `rule_card_repository_test.dart`)
- [x] 7.2 Create `app/test/features/format_guide/format_guide_list_screen_test.dart` — renders section tiles and tapping navigates (mirror `rule_cards_screen_test.dart` / vocabulary screen tests)

## 8. Verification

- [x] 8.1 Run `flutter analyze` (no new warnings/errors in scope) from `app/`
- [x] 8.2 Run `flutter test test/features/format_guide/` and confirm green ← (verify: all new tests pass, feature builds cleanly)
