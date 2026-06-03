## ADDED Requirements

### Requirement: Live and today match providers distinguish error from empty

The providers that fetch currently-live matches and today's matches SHALL surface a genuine network or API error as an error state (so the screen shows its error UI with a retry action), and SHALL return an empty list only for a legitimately empty dataset (so the screen shows its empty state). These providers SHALL NOT collapse network errors into an empty success value. The background polling controller is exempt: a failed poll SHALL be caught and logged so that periodic polling continues uninterrupted.

#### Scenario: Live match fetch error surfaces as error state
- **WHEN** the `/matches/current` request fails with a network/API error
- **THEN** the live-match provider yields an error
- **AND** the consuming screen shows its error UI with a retry action

#### Scenario: Today match fetch error surfaces as error state
- **WHEN** the `/matches/today` request fails with a network/API error
- **THEN** the today-match provider yields an error
- **AND** the consuming screen shows its error UI with a retry action

#### Scenario: Empty live result surfaces as empty state
- **WHEN** the `/matches/current` request succeeds but contains no matches
- **THEN** the provider yields an empty list and the screen shows its empty state (not an error)

#### Scenario: Background poll error does not stop polling
- **WHEN** a background poll's fetch fails
- **THEN** the error is caught and logged
- **AND** the next poll is still scheduled per the polling interval rules

### Requirement: User-facing fetch failures show friendly messages

When a screen renders an error state for a failed fetch, the system SHALL display a localized, user-friendly message and SHALL NOT display a raw exception `toString()`. Raw exception detail MAY be logged via debug logging only.

#### Scenario: Standings error shows friendly localized text
- **WHEN** the standings screen enters its error state due to a fetch failure
- **THEN** the screen shows a localized error message (not the raw exception string)

#### Scenario: Home next-match error shows friendly localized text
- **WHEN** the home screen's next-match section enters its error state
- **THEN** the screen shows a localized error message (not the raw exception string)

## MODIFIED Requirements

### Requirement: Match detail surfaces live data

The match detail screen SHALL display live data when present on the match: a prominent scoreline (`scoreA` – `scoreB`) when both scores are non-null; a penalty line (e.g. "pen scoreA–scoreB") only when `penaltyA` and `penaltyB` are both non-null and at least one is greater than zero; the `winner` when present; the full `venueName` when present; the `attendance` when present; and a status badge reading LIVE for `in_progress`, FT for `completed`, or a scheduled indicator otherwise. The API status string SHALL be interpreted through a single typed status representation (a `MatchStatus` enum with a `fromApi` parser) rather than scattered string-literal comparisons; an unrecognized status SHALL map to the scheduled (default) state. All newly displayed labels, including the LIVE and FT badges, SHALL derive from localization keys.

#### Scenario: Completed match shows score, winner, FT badge
- **WHEN** a match has scoreA 2, scoreB 1, status "completed", winner "Mexico"
- **THEN** the detail screen shows "2 – 1", the winner, and an FT badge

#### Scenario: Live match shows LIVE badge
- **WHEN** a match has status "in_progress" with a current score
- **THEN** the detail screen shows the score and a LIVE badge

#### Scenario: Penalty line only when penalties occurred
- **WHEN** a match has penaltyA 4 and penaltyB 3
- **THEN** the detail screen shows a penalty line
- **WHEN** a match has penaltyA 0 and penaltyB 0 (or null)
- **THEN** no penalty line is shown

#### Scenario: Scheduled match shows no score
- **WHEN** a match has null scores and status not yet played
- **THEN** the detail screen shows scheduling info and no scoreline

#### Scenario: Unrecognized status maps to scheduled
- **WHEN** a match has a status string not in {future_scheduled, in_progress, completed}
- **THEN** the status is treated as the scheduled (default) state and no LIVE/FT badge is shown
