## Why

The app pulls live World Cup data from the worldcupjson.net free APIs, but the score-sync logic maps API matches to local fixtures by an assumed id format (`match_<paddedId>`) with a team-name fallback. Because the API currently serves 2022 World Cup data (match id=1 is "Qatar vs Ecuador", 2022-11-20) while local fixtures are the static 2026 catalog, this mapping writes wrong scores onto unrelated fixtures and routes live/today cards to non-existent match IDs (NotFound dead-ends). Separately, fetched live data (scores, winner, penalties, venue, attendance, full standings columns) is largely never displayed, several user-facing strings are hardcoded Vietnamese, and there is no automatic refresh — scores only update on manual pull-to-refresh. This change fixes the data-integrity bug and adds the requested background polling so scores refresh on their own while matches are live.

## What Changes

- Replace the fragile id-format match mapping with confident date+team-name matching (same UTC calendar day AND both team names match in either orientation, case-insensitive/trimmed). No confident match → no write, never corrupt a fixture.
- Add a single shared lookup helper used by both `syncScores` and the home live/today cards so navigation resolves to a real local match ID or degrades gracefully (no NotFound dead-end).
- Add lifecycle-aware background polling that silently calls `syncScores()` on an interval: every 5 min when a match is in_progress, every 10 min when matches are scheduled today but none live, and fully stopped otherwise. Pauses on app background, immediate sync on resume, cancels its timer on dispose.
- Add nullable `penaltyA` / `penaltyB` fields to the `Match` Isar collection (**BREAKING** for the generated `match.g.dart` — requires build_runner regen).
- Surface live data on the match detail screen: large scoreline, penalties (when > 0), winner, full venue name, attendance, and a LIVE/FT/scheduled status badge.
- Add W-D-L and GF:GA columns to the group standings card; correct the qualification highlight to reflect WC2026 (top 2 strong-qualify, lighter hint for best-third). Fix the stale "A-H" comment to "A-L".
- Migrate all hardcoded Vietnamese UI strings to ARB (EN + VI) and regenerate localizations.
- Distinguish genuine network errors from empty datasets in the standings provider (surface error vs. show empty state). Remove the dead `allApiMatchesProvider`.

## Capabilities

### New Capabilities
- `live-score-sync`: Robust mapping of live API matches to the local fixture catalog, syncing live data (scores, penalties, status, winner, venue, attendance) into the store, lifecycle-aware background polling, and surfacing that data on the match detail and standings screens.

### Modified Capabilities
- `match-data-store`: The `Match` collection gains nullable `penaltyA`/`penaltyB` fields to hold shootout scores synced from the API.
- `app-localization`: Previously hardcoded Vietnamese UI strings on the home, standings, and match-list surfaces become localized in both EN and VI.

## Impact

- **Code (app/lib)**: `features/matches/application/match_sync_service.dart` (rewritten mapping), new background-poll service + provider under `features/matches/application/`, `features/matches/data/match.dart` + regenerated `match.g.dart`, `features/matches/application/live_match_provider.dart` (remove dead provider, add shared lookup), `features/matches/presentation/match_detail_screen.dart`, `features/home/presentation/home_screen.dart` (card tap resolution), `features/standings/presentation/widgets/group_standings_card.dart`, `features/standings/application/standings_provider.dart`, `app.dart`/`main.dart` (wire lifecycle observer), `lib/l10n/app_en.arb` + `app_vi.arb` (+ generated localizations).
- **Tests (app/test)**: new unit tests for the date+team mapping helper and the poll-interval decision function; existing tests must still pass.
- **Build steps**: `flutter gen-l10n`, `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze`, `flutter test`.
- **Dependencies**: none added. Out of scope: openfootball worldcup.json integration, changing the bundled fixture dataset, push/FCM notifications.
