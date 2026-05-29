## Context

Kickoff Buddy displays a static 2026 World Cup fixture catalog (104 matches, 12 groups A-L) seeded into Isar from `assets/data/wc2026_matches.json`. Live data comes from the worldcupjson.net free APIs (`/matches`, `/matches/today`, `/matches/current`, `/teams`). State is managed with Riverpod; persistence is Isar; localization uses generated ARB (`app_en.arb` template + `app_vi.arb`, `flutter gen-l10n`).

Current constraints / facts established during exploration:
- The live API currently serves **2022** data; the app's fixtures are **2026**. API match `id` is a plain integer.
- Existing `MatchSyncService.syncScores()` maps API→local by `'match_${apiMatch.id.padLeft(3,'0')}'` then a team-name fallback. This is unsafe: it can stamp a 2022 score onto a 2026 fixture, and home cards navigate to `match_<paddedId>` which may not exist.
- `Match` already has `scoreA/scoreB/matchStatus/winner/venueName/attendance`. It lacks penalty fields.
- Live/standings providers are `FutureProvider.autoDispose` that catch errors and return `[]`/`null`, so failures are invisible.

## Goals / Non-Goals

**Goals:**
- Make API→local mapping correct and corruption-proof (date + both team names), with one shared helper reused by sync and navigation.
- Add lifecycle-aware background polling that refreshes scores silently while matches are live/today and stops otherwise.
- Display already-fetched live data (score, penalties, winner, venue, attendance, status) on match detail; add W-D-L and GF:GA to standings.
- Localize all currently-hardcoded Vietnamese strings (EN + VI).
- Make standings error vs. empty distinguishable; remove dead code.

**Non-Goals:**
- Integrating openfootball worldcup.json (static seed is the source of truth).
- Changing the bundled fixture dataset content.
- Push/FCM notifications on score changes.
- Reworking unrelated features (vocabulary, rule cards, replay planner, reminders).

## Decisions

### D1: Confident date+team mapping over id-format mapping
Match an `ApiMatch` to a local `Match` only when **both** hold:
- (a) same UTC calendar day: `apiMatch.datetime.toUtc()` and `match.kickoffAtUtc.toUtc()` share year/month/day;
- (b) team names match in either orientation: `(home==teamA && away==teamB) || (home==teamB && away==teamA)`, compared lowercased + trimmed.

A pure top-level function `findLocalMatchFor(ApiMatch, List<Match>) → Match?` encapsulates this. `syncScores` and the home card tap-handler both call it. If it returns null, sync skips the API match and navigation degrades gracefully.

*Why over alternatives:* id-format coupling is what caused the bug; a names-only match risks cross-day collisions (same teams can meet twice across tournaments); date-only is ambiguous (multiple matches per day). Day+teams is the minimum that is both unique within the 2026 catalog and naturally rejects 2022 data.

### D2: Background polling as a Riverpod-managed, lifecycle-aware service
A `MatchPollingController` (a `Notifier`/`StateNotifier` or plain service exposed via provider) owns a single `Timer`. It is driven by an app-root `WidgetsBindingObserver`:
- On `resumed`: run one immediate `syncScores()` then (re)schedule the timer.
- On `inactive`/`paused`/`detached`: cancel the timer.
- On dispose: cancel the timer (no leaks).

Interval is decided by a **pure** function `pollIntervalFor({required List<ApiMatch> today, required DateTime now}) → Duration?`:
- any `today` match `in_progress` → `Duration(minutes: 5)`;
- else if any `today` match is `future_scheduled` (today has upcoming matches) → `Duration(minutes: 10)`;
- else → `null` (stop polling).

After each tick the controller re-evaluates the interval (so it self-stops when the last match ends). "Silent" = the controller calls `syncScores()` (writes to Isar) and invalidates the relevant providers; the UI updates through existing Isar `watch`/provider reactivity — no spinner, no blocking. Poll errors are caught + logged; the loop continues.

*Why:* a pure interval function is unit-testable without timers; centralizing the timer in one controller with a single observer avoids duplicated lifecycle logic and timer leaks.

### D3: Additive Isar schema change for penalties
Add `int? penaltyA` / `int? penaltyB` to `Match`. Nullable + additive → existing seeded rows remain valid; no migration/version bump needed (Isar tolerates added nullable properties). `match.g.dart` is regenerated via build_runner. `syncScores` writes `homeTeam.penalties`/`awayTeam.penalties` (only meaningful when > 0; UI shows them only when > 0).

### D4: Standings provider — error vs. empty
`getTeams()` returns groups. The provider returns the parsed response on success (possibly empty groups → screen shows empty state) and **rethrows** on a genuine `WorldCupApiException`/network error so `AsyncError` drives the existing error UI. Stop catching-to-null. The screen already has loading/error/empty states wired.

### D5: i18n — ARB keys mirror existing naming
Follow the existing key convention (`home_*`, `matches_*`, `standings_*`, `matchDetail_*`). Add keys for the migrated strings and the new live-data/standings labels to both `app_en.arb` and `app_vi.arb`, then `flutter gen-l10n`. Parameterized messages (e.g. sync error with reason) use ICU placeholders consistent with existing entries.

### D6: Standings qualification highlight
Highlight rank 1–2 as strong-qualify (existing primary color). Add a lighter visual treatment for rank 3 conveying "may advance (best third)" since WC2026 advances top 2 + 8 best third-placed teams. Keep it a subtle style difference with a localized legend/label rather than computing actual best-third tables (out of scope, requires cross-group comparison).

## Risks / Trade-offs

- **API serves 2022 data now → nothing matches → no live updates until 2026** → Acceptable and correct: D1 intentionally rejects mismatched data rather than corrupting fixtures. Once worldcupjson.net serves 2026 with matching dates/names, sync works automatically with no code change.
- **Team-name spelling differences between API and seed** (e.g. "Korea Republic" vs "South Korea") → mapping misses that match → Mitigation: compare normalized (trim+lowercase); document that name normalization can be extended later if real 2026 data reveals mismatches. Missing a match is safe (no write); corrupting one is not.
- **Timer leak / battery drain** → Mitigation: single owned timer, cancel on pause + dispose, self-stop when no live/today matches via D2's null interval.
- **Isar added fields break codegen if build_runner not run** → Mitigation: tasks order regen before any UI work; analyze/test gate catches it.
- **Polling races with manual pull-to-refresh** → both call the same idempotent `syncScores()` writing the same fields by confident key; last write wins with identical data, no corruption.

## Migration Plan

1. Add penalty fields → regen `match.g.dart` (`dart run build_runner build --delete-conflicting-outputs`).
2. Implement mapping helper + rewrite `syncScores` + unit tests (CRITICAL first).
3. Implement poll-interval pure function + polling controller + lifecycle observer + unit tests.
4. Add ARB keys (EN+VI) → `flutter gen-l10n`.
5. UI: match detail live data, standings columns/highlight, home card tap resolution, provider error handling, remove dead provider.
6. `flutter analyze` + `flutter test`.

Rollback: revert the change; nullable schema additions are backward-compatible, so existing seeded data is unaffected.

## Open Questions

None blocking. Team-name normalization depth is deferred until real 2026 API data is available to compare against the seed catalog.
