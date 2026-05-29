## ADDED Requirements

### Requirement: Browse seeded match catalog with date grouping

The system SHALL display all 104 World Cup 2026 matches grouped by date in the user's local timezone, with sections in this order: Today, Tomorrow, This Week, Later, Past. Group ordering MUST place upcoming matches before past matches.

#### Scenario: User opens match list with all seeded matches present

- **WHEN** the user navigates to `/matches` and the seed loader has populated the Isar catalog
- **THEN** the screen renders all 104 matches grouped by their kickoff date in the user's IANA timezone
- **AND** sections appear in order: Today, Tomorrow, This Week (next 7 days excluding Today/Tomorrow), Later, Past

#### Scenario: Match falls into "Today" only when kickoff date matches user-local current date

- **WHEN** the user is in `Asia/Ho_Chi_Minh` and a match has `kickoffAtUtc = 2026-06-11T17:00:00Z`
- **THEN** the match appears under "Today" if user-local date is 2026-06-12 (kickoff at 00:00 local)
- **AND** the match appears under "Past" if user-local date is 2026-06-13 or later

#### Scenario: List is empty

- **WHEN** Isar contains zero matches (regression-only state — never expected in production)
- **THEN** the screen shows an empty state with illustration and message "No matches yet"

#### Scenario: List fails to load

- **WHEN** the repository throws while fetching matches
- **THEN** the screen shows an error state with the error message and a "Retry" button
- **AND** tapping "Retry" re-invokes the load

### Requirement: Filter match list by stage

The system SHALL provide three filter chips on the match list — All, Group Stage, Knockouts — with All selected by default. Selecting a chip MUST update the visible matches without changing the date grouping behavior.

#### Scenario: User filters to Group Stage

- **WHEN** the user taps "Group Stage" chip
- **THEN** only matches with `worldCupRound = "group_stage"` remain visible
- **AND** date sections that become empty after filtering are hidden

#### Scenario: User filters to Knockouts

- **WHEN** the user taps "Knockouts" chip
- **THEN** only matches with `worldCupRound IN ("round_of_32", "round_of_16", "quarter_final", "semi_final", "third_place", "final")` remain visible

#### Scenario: User returns to All

- **WHEN** the user taps "All" chip after filtering
- **THEN** all matches become visible again

### Requirement: Display match card with team info, kickoff time, and venue

Each match card on the list SHALL display: home team flag and Vietnamese name, "vs" separator, away team flag and Vietnamese name, kickoff time in user's local timezone (formatted as `EEE, MMM d • HH:mm`), group letter badge for group-stage matches, and venue city. Flags SHALL be rendered from the team's ISO alpha-2 code.

#### Scenario: Group-stage match card

- **WHEN** rendering a match with `worldCupRound = "group_stage"` and `worldCupGroup = "A"`
- **THEN** the card shows both team flags, both team Vietnamese names, formatted local kickoff time, "Group A" badge, and venue city

#### Scenario: Knockout match card

- **WHEN** rendering a match with `worldCupRound = "round_of_16"` (or any non-group round)
- **THEN** the card shows team flags, names, time, venue, and a round-name badge ("Round of 16") instead of a group badge

#### Scenario: Tap card navigates to detail

- **WHEN** the user taps any match card
- **THEN** the app navigates to `/matches/<match-id>`

### Requirement: View match detail with timezone-aware kickoff and metadata

The system SHALL provide a `/matches/:id` detail screen showing both team flags and Vietnamese names prominently, kickoff time in the user's local timezone with day-of-week, venue city, group letter, round name, matchday number for group-stage matches, and any user notes.

#### Scenario: User views detail of seeded match

- **WHEN** the user navigates to `/matches/match_001`
- **THEN** the screen shows team flags, VN names, kickoff time in user TZ with day-of-week, venue city, "Group A", and "Matchday 1"

#### Scenario: Detail screen for non-existent match

- **WHEN** the user navigates to `/matches/nonexistent_id`
- **THEN** the screen shows an error state "Match not found" with a "Back to matches" button

### Requirement: Add and remove matches from "my matches" selection

The system SHALL allow the user to toggle a match into a personal "my matches" list, persisted independently of the seed catalog. The toggle button on the detail screen MUST reflect the current selection state.

#### Scenario: User adds match to "my matches"

- **WHEN** the user taps "Add to my matches" on a match detail screen
- **THEN** the match ID is added to the SharedPreferences set `my_matches`
- **AND** the button label changes to "Remove from my matches"

#### Scenario: User removes match from "my matches"

- **WHEN** the user taps "Remove from my matches" on a match they previously added
- **THEN** the match ID is removed from the SharedPreferences set
- **AND** the button label changes to "Add to my matches"

#### Scenario: "My matches" survives app restart

- **WHEN** the user adds a match, closes the app, and reopens it
- **THEN** the match remains in the user's selection

### Requirement: Show disabled placeholder buttons for Sprint 3 features

The match detail screen SHALL show "Set reminder" and "Plan replay" buttons in a disabled state with tooltips explaining they will be available in Sprint 3.

#### Scenario: User taps disabled "Set reminder" button

- **WHEN** the user taps the disabled "Set reminder" button
- **THEN** a tooltip or snackbar shows "Coming in Sprint 3"

### Requirement: Manually add a custom match via form

The system SHALL provide a `/matches/add` form-based screen with fields for home team, away team, kickoff date, kickoff time, venue (optional), and notes (optional). The form MUST validate input before allowing save and persist the resulting match with `isSeeded = false`.

#### Scenario: Successful manual add

- **WHEN** the user fills home="USA", away="Mexico", date=2026-06-15, time=20:00, venue="Estadio Azteca"
- **AND** taps Save
- **THEN** a new Match is persisted with `isSeeded = false`, generated UUID, `kickoffAtUtc` derived from local datetime → UTC, `sourceTimezone = userTimezone = user's IANA TZ`
- **AND** the screen returns to `/matches` with snackbar "Match added"

#### Scenario: Same team for home and away blocks save

- **WHEN** the user enters identical text for home and away team
- **THEN** the form shows inline error "Home and away teams must differ"
- **AND** the Save button is disabled

#### Scenario: Past date blocks save

- **WHEN** the user picks a date earlier than today
- **THEN** the date picker rejects the selection or the form shows inline error "Kickoff date must be today or later"
- **AND** the Save button is disabled

#### Scenario: Empty required fields block save

- **WHEN** any of home team, away team, kickoff date, or kickoff time is empty
- **THEN** the Save button is disabled

#### Scenario: Save fails on Isar error

- **WHEN** the repository upsert throws (rare)
- **THEN** an inline error message appears with a Retry button
- **AND** form values are preserved

### Requirement: Magic Add Lite parses pasted match snippet via regex

The system SHALL provide a `/matches/magic-add` screen with a large multiline TextField, "Paste from clipboard" button, and "Parse" button. The parser SHALL extract teams, date, time, and timezone using explicit regex grammar without any network call. After successful parse, a confirmation screen MUST display the parsed result with options to Edit or Save.

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

### Requirement: Edit and delete user-created matches only

The match detail screen SHALL show Edit and Delete buttons only when `isSeeded = false`. Seeded matches MUST NOT be editable or deletable from the UI.

#### Scenario: Edit button hidden on seeded match

- **WHEN** the user views a match with `isSeeded = true`
- **THEN** Edit and Delete buttons are not rendered

#### Scenario: Delete custom match

- **WHEN** the user taps Delete on a match with `isSeeded = false` and confirms
- **THEN** the match is removed from Isar
- **AND** the user navigates back to `/matches`

### Requirement: Routes registered in app router

The app router SHALL register four new routes that map to their respective screens.

#### Scenario: Routes resolve to correct screens

- **WHEN** the app router is configured
- **THEN** `/matches` maps to `MatchListScreen`
- **AND** `/matches/:id` maps to `MatchDetailScreen` with the path parameter
- **AND** `/matches/add` maps to `ManualAddMatchScreen`
- **AND** `/matches/magic-add` maps to `MagicAddScreen`
- **AND** the home screen provides navigation into `/matches`
