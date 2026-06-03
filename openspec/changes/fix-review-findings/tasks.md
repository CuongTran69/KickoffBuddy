# Implementation Tasks

## 1. Core constants & shared helpers (foundational — do first)

- [x] 1.1 Add named color constants to `core/theme/app_colors.dart` for the duplicated magic hex values (`0x33DC2626`, `0x1FDC2626`, `0x2694A3B8`, `0x1F64748B`, `0xFFDC2626`, `0xFFEF4444`, `0xFFF87171`, etc.) with descriptive names
- [x] 1.2 Add a shared glassmorphism decoration helper (e.g. `AppDecorations.glassCard(context)` or a `GlassCard` widget) in `core/theme/` capturing the repeated `BoxDecoration` (color, border, blur 14, offset (0,6))
- [x] 1.3 Create a `MatchStatus` enum (`futureScheduled`, `inProgress`, `completed`) with `MatchStatus.fromApi(String?)` returning `futureScheduled` for unknown/null values, plus helpers `isLive`/`isCompleted`; place in `features/matches/` (e.g. `data/match_status.dart`)
- [x] 1.4 Add named constants for magic numbers: list bottom padding (floating tabbar), replay pre-fire offset (`Duration(minutes: 5)`), date-picker horizon (5 years) — co-locate each near its usage or in a feature constants file ← (verify: constants are referenced everywhere the literals previously appeared)

## 2. Localization (ARB keys + regen)

- [x] 2.1 Add ARB keys to `app/lib/l10n/app_en.arb` (with `description` metadata, `screen_section_purpose` naming) and `app/lib/l10n/app_vi.arb` for: home dashboard header title/subtitle, all quick-action labels, quick-learn labels+descriptions, settings "Resources & Reference" title, reminder notification title/body, replay notification title/body, reminder offset unit words (day/hour/minute), spoiler badge label, rule-card empty-state message, vocabulary search clear-button tooltip, common error messages (network/generic)
- [x] 2.2 Run `flutter gen-l10n` (or build) to regenerate `AppLocalizations`, `app_localizations_en.dart`, `app_localizations_vi.dart` ← (verify: generated files contain all new keys, no missing-key analyzer errors)

## 3. Magic Add date-bounds fix

- [x] 3.1 In `features/matches/application/magic_add_parser.dart`, add `day >= 1 && day <= 31` guard to the M/D slash path and the M-D dash path (alongside the existing month 1–12 guard); ensure the named-month path also rejects out-of-range days
- [x] 3.2 Update/add unit tests in `app/test/features/matches/magic_add_parser_test.dart` for rejected days (`6/32`, `6-0`, `6/0`) and accepted boundary days (`6/30`, `1/1`, `1/31`) ← (verify: out-of-range day produces no date — no silent rollover; boundary days parse correctly)

## 4. Network error surfacing + friendly messages

- [x] 4.1 In `features/matches/application/live_match_provider.dart`, remove the `catch → return []` swallowing in `currentMatchesProvider` and `todayMatchesProvider` so errors propagate as `AsyncError` (keep `debugPrint` only if rethrowing)
- [x] 4.2 Confirm `match_polling_controller` keeps its internal catch-and-log (poll must not crash polling) — no change needed beyond verifying it does not depend on the providers returning `[]` on error
- [x] 4.3 Update consuming screens to render an error state with a retry action for the live/today providers where they are consumed (e.g. home live/today sections), using localized messages
- [x] 4.4 Replace raw `'$e'` / `e.toString()` user-facing text with localized messages in `magic_add_screen.dart:299`, `manual_add_screen.dart:203`, `home_screen.dart:51`, `standings_screen.dart:128` (keep raw detail in `debugPrint`) ← (verify: no screen interpolates a raw exception into visible text; error states show localized copy + retry)

## 5. Duplicate-tap prevention (reminders + replay)

- [x] 5.1 In `features/reminders/presentation/reminder_sheet.dart`, add an `_isSaving` state flag; disable the Save button and show in-progress affordance while the save future runs; re-enable on completion/error
- [x] 5.2 In `features/replay_planner/presentation/replay_planner_dialog.dart`, add in-flight disabled state for both Save and Cancel actions ← (verify: repeated taps during an in-flight save schedule only one set of notifications; control re-enables after failure)

## 6. Atomic replay-plan save/cancel

- [x] 6.1 In `features/replay_planner/application/replay_planner_controller.dart`, refactor `savePlan` to persist via repository upsert FIRST, then update exposed Notifier state only on success; do not mutate the shared `Match` before the write; rethrow on failure so the dialog shows an error
- [x] 6.2 Refactor `cancelPlan` the same way (persist cleared plan first, update state on success, surface failure) ← (verify: on upsert failure, exposed state is unchanged and error surfaces; no permanently-mutated in-memory match)

## 7. Resilient async init

- [x] 7.1 In `features/reminders/application/reminder_controller.dart`, handle errors from the fire-and-forget `_loadInitial` (catch + surface/log so UI is not silently stuck)
- [x] 7.2 In `features/replay_planner/application/replay_planner_controller.dart`, handle errors from its `_loadInitial`
- [x] 7.3 In `features/vocabulary/application/vocabulary_search_controller.dart`, handle errors from `_loadAll`

## 8. TeamLookupService → Riverpod

- [x] 8.1 Refactor `features/matches/application/team_lookup_service.dart`: remove the static `_instance`/`get instance` singleton and `_loaded` static state; keep parsing logic in an instance method/factory
- [x] 8.2 Provide it via a kept-alive `FutureProvider<TeamLookupService>` that loads the asset once
- [x] 8.3 Remove `TeamLookupService.instance.load()` from `main.dart`; migrate all consumers (find via grep `TeamLookupService.instance`) to read the provider ← (verify: no remaining references to the old singleton; all call sites resolve through Riverpod)

## 9. Match status constants adoption

- [x] 9.1 Replace scattered status string-literal comparisons in `features/home/presentation/home_screen.dart` (status pill logic ~lines 1226/1252/1274/1289/1308) and any match widgets with `MatchStatus.fromApi` + enum comparisons
- [x] 9.2 Replace hardcoded `'LIVE'`/`'FT'` display labels with ARB keys ← (verify: no remaining bare status string literals in presentation; unknown status falls back to scheduled)

## 10. Bounded GlobalKeys + accessibility

- [x] 10.1 In `features/vocabulary/presentation/vocabulary_screen.dart`, prune/rebuild `_itemKeys` so only currently-displayed (filtered) items retain keys (no unbounded growth)
- [x] 10.2 In `features/vocabulary/presentation/widgets/vocabulary_tile.dart`, resolve related-term IDs to display term names via the repository instead of rendering the raw ID
- [x] 10.3 In `features/vocabulary/presentation/widgets/vocabulary_search_bar.dart`, localize the `'Clear search'` tooltip via ARB
- [x] 10.4 In `features/matches/presentation/widgets/filter_chips.dart`, replace the bare `GestureDetector` with a semantics-bearing selectable (e.g. `InkWell` + `Semantics(selected:, button:)` or `FilterChip`) ← (verify: screen reader announces selectable + selected state)

## 11. go_router navigation consistency

- [x] 11.1 In `features/matches/presentation/magic_add_screen.dart:306`, replace `Navigator.push(MaterialPageRoute(...))` to ManualAddScreen with go_router navigation passing the prefill params (use query params or extra)
- [x] 11.2 In `features/matches/presentation/match_detail_screen.dart:367`, ensure the edit route uses go_router with safely-encoded params (use `Uri`/`extra` rather than raw string interpolation) ← (verify: navigation uses go_router; params are URL-safe)

## 12. Awaited prefs write

- [x] 12.1 In `features/matches/application/user_matches_provider.dart`, make `_persist` await `setStringList` and handle a `false`/throw result (log on failure); keep optimistic state update (documented tradeoff)

## 13. Repository deduplication (SUGGESTION)

- [x] 13.1 Create a generic `BundledJsonRepository<T>` base capturing: `List<T>? _cache`, `getAll()` cache guard, `getById()` firstWhere/catch, injected asset path + JSON root key + `fromJson`
- [x] 13.2 Refactor `etiquette`, `format_guide`, `rule_cards`, `vocabulary` repositories to use the base while keeping identical public method signatures
- [x] 13.3 Extract the duplicated `_iconData(String)` icon-name→IconData dispatch (etiquette + format_guide list screens) into one shared helper ← (verify: repository public APIs unchanged; existing repo tests pass)

## 14. Named-constant adoption for prefs keys + dead code

- [x] 14.1 In `features/settings/application/settings_providers.dart`, extract `'theme_mode'` and `'locale_code'` literals to named constants used by both read and write paths
- [x] 14.2 Remove dead code: unused `RuleLevel.labelVi` in `features/rule_cards/application/rule_cards_controller.dart`
- [x] 14.3 Wire the `vocabulary_search_controller` `loading` field into a search progress indicator in the UI, OR remove it if no indicator is warranted (choose wiring per design D13)

## 15. Glassmorphism + color constant adoption

- [x] 15.1 Replace the duplicated `BoxDecoration` in `etiquette_list_screen.dart`, `format_guide_list_screen.dart`, `vocabulary_tile.dart`, `rule_card_tile.dart`, `settings_screen.dart` with the shared helper/widget from 1.2
- [x] 15.2 Replace duplicated magic colors in `match_detail_screen.dart` and `match_card.dart` (and home live hero card raw error colors) with the `AppColors` constants from 1.1 ← (verify: visual output unchanged; no remaining duplicated hex literals)

## 16. Verification

- [x] 16.1 Run `flutter analyze` and resolve all new warnings/errors
- [x] 16.2 Run `flutter test` and fix any failures introduced by behavior changes (provider error propagation, parser rejection, status enum) ← (verify: full suite green; new parser + duplicate-tap behavior covered by tests)
