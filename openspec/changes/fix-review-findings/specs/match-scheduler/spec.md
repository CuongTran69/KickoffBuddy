## MODIFIED Requirements

### Requirement: Magic Add Lite parses pasted match snippet via regex

The system SHALL provide a `/matches/magic-add` screen with a large multiline TextField, "Paste from clipboard" button, and "Parse" button. The parser SHALL extract teams, date, time, and timezone using explicit regex grammar without any network call. The date parser SHALL accept a day value only when it is within the calendar range 1–31 (matching the existing month range guard of 1–12); a numeric date whose day component is 0 or greater than 31 SHALL be rejected (treated as no date parsed) rather than silently rolling over to an adjacent month. After successful parse, a confirmation screen MUST display the parsed result with options to Edit or Save.

#### Scenario: Full successful parse

- **WHEN** the user pastes "USA vs Mexico, June 11, 8 PM ET" and taps Parse
- **THEN** the parser extracts teams=("USA", "Mexico"), date=2026-06-11, time=20:00, tz=`America/New_York`
- **AND** the confirmation screen shows the parsed match
- **AND** tapping Save persists a Match with `isSeeded=false`, `sourceText` set to the original input

#### Scenario: Partial parse falls through to manual add

- **WHEN** the user pastes "USA vs Mexico" (no date/time)
- **AND** taps Parse
- **THEN** the parser extracts teams only
- **AND** the app navigates to `/matches/add` with home and away pre-filled, date/time empty
- **AND** the original paste is preserved as `sourceText` on save

#### Scenario: Failed parse shows feedback

- **WHEN** the user pastes "Hello world" (no recognizable teams)
- **AND** taps Parse
- **THEN** the screen shows feedback "Could not parse — try a format like 'Team A vs Team B, Date, Time TZ'"
- **AND** offers a button "Add manually instead" → navigates to `/matches/add` with fields empty

#### Scenario: Clipboard read denied — fallback to TextField

- **WHEN** the user taps "Paste from clipboard" but the OS denies clipboard access
- **THEN** the screen shows the multiline TextField unchanged with hint "Paste your match here"
- **AND** no error dialog interrupts the flow (per `docs/compliance/02-store-review.md` clipboard fallback)

#### Scenario: Year inference for ambiguous dates

- **WHEN** the parser sees "June 11" with no year
- **AND** today is 2026-05-28 (June 11 is in the future)
- **THEN** the parsed year is 2026

- **WHEN** the parser sees "January 5" with no year
- **AND** today is 2026-05-28 (January 5 is in the past)
- **THEN** the parsed year is 2027

#### Scenario: Out-of-range day in numeric date is rejected

- **WHEN** the user pastes a snippet whose only date token is "6/32" (or "6-0")
- **AND** taps Parse
- **THEN** the parser does not produce a date from that token (no silent rollover to July 2 or May 31)
- **AND** the flow behaves as if no date was parsed (partial/failed parse handling applies)

#### Scenario: Valid boundary days are accepted

- **WHEN** the parser sees a numeric date token "6/30" or "1/1" or "1/31"
- **THEN** the day component is accepted and the date is parsed normally
