# match-data-store Specification

## Purpose
Defines the local persistence layer for the World Cup 2026 match catalog using Isar, including seeding, CRUD operations, and user match selection storage.

## Requirements

### Requirement: Persist Match catalog locally via Isar

The system SHALL define a `Match` Isar collection matching the schema in `docs/architecture/03-data-model.md`, with indexes on `kickoffAtUtc` (sorted), `tournamentId`, and `isSeeded`. The Isar database MUST be opened asynchronously at app start and exposed via Riverpod.

#### Scenario: Isar opens successfully on first launch

- **WHEN** the app starts and `isarProvider` is read
- **THEN** Isar opens with the `Match` schema in the application documents directory
- **AND** the provider returns a ready `Isar` instance

#### Scenario: Match collection has required indexes

- **WHEN** the Isar database is opened
- **THEN** queries by `kickoffAtUtc` use the sorted index
- **AND** queries filtering by `tournamentId` or `isSeeded` use their respective indexes

### Requirement: Bundle and load 104 WC 2026 matches at first launch

The system SHALL bundle a complete World Cup 2026 fixture catalog (104 matches: 72 group stage + 32 knockouts) as a JSON asset, derived from the openfootball/worldcup repository. On first launch, the seed loader MUST parse the JSON and bulk-insert all matches into Isar.

#### Scenario: First launch loads seed data

- **WHEN** the app starts for the first time after install
- **AND** Isar contains zero matches
- **AND** SharedPreferences key `seed_loaded_v1` is absent
- **THEN** the seed loader parses `assets/data/wc2026_matches.json`
- **AND** bulk-inserts all 104 matches with `isSeeded = true` and `tournamentId = "wc2026"`
- **AND** sets SharedPreferences key `seed_loaded_v1 = true`

#### Scenario: Subsequent launches skip seed

- **WHEN** the app starts and SharedPreferences key `seed_loaded_v1` is present
- **THEN** the seed loader is skipped entirely

#### Scenario: Seed JSON has all required fields per match

- **WHEN** the seed JSON is loaded
- **THEN** every match record contains: `id`, `teamA`, `teamB`, `kickoffAtUtc` (UTC ISO-8601), `sourceTimezone` (IANA), `userTimezone` (IANA), `isSeeded = true`, `tournamentId = "wc2026"`, `worldCupRound`, `venueCity`, `venueIanaTimezone`
- **AND** group-stage matches additionally contain `worldCupGroup` (A-L) and `matchday` (1-3)

#### Scenario: All venue timezones map to valid IANA names

- **WHEN** the seed JSON is parsed
- **THEN** every `venueIanaTimezone` is a valid IANA timezone present in `tz.timeZoneDatabase`

#### Scenario: Total match count is exactly 104

- **WHEN** the seed JSON is parsed
- **THEN** the resulting list contains exactly 104 matches (72 group stage + 32 knockouts)

### Requirement: Match repository provides CRUD operations

The system SHALL expose a `MatchRepository` via Riverpod with methods to read all matches, read by ID, read by group, read by round, upsert, delete, and watch as a reactive stream.

#### Scenario: Get all matches

- **WHEN** the repository's `getAll()` is invoked
- **THEN** it returns a list of all `Match` records currently in Isar

#### Scenario: Get match by ID

- **WHEN** the repository's `getById("match_042")` is invoked and the match exists
- **THEN** it returns the matching `Match` instance

- **WHEN** the repository's `getById("nonexistent")` is invoked
- **THEN** it returns null

#### Scenario: Get matches filtered by group

- **WHEN** the repository's `getByGroup("A")` is invoked
- **THEN** it returns all matches with `worldCupGroup = "A"` (excludes knockout matches)

#### Scenario: Get matches filtered by round

- **WHEN** the repository's `getByRound("group_stage")` is invoked
- **THEN** it returns all 72 group-stage matches

- **WHEN** the repository's `getByRound("final")` is invoked
- **THEN** it returns the single final match

#### Scenario: Upsert custom match

- **WHEN** the repository's `upsert(match)` is invoked with a Match that has `isSeeded = false` and a new ID
- **THEN** the match is inserted into Isar
- **AND** is retrievable by `getById(match.id)`

- **WHEN** the repository's `upsert(match)` is invoked with an existing ID
- **THEN** the existing record is replaced with the new one

#### Scenario: Delete user-created match

- **WHEN** the repository's `delete("user_match_001")` is invoked
- **THEN** the match is removed from Isar
- **AND** subsequent `getById` returns null

#### Scenario: Watch all matches reactive stream

- **WHEN** a consumer subscribes to `watchAll()`
- **AND** any match is added, modified, or removed
- **THEN** the stream emits an updated list

### Requirement: Persist user's "my matches" selection in SharedPreferences

The system SHALL store the user's selected match IDs as a `Set<String>` in SharedPreferences under key `my_matches`, exposed via a Riverpod provider. This selection MUST be independent of the Isar match catalog and MUST survive app restarts.

#### Scenario: Add match to selection

- **WHEN** the user adds match ID "match_001" to their selection
- **THEN** SharedPreferences key `my_matches` contains "match_001"
- **AND** the `userMatchesProvider` emits an updated set including "match_001"

#### Scenario: Remove match from selection

- **WHEN** the user removes match ID "match_001" from their selection
- **THEN** the set no longer contains "match_001"

#### Scenario: Selection persists across restart

- **WHEN** the user adds matches and the app is restarted
- **THEN** `userMatchesProvider` returns the same set after restart

#### Scenario: Initial state is empty set

- **WHEN** the app starts for the first time after install
- **THEN** `userMatchesProvider` returns an empty set

### Requirement: Match collection stores synced penalty scores

The `Match` Isar collection SHALL include nullable integer fields `penaltyA` and `penaltyB` to hold penalty-shootout scores synced from the live API. These fields SHALL be nullable so existing seeded records remain valid without a migration, and SHALL be null for matches that did not go to a shootout or have not been synced.

#### Scenario: Seeded matches load without penalty data
- **WHEN** the seed catalog is loaded into Isar
- **THEN** each seeded match has null `penaltyA` and null `penaltyB`
- **AND** loading succeeds without a schema migration

#### Scenario: Synced shootout populates penalty fields
- **WHEN** score sync updates a match whose API data includes home penalties 4 and away penalties 3
- **THEN** the match's `penaltyA` is 4 and `penaltyB` is 3

#### Scenario: Non-shootout match keeps null penalties
- **WHEN** score sync updates a match whose API penalty values are 0
- **THEN** the penalty fields are not treated as a shootout result by the UI
