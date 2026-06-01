## Context

Sprint 1 delivered a Flutter scaffold with theme, routing, Riverpod, timezone service, onboarding skeleton, and content JSON assets. The `isarProvider` was intentionally stubbed to throw `UnsupportedError` because adding `isar_generator` to dev_dependencies would have triggered an analyzer-version conflict with `riverpod_lint`. No real persistence exists yet, no match data is queryable, and the home screen is a placeholder.

Sprint 2 must turn the app into a working football companion: load a 104-match World Cup 2026 catalog, persist it locally, render it across four interaction surfaces (browse list, match detail, manual add, magic add), and resolve the analyzer-version conflict so all subsequent sprints can use code-gen freely. The data layer is brand-new for the project — every architectural decision here will compound.

### Constraints

- Solo developer, MVP timeline (sprint plan in `docs/product/03-roadmap.md`).
- WC 2026 begins 2026-06-11; the app must be store-submittable before that date.
- Vietnam age rating regulatory deadline is 2026-06-18 (per `docs/product/05-risks.md` Risk 5).
- Must follow the time-handling rule from `docs/architecture/04-time-handling.md`: store UTC, render in user's local IANA timezone, never convert via raw `DateTime`.
- All data is local — no backend, no API calls, no auth (per `docs/architecture/05-backend-strategy.md`).

### Stakeholders

- End users (4 personas defined in `docs/product/01-vision.md`).
- Solo dev (you).
- Future Sprint 3+ work — Reminders, Replay Planner, Rule Cards, Vocabulary all read from this data layer.

## Goals / Non-Goals

**Goals:**

- Persist 104 WC 2026 matches locally with first-run JSON seed.
- Provide CRUD over matches via repository pattern, exposed through Riverpod.
- Render match list grouped by date in user's local timezone with three filter chips.
- Allow user to view match detail, add to "my matches", and create custom matches manually or via Magic Add Lite.
- Resolve `isar_generator` analyzer conflict so code-gen works in this and all future sprints.
- Achieve `flutter analyze` clean and passing test suite for new code.

**Non-Goals:**

- Reminders / local notifications (Sprint 3).
- Replay Planner UI (Sprint 3).
- LLM-based Magic Add (Phase 2 — this sprint is regex-only).
- Live match scores, lineups, or commentary (not in MVP).
- Calendar export, social share, push notifications.
- Light-mode visual polish (Sprint 5).
- Multi-tournament support (only `wc2026` for MVP, but data model is forward-compatible).

## Decisions

### D1: Isar 4.x upgrade vs Isar 3.x with `riverpod_lint` dropped

**Decision: Try Isar 4.x first; fall back to Isar 3.x without `riverpod_lint` if migration cost is high.**

**Rationale:**
- Isar 4.x ships a refactored generator that uses modern `analyzer` versions, eliminating the conflict with `riverpod_lint`.
- Isar 4.x changes some APIs (collection registration, query syntax). If the migration is straightforward (≤1 hour), it is the cleanest long-term path.
- If 4.x migration breaks too many examples in our project (e.g., schema syntax changed substantially), Sprint 2 cannot afford the slip — fall back to 3.x and drop `riverpod_lint` (we keep `riverpod_generator`, which is the actually-needed package; `riverpod_lint` is QOL-only).

**Alternatives considered:**
- Pin analyzer versions: brittle; future package updates will break it.
- Drop both Isar code-gen and riverpod_lint: forces hand-written schema, error-prone, contradicts data-model.md.

**Decision criteria** (apply at implementation time):
- If `flutter pub get` + `dart run build_runner build --delete-conflicting-outputs` succeeds on first try with Isar 4.x → keep 4.x.
- If first attempt fails with non-trivial errors → fall back to Isar 3.x + drop `riverpod_lint` from dev_dependencies, keep `riverpod_generator`.

### D2: "My matches" storage — SharedPreferences set vs Isar field

**Decision: SharedPreferences `Set<String>` of match IDs.**

**Rationale:**
- The seed catalog is read-only by nature — flipping a boolean field on a seeded `Match` row mixes user state with shared catalog state.
- SharedPreferences set keeps user selection completely independent — re-seeding (e.g., schema bump) does not lose user's selections.
- Lighter on first-write performance — toggling a 1-bit set is faster than rewriting an Isar row.
- For Sprint 3 reminders, the reminder system reads from the same set + Isar lookup by ID.

**Alternatives considered:**
- Isar boolean field `isUserSelected`: couples user state to seed data, complicates re-seeding.
- Separate `UserMatch` Isar collection: overkill for an ID list.

### D3: Date grouping uses user's local timezone, not raw UTC

**Decision: Use `TimezoneService` to compute "Today / Tomorrow / This Week / Later / Past" buckets in user's local timezone.**

**Rationale:**
- A match at 2026-06-12T01:00:00Z is "Today" for a user in America/Los_Angeles (still 2026-06-11 evening) but "Tomorrow" for a user in Asia/Ho_Chi_Minh.
- The whole point of the app is timezone-aware viewing. Grouping in UTC defeats that.

**Implementation rule:**
- `MatchListScreen` calls `TimezoneService.toLocal(match.kickoffAtUtc)` to get a `TZDateTime`, then compares to `tz.TZDateTime.now(local).startOfDay()`.

### D4: Magic Add Lite parser is regex-only, not LLM

**Decision: Use a small grammar of explicit regex patterns, no LLM call. Defer LLM-powered Magic Add to Phase 2 per `docs/future/01-magic-add-llm.md`.**

**Rationale:**
- LLM call requires Cloudflare Workers backend (not yet built) and incurs cost.
- Regex covers the 60-70% of common cases ("Team A vs Team B, June 11, 8 PM ET") and falls through to manual add for the rest, which is acceptable MVP UX.
- Pure offline → no network dependency → no permission story for store review.

**Grammar:**
- Teams: `^(\S.+?)\s+(?:vs|VS|Vs|@)\s+(.+?)(?:[,]|\s+\d|$)`
- Date: try in order — `Month DD` (June 11), `M/D` (6/11), `MM/DD` (06/11), `M-D` (6-11). If no year present → assume current year, then if past → next year.
- Time: `\d{1,2}:?\d{0,2}\s*(?:am|pm|AM|PM)?` — accepts "8 PM", "20:00", "8:30pm".
- Timezone: 3-letter abbreviation (`ET|PT|CT|MT|GMT|UTC|BST|CET|JST|ICT|SGT|AEST|...`). Maps to IANA via static lookup table; default to user's local IANA if absent.

**Edge case:** "ET" maps to `America/New_York` (handles EST/EDT automatically via IANA).

### D5: openfootball UTC-offset → IANA mapping happens at import time, not runtime

**Decision: The build-time JSON output stores IANA timezone names (`America/Los_Angeles`), not raw UTC offsets (`UTC-7`). Mapping is done once during the import script.**

**Rationale:**
- IANA names handle DST automatically; static UTC offsets do not.
- Per `docs/data/02-data-sources.md` validation note: "openfootball uses static UTC offsets — these must be mapped to IANA names per `docs/data/03-team-reference.md`."
- Doing this once at import (deterministic, testable) is safer than doing it at every render.

### D6: First-run seed loader gating with SharedPreferences key

**Decision: After bulk-inserting seed matches, set `seed_loaded_v1` in SharedPreferences. Skip seed if key present.**

**Rationale:**
- Lets us bump to `seed_loaded_v2` later if seed data needs refreshing (e.g., final fixtures vs preliminary).
- Idempotent: re-running app does not duplicate seeds.

### D7: Repository depends on Isar provider via FutureProvider

**Decision: `matchRepositoryProvider` is `FutureProvider<MatchRepository>` that awaits `isarProvider`, then constructs the repository.**

**Rationale:**
- Isar opens asynchronously; the repository cannot exist until Isar is ready.
- Riverpod's `AsyncValue` handles loading/error UI states naturally.

### D8: Folder structure feature-first under `features/matches/`

**Decision: Following `docs/architecture/02-folder-structure.md`:**

```
app/lib/features/matches/
├── data/
│   ├── match.dart                    # Isar collection class
│   ├── match.g.dart                  # generated by build_runner
│   ├── match_repository.dart         # Repository pattern
│   └── seed_loader.dart              # First-run JSON → Isar
├── application/
│   ├── match_list_controller.dart    # filter + grouping logic
│   ├── magic_add_parser.dart         # regex grammar
│   └── user_matches_provider.dart    # SharedPreferences-backed Set<String>
└── presentation/
    ├── match_list_screen.dart
    ├── match_detail_screen.dart
    ├── manual_add_screen.dart
    ├── magic_add_screen.dart
    └── widgets/
        ├── match_card.dart
        ├── filter_chips.dart
        ├── date_section_header.dart
        └── flag_avatar.dart
```

## Risks / Trade-offs

- **[Risk] Isar 4.x migration may take longer than estimated** → Mitigation: time-box to 1 hour; if schema/query syntax has changed substantially, fall back to Isar 3.x + drop `riverpod_lint` (D1 fallback). Document the chosen path in code comments.

- **[Risk] openfootball data may have inconsistent venue or team naming** → Mitigation: validation script asserts every match has all required fields and every IANA timezone parses; manual spot-check first 10 matches; if data is partial, fall back to manual entry from FIFA.com for missing fixtures (per `docs/data/02-data-sources.md` fallback).

- **[Risk] Magic Add regex misses common formats users actually paste** → Mitigation: regex grammar is explicit (D4) and covers ~60-70% of formats; failure path falls through to manual add with prefilled fields, never blocks the user; collect parse-failure counts in tests + telemetry (Sprint 5).

- **[Risk] Date grouping in user TZ shows match as "Past" while it's actually upcoming in venue TZ (timezone confusion)** → Mitigation: this is correct behavior — the user wants to know when the match is in their time. Match detail screen shows both kickoff time in user TZ and venue city to disambiguate.

- **[Risk] Bulk insert of 104 matches blocks first-launch UI** → Mitigation: seed loader runs in compute isolate (Isar bulk-write is fast — <100ms for 104 rows on mid-range Android — but worth measuring); gated by SharedPreferences flag so it only runs once.

- **[Risk] SharedPreferences `Set<String>` for "my matches" hits limits with extreme usage (10k+ matches selected)** → Mitigation: WC has 104 matches max; user cannot select more than that. Future tournaments + custom additions could push it but well within SharedPreferences string-list capacity.

- **[Risk] `flutter test` runs Isar collection generation lazily — tests may fail if `match.g.dart` not generated** → Mitigation: tasks.md explicitly lists `build_runner build` as a step before any test runs; CI/local checklist includes the same.

- **[Trade-off] Choosing SharedPreferences for "my matches" means a future migration to per-device-sync (Phase 2) requires careful merging** → Acceptable: user-selection conflict resolution is a Phase 2 concern, not MVP.

- **[Trade-off] `flutter_timezone` package returns IANA names, but on some older Android devices it may return non-IANA strings** → Mitigation: TimezoneService.initialize() validates against `tz.timeZoneDatabase`; falls back to UTC if invalid; logs warning. (Sprint 1 timezone service skeleton already supports this — Sprint 2 just uses it.)

## Migration Plan

This is a green-field feature on top of Sprint 1 scaffold. No existing data to migrate.

**Deploy sequence:**
1. Update pubspec.yaml dependencies.
2. Run `flutter pub get`. If Isar 4.x fails, downgrade to 3.x (drop `riverpod_lint`) and re-run.
3. Generate seed JSON (`assets/data/wc2026_matches.json` + `app/assets/data/wc2026_matches.json`) — done once via Python or Dart import script reading from openfootball.
4. Implement Isar collection + run `build_runner build`.
5. Replace `isarProvider` stub with real implementation.
6. Implement repository + seed loader + user-matches provider.
7. Implement screens + routing.
8. Implement Magic Add parser.
9. Add tests.
10. Run full check suite: `flutter pub get && build_runner build && flutter analyze && flutter test`.

**Rollback:** Sprint 2 lives entirely under new files (`features/matches/`) plus modifications to `isar_provider.dart`, `app_router.dart`, `routes.dart`, `home_screen.dart`, and `pubspec.yaml`. To roll back, revert those specific files. The Sprint 1 scaffold remains intact.

## Open Questions

None. All architectural decisions are locked. Implementation-time decision (D1 fallback) is documented with explicit criteria.
