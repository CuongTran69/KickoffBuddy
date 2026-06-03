## Why

A full code review of the KickoffBuddy Flutter app surfaced 13 WARNING-level issues and several SUGGESTION-level improvements. Several are correctness or data-integrity defects: the Magic Add parser silently produces wrong dates for out-of-range days, network errors are swallowed so users see an empty screen instead of an error, async save buttons allow double-taps that schedule duplicate notifications, and the replay planner mutates persisted objects before a write that may fail (leaving in-memory state inconsistent). The rest degrade maintainability and localization coverage (hardcoded Vietnamese strings bypassing the ARB system, string-based status dispatch, copy-pasted styling, a global mutable singleton outside Riverpod). Fixing these now prevents silent user-facing bugs and stops the duplication from spreading.

## What Changes

- **Magic Add date validation**: reject day values outside 1–31 (matching the existing month 1–12 guard) so malformed input fails to parse instead of silently rolling over to an adjacent month.
- **Network error surfacing**: live/today/standings providers stop swallowing errors into empty lists; errors propagate via `AsyncValue.error` so screens can show an error state with retry, distinct from a genuinely empty result.
- **Friendly error messages**: raw exception `toString()` is no longer shown to users; user-facing failures map to localized messages.
- **Duplicate-notification prevention**: reminder and replay-planner save/cancel actions disable their buttons and show an in-flight state while the async operation runs.
- **Atomic replay-planner save**: `savePlan`/`cancelPlan` no longer mutate the live `Match` before persistence; the write either fully succeeds or leaves state unchanged, and failures surface to the caller.
- **Resilient async init**: fire-and-forget controller initialization handles and surfaces errors instead of leaving the UI stuck in an empty state.
- **TeamLookupService into Riverpod**: replace the hand-rolled global mutable singleton with a Riverpod-managed `FutureProvider` so it is testable and not stale across hot-restart.
- **Bounded GlobalKey usage**: vocabulary screen stops accumulating `GlobalKey`s for items that are no longer visible.
- **Match status constants**: replace scattered `'in_progress'`/`'future_scheduled'`/`'completed'` and `'LIVE'`/`'FT'` string literals with a typed enum/constants.
- **Full localization**: move remaining hardcoded Vietnamese strings (home dashboard, settings section title, reminder/replay notification copy, reminder offset units, spoiler badge, rule-card empty state) into the ARB files.
- **Consistent navigation**: replace `Navigator.push(MaterialPageRoute(...))` call sites with `go_router` navigation used everywhere else.
- **Shared styling**: extract the duplicated glassmorphism `BoxDecoration` and duplicated magic colors into `AppColors` / a shared decoration helper.
- **Persisted write safety**: `UserMatchesController._persist` awaits the SharedPreferences write and handles failure instead of firing and forgetting.
- **Repository deduplication**: extract a generic `BundledJsonRepository<T>` base for the four near-identical asset-backed repositories; collapse duplicated icon-name dispatch and near-identical detail screens.
- **Named constants**: name magic numbers (list bottom padding, replay pre-fire offset, date-picker horizon) and SharedPreferences key literals.
- **Dead code removal**: remove unused `RuleLevel.labelVi` and the unread `loading` field path.
- **Accessibility**: give the filter chip selectable semantics, render resolved vocabulary term names instead of raw IDs, and localize the search clear-button tooltip.

## Capabilities

### New Capabilities
<!-- None — all changes modify existing behavior or are internal quality improvements. -->

### Modified Capabilities
- `live-score-sync`: live/today match data fetch SHALL surface fetch failures as an error state rather than an empty result.
- `match-scheduler`: Magic Add date parsing SHALL reject out-of-range day values instead of rolling over to an adjacent month.
- `match-reminders`: reminder save SHALL prevent duplicate scheduling from repeated taps while a save is in flight.
- `replay-planner`: replay-plan save/cancel SHALL persist atomically and prevent duplicate scheduling from repeated taps.
- `app-localization`: home dashboard, settings resources title, reminder/replay notification copy, reminder offset units, spoiler badge, and rule-card empty state SHALL be sourced from ARB keys.

## Impact

- **Affected code**: `features/matches` (parser, providers, screens, widgets, match status), `features/home`, `features/settings`, `features/reminders`, `features/replay_planner`, `features/standings`, `features/vocabulary`, `features/etiquette`, `features/format_guide`, `features/rule_cards`, `core/theme`, `core/network` (provider error handling).
- **i18n**: new keys added to `app/lib/l10n/app_en.arb` and `app/lib/l10n/app_vi.arb`; regenerated `AppLocalizations`.
- **No new dependencies.** No schema/migration changes. No public API/network contract changes.
- **Tests**: existing unit/widget tests updated where behavior changes (parser rejection cases, provider error propagation); new tests for date bounds and duplicate-tap prevention.
