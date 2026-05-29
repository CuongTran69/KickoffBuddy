## 1. Schema & codegen

- [x] 1.1 Add nullable `int? penaltyA` and `int? penaltyB` fields to the `Match` Isar collection in `app/lib/features/matches/data/match.dart`, with doc comments consistent with the existing synced-field block
- [x] 1.2 Regenerate Isar code: `cd app && dart run build_runner build --delete-conflicting-outputs` (updates `match.g.dart`) ← (verify: match.g.dart includes penaltyA/penaltyB, build_runner exits clean)

## 2. Confident match mapping (CRITICAL) + tests

- [x] 2.1 Add a pure top-level helper `findLocalMatchFor(ApiMatch apiMatch, List<Match> locals) → Match?` (place in a shared location reachable by sync and home, e.g. `app/lib/features/matches/application/match_mapping.dart`) implementing same-UTC-day AND either-orientation case-insensitive/trimmed team-name matching per design D1
- [x] 2.2 Rewrite `MatchSyncService.syncScores()` in `app/lib/features/matches/application/match_sync_service.dart` to load all local matches once, use `findLocalMatchFor` for each API match, and update scoreA/scoreB/penaltyA/penaltyB/matchStatus/winner/venueName/attendance only on a confident match; skip otherwise; keep returning the updated count within a write transaction
- [x] 2.3 Write unit tests for `findLocalMatchFor` in `app/test/features/matches/` covering: same-day same-orientation match, swapped-orientation match, case/whitespace differences, same-teams-different-day → null, 2022-API-vs-2026-seed → null ← (verify: mapping rejects mismatched-day data; no fixture corruption path exists)

## 3. Background polling + tests

- [x] 3.1 Add a pure function `pollIntervalFor({required List<ApiMatch> today, required DateTime now}) → Duration?` (in_progress → 5min, else future_scheduled present → 10min, else null) in the polling module under `app/lib/features/matches/application/`
- [x] 3.2 Implement a `MatchPollingController` (Riverpod-exposed) that owns a single `Timer`, fetches today's matches to compute the interval, runs `syncScores()` silently on each tick, re-evaluates the interval after each run, catches+logs poll errors without stopping, and cancels the timer on dispose
- [x] 3.3 Wire a `WidgetsBindingObserver` at the app root (`app/lib/app.dart`) so AppLifecycleState resumed → immediate sync + (re)schedule; paused/inactive/detached → cancel timer; ensure the observer is removed/disposed correctly
- [x] 3.4 Write unit tests for `pollIntervalFor` covering live→5min, scheduled-only→10min, all-completed/empty→null ← (verify: interval logic matches spec; poller self-stops when no live/today matches)

## 4. Localization (ARB) + regen

- [x] 4.1 Add new keys (with `@key` descriptions in `app_en.arb`) to `app/lib/l10n/app_en.arb` and `app/lib/l10n/app_vi.arb` for: home live indicator, home "view detail", home today-matches header; standings empty/error/retry; group card headers (group/team/played/W-D-L/GF:GA/goal-diff/points); match-list sync-error snackbar (with reason placeholder); match-detail status badges (LIVE/FT/scheduled), winner, venue, attendance, penalty label
- [x] 4.2 Regenerate localizations: `cd app && flutter gen-l10n` ← (verify: generated AppLocalizations exposes all new getters; no missing-translation warnings for vi/en)

## 5. UI & provider wiring

- [x] 5.1 Match detail (`app/lib/features/matches/presentation/match_detail_screen.dart`): show large scoreline when scores present, penalty line only when penaltyA/penaltyB non-null and >0, winner, full venueName, attendance, and LIVE/FT/scheduled status badge — all via l10n keys
- [x] 5.2 Group standings card (`app/lib/features/standings/presentation/widgets/group_standings_card.dart`): add W-D-L and GF:GA columns; apply qualifying highlight to ranks 1–2 and a distinct lighter treatment to rank 3 (best-third hint); replace hardcoded headers/labels with l10n keys
- [x] 5.3 Standings provider (`app/lib/features/standings/application/standings_provider.dart`): rethrow genuine network/API errors (drive AsyncError) while returning empty for an empty dataset; stop catching-to-null; fix the stale "A-H" comment to "A-L (12 groups)"
- [x] 5.4 Home screen (`app/lib/features/home/presentation/home_screen.dart`): resolve live/today card taps via `findLocalMatchFor` to a real local matchId and navigate there; if unresolved, disable navigation (no NotFound dead-end); replace hardcoded VN strings ('TRỰC TIẾP', 'Xem chi tiết', 'Trận đấu hôm nay') with l10n keys
- [x] 5.5 Match list (`app/lib/features/matches/presentation/match_list_screen.dart`): replace the hardcoded 'Lỗi khi đồng bộ tỉ số' snackbar with the l10n key (reason placeholder)
- [x] 5.6 Remove the dead `allApiMatchesProvider` from `app/lib/features/matches/application/live_match_provider.dart` and confirm no references remain ← (verify: no dangling imports/usages; analyzer clean)

## 6. Verification

- [x] 6.1 `cd app && flutter analyze` — resolve any new warnings/errors in changed files
- [x] 6.2 `cd app && flutter test` — all unit tests pass, including the new mapping and poll-interval tests ← (verify: full suite green; existing tests unaffected)
