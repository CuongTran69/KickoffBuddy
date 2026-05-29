## 1. Generate seed data

- [x] 1.1 Write a Python or Dart import script that reads openfootball/worldcup `2026--usa/cup.txt` and `cup_finals.txt`
- [x] 1.2 Map openfootball static UTC offsets to IANA timezone names per `docs/data/03-team-reference.md` 16-host-cities table
- [x] 1.3 For each match, compose full Match JSON record: id, title, teamA, teamB, kickoffAtUtc (UTC ISO-8601), sourceTimezone (IANA), userTimezone (placeholder UTC), reminders=[1440,180,30,5], replayPlannerEnabled=false, replayPlannedAt=null, sourceText=null, notes="", createdAt, isSeeded=true, tournamentId="wc2026", worldCupGroup, worldCupRound, matchday, venueCity, venueIanaTimezone
- [x] 1.4 Write the resulting JSON to `assets/data/wc2026_matches.json` (root) — top-level shape `{"tournament":"FIFA World Cup 2026","version":"1.0.0","lastUpdated":"...","source":"openfootball/worldcup","matches":[...]}`
- [x] 1.5 Copy the same JSON to `app/assets/data/wc2026_matches.json`
- [x] 1.6 Validation: `python3 -c "import json; d=json.load(open('app/assets/data/wc2026_matches.json')); assert len(d['matches'])==104"` returns success
- [x] 1.7 Validation: every match has all required fields per spec; every venueIanaTimezone exists in the IANA database (validate by attempting to resolve via Python `zoneinfo.ZoneInfo` for all 16 distinct city timezones) ← (verify: count == 104, all IANA names valid, group stage = 72 records, knockouts = 32 records, all 48 teams present)

## 2. Resolve isar_generator analyzer conflict

- [x] 2.1 Attempt Isar 4.x upgrade in `app/pubspec.yaml`: bump `isar`, `isar_flutter_libs`, `isar_generator` to 4.x, add `custom_lint`
- [x] 2.2 Run `cd app && /Users/cuongtran/flutter/bin/flutter pub get`
- [x] 2.3 If pub get succeeds → keep Isar 4.x; if it fails with version conflict → revert to Isar 3.x and remove `riverpod_lint` from dev_dependencies (keep `riverpod_generator`); re-run pub get
- [x] 2.4 Document chosen path in a top-of-file comment in `app/lib/core/storage/isar_provider.dart` ← (verify: pub get exits 0, dev_dependencies match the chosen path, no analyzer conflict warnings)

## 3. Define Match Isar collection

- [x] 3.1 Create `app/lib/features/matches/data/match.dart` with `@collection` annotation per Isar 4.x or 3.x syntax (depending on D1 outcome)
- [x] 3.2 Add fields per `docs/architecture/03-data-model.md` Match schema (all 21 fields)
- [x] 3.3 Add `@Index()` for kickoffAtUtc (sorted), tournamentId, isSeeded
- [x] 3.4 Add `worldCupRound` as enum or string with allowed values (group_stage, round_of_32, round_of_16, quarter_final, semi_final, third_place, final)
- [x] 3.5 Run `cd app && dart run build_runner build --delete-conflicting-outputs` — generates `match.g.dart` ← (verify: match.g.dart exists, schema includes all indexes, flutter analyze clean)

## 4. Replace isarProvider stub with real implementation

- [x] 4.1 In `app/lib/core/storage/isar_provider.dart`, remove the UnsupportedError throw
- [x] 4.2 Implement: open Isar with `[MatchSchema]`, directory from `path_provider.getApplicationDocumentsDirectory()`, name "kickoff_buddy"
- [x] 4.3 Provider returns `FutureProvider<Isar>`
- [x] 4.4 Add error handling: if Isar.open throws, propagate the error so AsyncValue surfaces it ← (verify: Isar opens successfully on first run, provider readable in widget tree)

## 5. Seed loader

- [x] 5.1 Create `app/lib/features/matches/data/seed_loader.dart`
- [x] 5.2 Implement `Future<void> loadSeedIfEmpty(Isar isar, SharedPreferences prefs)`: if prefs.getBool('seed_loaded_v1') == true → skip; else parse JSON via `rootBundle.loadString('assets/data/wc2026_matches.json')`, deserialize each match, bulk insert via `isar.writeTxn(() => isar.matches.putAll(...))`, set prefs key
- [x] 5.3 Hook seed loader into app boot — call after Isar opens, before MatchListScreen first reads
- [x] 5.4 Handle parse errors gracefully: log and continue (app still usable, user can manual-add) ← (verify: first launch loads 104 matches into Isar, second launch skips, prefs key set)

## 6. MatchRepository

- [x] 6.1 Create `app/lib/features/matches/data/match_repository.dart`
- [x] 6.2 Implement: `Future<List<Match>> getAll()`, `Future<Match?> getById(String id)`, `Future<List<Match>> getByGroup(String group)`, `Future<List<Match>> getByRound(String round)`, `Future<void> upsert(Match match)`, `Future<void> delete(String id)`, `Stream<List<Match>> watchAll()`
- [x] 6.3 Expose as `final matchRepositoryProvider = FutureProvider<MatchRepository>(...)` that awaits isarProvider then constructs ← (verify: all CRUD methods return correct types and use Isar transactions correctly)

## 7. User matches selection (SharedPreferences)

- [x] 7.1 Create `app/lib/features/matches/application/user_matches_provider.dart`
- [x] 7.2 Implement `userMatchesProvider` as `Provider<UserMatchesController>` (or NotifierProvider) that exposes: `Set<String> selectedIds`, `void add(String id)`, `void remove(String id)`, `void toggle(String id)`, `bool contains(String id)`
- [x] 7.3 Persist to SharedPreferences key `my_matches` as `List<String>` (convert to/from Set)
- [x] 7.4 Initial load: read prefs in constructor; emit empty set if key absent ← (verify: add/remove/toggle work, persists across restart, returns empty set on fresh install)

## 8. Match list screen

- [x] 8.1 Create `app/lib/features/matches/presentation/match_list_screen.dart`
- [x] 8.2 Watch matchRepositoryProvider + filter chip state; render AsyncValue states (loading: CircularProgressIndicator, error: error+retry, success: grouped list)
- [x] 8.3 Implement filter chips: All / Group Stage / Knockouts (default All)
- [x] 8.4 Implement date grouping in user TZ: compute Today / Tomorrow / This Week / Later / Past sections via TimezoneService
- [x] 8.5 Create `widgets/match_card.dart`: home flag + VN name, "vs", away flag + VN name, kickoff in user local time (`EEE, MMM d • HH:mm`), group/round badge, venue city. Tap → push `/matches/:id`
- [x] 8.6 Create `widgets/flag_avatar.dart`: takes ISO alpha-2 code, renders flag via `flag` package; FIFA-code → ISO-alpha-2 lookup from `team_names_vi.json`
- [x] 8.7 Create `widgets/filter_chips.dart` and `widgets/date_section_header.dart`
- [x] 8.8 Empty state widget: illustration + "No matches yet" (defensive — never shown with seed)
- [x] 8.9 Error state widget: error message + Retry button ← (verify: 104 matches render, grouping correct in TZ Asia/Ho_Chi_Minh, filter chips work, tap navigates correctly)

## 9. Match detail screen

- [x] 9.1 Create `app/lib/features/matches/presentation/match_detail_screen.dart`
- [x] 9.2 Read match ID from path parameter; fetch via `getById`
- [x] 9.3 If not found → show "Match not found" + "Back to matches" button
- [x] 9.4 Render: hero with both team flags + VN names, kickoff in user TZ with day-of-week, venue city, group letter (group_stage only), round name, matchday number (group_stage only), notes
- [x] 9.5 "Add to my matches" / "Remove from my matches" toggle button (reads/writes userMatchesProvider)
- [x] 9.6 "Set reminder" button — disabled, with tooltip "Coming in Sprint 3"
- [x] 9.7 "Plan replay" button — disabled, with tooltip "Coming in Sprint 3"
- [x] 9.8 Edit + Delete buttons rendered only when match.isSeeded == false ← (verify: detail shows correct info, toggle persists, disabled tooltips show, edit/delete hidden for seeded matches)

## 10. Manual Add screen

- [x] 10.1 Create `app/lib/features/matches/presentation/manual_add_screen.dart`
- [x] 10.2 Form with: home team (TextField, required, max 50), away team (TextField, required, max 50, must differ from home), kickoff date (showDatePicker, ≥ today), kickoff time (showTimePicker, required), venue (TextField, optional, max 100), notes (multiline TextField, optional, max 500)
- [x] 10.3 Validation: inline errors per field; Save button disabled until all required valid
- [x] 10.4 On Save: build Match with isSeeded=false, generated UUID via `uuid` package or simple unique ID, kickoffAtUtc from local datetime → UTC, sourceTimezone=userTimezone=user's IANA, createdAt=now UTC; call repository.upsert; pop with snackbar "Match added"
- [x] 10.5 Error path: catch upsert exception → show inline error + Retry, preserve form state
- [x] 10.6 Support pre-filling from query parameters (used by Magic Add fallthrough): `home`, `away` ← (verify: form validation rules all enforced, save persists with isSeeded=false, pre-fill query params populate fields)

## 11. Magic Add Lite parser

- [x] 11.1 Create `app/lib/features/matches/application/magic_add_parser.dart`
- [x] 11.2 Define `MagicAddResult` data class: teamA?, teamB?, date?, time?, timezone?, isComplete, originalText
- [x] 11.3 Implement team regex: `^(\S.+?)\s+(?:vs|VS|Vs|@)\s+(.+?)(?:[,]|\s+\d|$)`
- [x] 11.4 Implement date parsing: try Month-DD (June 11), M/D, MM/DD, M-D in order; assume current year, fallback to next year if past
- [x] 11.5 Implement time parsing: `\d{1,2}:?\d{0,2}\s*(?:am|pm|AM|PM)?` — handle "8 PM", "20:00", "8:30pm"
- [x] 11.6 Implement timezone abbreviation lookup: ET→America/New_York, PT→America/Los_Angeles, CT→America/Chicago, MT→America/Denver, GMT→Etc/GMT, UTC→Etc/UTC, BST→Europe/London, CET→Europe/Paris, JST→Asia/Tokyo, ICT→Asia/Ho_Chi_Minh, SGT→Asia/Singapore, AEST→Australia/Sydney, plus 3-4 more common ones
- [x] 11.7 If timezone abbreviation absent → default to user's IANA from TimezoneService

## 12. Magic Add screen

- [x] 12.1 Create `app/lib/features/matches/presentation/magic_add_screen.dart`
- [x] 12.2 UI: AppBar "Magic Add", multiline TextField (5 lines visible), "Paste from clipboard" button, "Parse" button
- [x] 12.3 "Paste from clipboard" → call `Clipboard.getData('text/plain')`. If denied/null → no-op (TextField stays empty, no error popup) per `docs/compliance/02-store-review.md`
- [x] 12.4 "Parse" → call MagicAddParser.parse(text)
- [x] 12.5 If MagicAddResult.isComplete → push confirmation screen showing parsed teams/date/time/tz; on Save → repository.upsert with sourceText=originalText
- [x] 12.6 If partial → navigate to `/matches/add` with query parameters for any extracted fields (e.g., `?home=USA&away=Mexico`)
- [x] 12.7 If complete failure → show inline feedback "Could not parse — try a format like 'Team A vs Team B, Date, Time TZ'" + "Add manually" button → /matches/add ← (verify: full-success → confirm screen → save persists; partial → fallthrough with prefill; failure → helpful feedback; clipboard denied → no error)

## 13. Routing additions

- [x] 13.1 Update `app/lib/core/routing/routes.dart`: add `matches`, `matchDetail`, `matchesAdd`, `matchesMagicAdd` constants
- [x] 13.2 Update `app/lib/core/routing/app_router.dart`: add 4 GoRoute entries with builder functions; for `/matches/:id` extract path parameter via `state.pathParameters['id']`
- [x] 13.3 Update home screen: add CTA button "View matches" → push to /matches OR redirect home → /matches (your call) ← (verify: all 4 routes resolve, deep-link `/matches/match_001` opens detail with correct data)

## 14. Tests

- [x] 14.1 Create `app/test/core/time/timezone_service_test.dart`: UTC↔local conversion (Asia/Ho_Chi_Minh, America/Los_Angeles), DST transition, midnight crossing
- [x] 14.2 Create `app/test/features/matches/magic_add_parser_test.dart`: 15+ cases — full success ("USA vs Mexico, June 11, 8 PM ET"), partial (teams only, date only), failure ("hello world"), edge timezones (ICT for Vietnamese users), 24-hour time, year inference forward + backward
- [x] 14.3 Create `app/test/features/matches/match_repository_test.dart`: in-memory Isar (`Isar.open(directory: '')`), CRUD methods, getByGroup filter, getByRound filter, watchAll stream emission
- [x] 14.4 Create `app/test/features/matches/match_list_screen_test.dart`: widget test verifying date grouping with mock repository (3 matches: today, tomorrow, past)
- [x] 14.5 Create `app/test/features/matches/manual_add_screen_test.dart`: widget test — empty fields disable Save, same team A=B shows inline error, past date shows error
- [x] 14.6 Run `cd app && /Users/cuongtran/flutter/bin/flutter test` — all tests pass ← (verify: every test file runs, total tests pass, coverage of happy + edge paths)

## 15. Final verification

- [x] 15.1 `cd app && /Users/cuongtran/flutter/bin/flutter pub get` exits 0
- [x] 15.2 `cd app && dart run build_runner build --delete-conflicting-outputs` exits 0
- [x] 15.3 `cd app && /Users/cuongtran/flutter/bin/flutter analyze` reports "No issues found"
- [x] 15.4 `cd app && /Users/cuongtran/flutter/bin/flutter test` all pass
- [x] 15.5 `python3 -c "import json; d=json.load(open('/Users/cuongtran/Project/WorldCup/app/assets/data/wc2026_matches.json')); assert len(d['matches'])==104, f'expected 104 got {len(d[\"matches\"])}'"` succeeds ← (verify: all 5 checks pass simultaneously, no warnings outside scope, end-to-end smoke: launch app, navigate /matches, see 104 matches grouped, tap match, see detail)
