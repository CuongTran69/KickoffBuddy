## ADDED Requirements

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
