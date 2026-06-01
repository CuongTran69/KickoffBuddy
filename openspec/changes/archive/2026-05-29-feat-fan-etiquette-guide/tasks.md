## 1. JSON Asset

- [x] 1.1 Create `app/assets/data/etiquette_tips.json` with 7 tips (ids: `no_spoil`, `watch_together`, `explain_rules`, `sports_bar`, `when_to_cheer`, `referee_reactions`, `time_wasting`). Each tip has `id`, `titleVi`, `bodyVi`, `icon` (Material icon name string). Content from `docs/future/03-fan-etiquette.md`. ← (verify: file exists, valid JSON, exactly 7 tips, all 4 fields non-empty on each tip)

## 2. Data Layer

- [x] 2.1 Create `app/lib/features/etiquette/data/etiquette_tip.dart` — immutable `EtiquetteTip` model with `id`, `titleVi`, `bodyVi`, `icon` fields and `fromJson` factory
- [x] 2.2 Create `app/lib/features/etiquette/data/etiquette_repository.dart` — `EtiquetteRepository` with `_cache`, `getAll()`, `getById(String id)` following `RuleCardRepository` pattern. Add `etiquetteRepositoryProvider` (Provider) and `etiquetteTipsProvider` (FutureProvider<List<EtiquetteTip>>) ← (verify: repository compiles, getAll() returns 7 tips, getById returns null for unknown id)

## 3. Routing

- [x] 3.1 Add `static const String etiquette = '/etiquette'` and `static String etiquetteDetail(String id) => '/etiquette/$id'` to `app/lib/core/routing/routes.dart`
- [x] 3.2 Register two GoRoutes in `app/lib/core/routing/app_router.dart` outside the shell: `GoRoute(path: Routes.etiquette, ...)` and `GoRoute(path: '/etiquette/:id', ...)` ← (verify: routes registered outside shell branch, path parameters extracted correctly)

## 4. Presentation

- [x] 4.1 Create `app/lib/features/etiquette/presentation/etiquette_list_screen.dart` — `EtiquetteListScreen` ConsumerWidget using `PremiumScreenBackground`, `Scaffold`, `ListView` of tip tiles. Loading/error/data states. Error state has retry button. Tile tap calls `context.push(Routes.etiquetteDetail(tip.id))`
- [x] 4.2 Create `app/lib/features/etiquette/presentation/etiquette_detail_screen.dart` — `EtiquetteDetailScreen` ConsumerWidget with `ruleId` param. Shows title + scrollable body. Not-found state with back button ← (verify: list screen shows 7 tiles with icon+title, detail screen shows full body, not-found state works, error+retry works)

## 5. i18n

- [x] 5.1 Add to `app/lib/l10n/app_en.arb`: `etiquette_appBar_title` ("Fan Etiquette"), `etiquette_error_load` ("Could not load etiquette tips"), `etiquette_btn_retry` ("Retry"), `etiquette_notFound` ("Tip not found"), `etiquette_btn_back` ("Back")
- [x] 5.2 Add matching Vietnamese strings to `app/lib/l10n/app_vi.arb` ← (verify: all 5 keys present in both ARB files)

## 6. Settings Integration

- [x] 6.1 Add etiquette tile to Settings Resources card

## 7. Analysis Check

- [x] 7.1 Run `flutter analyze --no-fatal-infos` from `app/` and confirm no errors in all new/modified files
