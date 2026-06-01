## Why

Sprint 1 delivered the Flutter scaffold (theme, routing, Riverpod, timezone service skeleton, JSON content assets). The app currently shows an onboarding flow followed by a placeholder home screen — there is no actual football functionality yet. Sprint 2 turns Kickoff Buddy into a working match companion by importing the FIFA World Cup 2026 fixture catalog, persisting it locally with Isar, and giving users four ways to interact with matches: browse the seeded list, view match detail, manually add a custom match, or paste-and-parse a match snippet via Magic Add Lite. This sprint also resolves the Sprint 1 deferred `isar_generator` analyzer conflict, unblocking all future Isar-based features.

## What Changes

### Data layer
- Replace placeholder `wc2026_matches.json` (2 sample matches) with full 104-match dataset imported from openfootball/worldcup repo (group stage 72 + knockouts 32) at both `assets/data/wc2026_matches.json` (root) and `app/assets/data/wc2026_matches.json` (bundled).
- Map openfootball static UTC offsets to IANA timezone names per `docs/data/03-team-reference.md` (16 host cities).
- All 48 teams and 16 host cities populated with VN names, flag codes, and venue timezone.

### Persistence
- Define `Match` Isar collection class matching the schema in `docs/architecture/03-data-model.md`, with indexes on `kickoffAtUtc`, `tournamentId`, `isSeeded`.
- Resolve the deferred analyzer-version conflict between `isar_generator` and `riverpod_lint` (try Isar 4.x upgrade first; fall back to dropping `riverpod_lint` if migration cost is high).
- Add `isar_generator`, `custom_lint` to dev_dependencies; run `build_runner` to generate `match.g.dart`.
- Replace `isarProvider` Sprint 1 stub (which throws `UnsupportedError`) with a real `Isar.open([MatchSchema])` returning `FutureProvider<Isar>`.
- First-run seed loader: parse JSON → bulk insert when Isar is empty, gated by SharedPreferences key `seed_loaded_v1`.

### Domain layer
- New `MatchRepository` (Riverpod-exposed via `matchRepositoryProvider`) with CRUD methods: `getAll`, `getById`, `getByGroup`, `getByRound`, `upsert`, `delete`, plus reactive `watchAll` stream.
- New `userMatchesProvider` backed by SharedPreferences `Set<String>` of match IDs (independent of seed catalog).

### Presentation layer
- New routes: `/matches`, `/matches/:id`, `/matches/add`, `/matches/magic-add`. Home screen replaced with redirect or CTA into `/matches`.
- `MatchListScreen`: filter chips (All / Group Stage / Knockouts), sections grouped by date in user's local timezone (Today / Tomorrow / This Week / Later / Past), match card with team flags, VN names, kickoff time local, group badge, venue city. Loading / empty / error / success states.
- `MatchDetailScreen`: full match info, "Add to / Remove from my matches" toggle, disabled placeholder buttons for Reminders + Replay Planner (Sprint 3), Edit/Delete only for user-created matches.
- `ManualAddMatchScreen`: form with home team, away team, kickoff date, kickoff time, venue, notes; inline validation, save persists to Isar with `isSeeded=false`.
- `MagicAddScreen`: paste box, clipboard import button (with permission fallback), regex parser for teams/date/time/timezone, confirmation screen, partial-parse fallthrough to manual add with prefilled fields.

### Tests
- Unit tests for timezone conversion, Magic Add Lite parser, Match repository CRUD.
- Widget tests for match list grouping and manual add form validation.

### Out of scope (deferred)
- Reminders / local notifications (Sprint 3).
- Replay Planner UI (Sprint 3).
- LLM-based Magic Add (Phase 2).
- Calendar export, share, score tracking, push backend.

## Capabilities

### New Capabilities
- `match-scheduler`: Browse, add, and edit matches with timezone-aware display. Covers list view, detail view, manual creation, and Magic Add Lite parsing flow.
- `match-data-store`: Local persistence of match catalog via Isar, JSON seed loader, repository-level CRUD, and SharedPreferences-backed "my matches" selection.

### Modified Capabilities
- None. Sprint 1 was scaffold-only with no spec-level capabilities yet.

## Impact

### Affected code
- `app/pubspec.yaml` — dependency changes (Isar version, add `isar_generator` + `custom_lint`).
- `app/lib/core/storage/isar_provider.dart` — replace UnsupportedError stub with real implementation.
- `app/lib/core/routing/app_router.dart` + `routes.dart` — 4 new routes.
- `app/lib/features/home/presentation/home_screen.dart` — redirect or CTA into matches.
- `app/lib/features/matches/` — new feature directory (data, application, presentation layers).
- `app/test/` — new unit + widget test files.

### Data files
- `assets/data/wc2026_matches.json` (root, content authoring source).
- `app/assets/data/wc2026_matches.json` (bundled, build target).

### Build pipeline
- `build_runner` becomes a required step (`dart run build_runner build --delete-conflicting-outputs`) to generate `match.g.dart` before `flutter analyze`.

### Dependencies
- Isar version may bump to 4.x (depending on analyzer-conflict resolution path).
- `isar_generator`, `custom_lint` added to dev_dependencies.

### No external systems
- All data is bundled / local. No backend, no API calls.
