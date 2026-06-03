## Context

KickoffBuddy is a Flutter app (Riverpod + go_router + Isar + flutter_local_notifications, ARB-based i18n with Vietnamese default / English fallback). A code review surfaced correctness, data-integrity, maintainability, localization, and accessibility issues. This change fixes all of them without altering the app's feature set, dependencies, or storage schema. The work is cross-cutting (10+ feature folders plus core theme/network), which is why it warrants a design doc to lock decisions before coding.

## Goals / Non-Goals

**Goals:**
- Fix correctness defects: Magic Add day-bounds, swallowed network errors, raw exceptions in UI, non-atomic replay-plan writes, fire-and-forget async init, unbounded GlobalKey growth, fire-and-forget prefs write.
- Prevent duplicate notifications from double-tapping async buttons.
- Remove the global mutable singleton in favor of Riverpod.
- Complete localization coverage; replace string-based status dispatch with typed constants.
- Reduce duplication: shared glassmorphism decoration + color constants, generic asset-repository base.
- Name magic numbers and prefs keys; remove dead code; fix accessibility gaps.

**Non-Goals:**
- No new features, no new dependencies, no Isar schema/migration changes, no network/API contract changes.
- No redesign of navigation structure beyond replacing two `Navigator.push` call sites with `go_router`.
- No change to the confident match-mapping logic (already correct).

## Decisions

**D1 — Network error surfacing via AsyncValue.error.**
`currentMatchesProvider` / `todayMatchesProvider` currently `catch` and `return []`. Remove the catch so the `FutureProvider` resolves to `AsyncError`; the existing `.when(error: ...)` branches in screens render an error state with retry (`ref.invalidate`). Rationale: `AsyncValue` already models loading/error/data — swallowing collapses two distinct states. Alternative (sentinel result type) rejected as redundant with Riverpod's model. The background poller (`match_polling_controller`) keeps its internal catch-and-log because a failed poll must NOT crash polling — that catch is correct and stays.

**D2 — Friendly error copy.** Screens map caught/`AsyncError` exceptions to ARB-sourced messages (e.g. `common_error_network`, `common_error_generic`) instead of interpolating `$e`. Raw exception detail stays in `debugPrint` only.

**D3 — Magic Add day bounds.** Add `day >= 1 && day <= 31` to the M/D and M-D guards (named-month path already constrains via `DateTime` only after month lookup — add the same day guard there). Use a simple 1–31 range, not per-month day counts: `_inferYear` builds `DateTime(year, month, day)` and Dart normalizes 31-in-30-day months; rejecting only 0/32+ matches the existing lenient-but-safe intent and keeps parser behavior predictable. Invalid → return null (parse fails) → UI already handles "could not parse".

**D4 — Duplicate-tap prevention.** Convert reminder sheet + replay dialog save/cancel handlers to track an `_isSaving` bool in their `State`; disable the button and show a progress affordance while the future is in flight, re-enable on completion/error. Rationale: matches Flutter idiom, no extra dependency. Alternative (debounce) rejected — disabling is clearer and also communicates progress.

**D5 — Atomic replay-plan write.** In `ReplayPlannerController.savePlan/cancelPlan`, compute the new values, persist first (build/copy the mutation into the upsert), and only update Notifier state after the await succeeds. If upsert throws, rethrow so the caller's try/catch shows an error and state stays consistent. Do not mutate the shared `Match` instance before the write succeeds.

**D6 — TeamLookupService via Riverpod.** Replace the `static _instance` singleton with a `FutureProvider<TeamLookupService>` that loads the asset once. `main.dart`'s `TeamLookupService.instance.load()` boot call is removed; consumers read the provider. The class keeps its parsing logic but loses the static state. Rationale: testable (overridable), no stale state across hot-restart, consistent with every other service in the app. Provider is kept-alive (not autoDispose) since the data is app-lifetime constant.

**D7 — Match status constants.** Introduce an enum (e.g. `MatchStatus { futureScheduled, inProgress, completed }`) with `fromApi(String)` parsing and use it in home/match widgets. The Isar `Match.matchStatus` field stays `String?` (no schema change); mapping happens at the presentation boundary. `'LIVE'`/`'FT'` display labels become ARB keys. Rationale: avoids schema migration while removing scattered literals; centralizes the API-string contract in one place.

**D8 — Localization.** Add ARB keys to both `app_en.arb` and `app_vi.arb` (with `description` metadata in EN per the naming convention `screen_section_purpose`), regenerate `AppLocalizations` via `flutter gen-l10n` (or build). Controllers that need strings for notifications receive them from the caller (widget with `BuildContext`/`l10n`) rather than reading l10n in the controller layer — notification copy is passed in or resolved where context exists. For reminder offset units (`reminder_scheduler.offsetLabel`), return structured data or accept localized unit strings so the pure function stays testable; chosen approach: pass localized unit labels into `offsetLabel` (keep it pure, no global lookup).

**D9 — Shared styling.** Add the repeated glassmorphism `BoxDecoration` as a factory/helper (e.g. `AppDecorations.glassCard(context)`) and move the duplicated hex colors (`0x33DC2626`, `0x2694A3B8`, etc.) into `AppColors` as named constants. Replace the 5+ copy-paste sites. Keep visual output identical.

**D10 — Generic asset repository.** Extract `BundledJsonRepository<T>` capturing the shared pattern (`List<T>? _cache`, `getAll()` guard, `getById()` firstWhere/catch, asset path + root key + `fromJson` injected). The four repos (etiquette/format_guide/rule_cards/vocabulary) extend or delegate to it. Behavior identical; cache guard preserved. The near-identical `_iconData` string→IconData dispatch becomes one shared helper.

**D11 — Bounded GlobalKeys.** In `vocabulary_screen`, rebuild/prune `_itemKeys` to only the currently-displayed (filtered) items each build, or key by stable item id and clear on filter change so the map cannot grow without bound.

**D12 — Awaited prefs write.** `UserMatchesController._persist` becomes `Future<void>` that awaits `setStringList` and logs/handles a `false`/throw result. Callers (`add`/`remove`/`toggle`) remain fire-safe but the write is observed; on failure, log (state already updated optimistically — acceptable for a local selection set, documented as a conscious tradeoff).

**D13 — Named constants & dead code.** Introduce named constants for list bottom padding, replay pre-fire offset (−5 min), date-picker horizon (5 yr), and prefs keys (`theme_mode`, `locale_code`). Remove unused `RuleLevel.labelVi` and the unread `loading` field path (or wire `loading` into the UI — chosen: wire it into a search progress indicator since a loading affordance is genuinely useful; remove only if wiring is not warranted).

**D14 — Accessibility.** Replace the filter chip `GestureDetector` with a semantics-bearing tappable (`FilterChip`/`InkWell` + `Semantics(selected:)`), resolve vocabulary related-IDs to display term names via the repository, and localize the `'Clear search'` tooltip.

## Risks / Trade-offs

- **Surfacing network errors changes UX** (empty screen → error state). → Mitigation: only on genuine fetch failure; add retry; verify existing `.when` branches handle error without crashing.
- **TeamLookupService refactor touches `main.dart` boot order and all consumers.** → Mitigation: trace all call sites first (`TeamLookupService.instance`), migrate each to provider read; the lookup is read in widgets that already have `ref`.
- **ARB regeneration / key churn.** → Mitigation: add keys to both files, keep naming convention, run `flutter gen-l10n` and the build to confirm no missing-key errors.
- **Status enum at presentation boundary** must handle unknown API strings. → Mitigation: `fromApi` returns a safe default (`futureScheduled`) for unrecognized values, preserving current lenient behavior.
- **Repository base refactor is broad.** → Mitigation: keep public method signatures identical so consumers and tests are unaffected; run the repo tests.
- **Optimistic prefs state on write failure** leaves memory ahead of disk. → Conscious tradeoff for a non-critical local selection; logged, not surfaced.

## Migration Plan

No data migration. Deploy is a normal app build. Rollback = revert the change. After implementation: run `flutter gen-l10n`, `flutter analyze`, and the test suite; fix any missing-key or signature breakage before archive.

## Open Questions

None — all decisions resolved autonomously per existing codebase patterns (autopilot run).
