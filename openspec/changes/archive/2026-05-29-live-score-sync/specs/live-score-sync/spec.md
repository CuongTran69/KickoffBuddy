## ADDED Requirements

### Requirement: Confident API-to-local match mapping

The system SHALL map an API match to a local catalog match only when BOTH conditions hold: (a) the API match `datetime` and the local match `kickoffAtUtc`, both converted to UTC, fall on the same calendar day (same year, month, day); AND (b) the two team names match in either orientation — `(apiHome == teamA AND apiAway == teamB)` OR `(apiHome == teamB AND apiAway == teamA)` — compared case-insensitively and with surrounding whitespace trimmed. When no local match satisfies both conditions, the system SHALL NOT write any data for that API match. This mapping logic SHALL be implemented in a single shared helper reused by score sync and by navigation.

#### Scenario: Same day and same teams (same orientation) matches
- **WHEN** an API match has datetime on UTC day D with home "Mexico" and away "South Africa"
- **AND** a local match has kickoffAtUtc on UTC day D with teamA "Mexico" and teamB "South Africa"
- **THEN** the helper returns that local match

#### Scenario: Same day and swapped orientation matches
- **WHEN** an API match has home "South Africa" and away "Mexico" on UTC day D
- **AND** a local match has teamA "Mexico" and teamB "South Africa" on UTC day D
- **THEN** the helper returns that local match

#### Scenario: Case and whitespace differences still match
- **WHEN** an API match has home "  mexico " and away "SOUTH AFRICA" on UTC day D
- **AND** a local match has teamA "Mexico" and teamB "South Africa" on UTC day D
- **THEN** the helper returns that local match

#### Scenario: Same teams on a different day does not match
- **WHEN** an API match has the same two teams as a local match but its datetime is on a different UTC calendar day
- **THEN** the helper returns null and no data is written

#### Scenario: 2022 API data does not corrupt 2026 fixtures
- **WHEN** the API returns 2022 matches (e.g. id 1 "Qatar vs Ecuador", 2022-11-20)
- **AND** the local catalog contains only 2026 fixtures
- **THEN** no API match maps to any local match and zero local matches are modified

### Requirement: Sync live data into the local store

The system SHALL fetch all API matches and, for each one that confidently maps to a local match, update that local match's `scoreA`, `scoreB`, `penaltyA`, `penaltyB`, `matchStatus`, `winner`, `venueName`, and `attendance`. The sync operation SHALL return the count of local matches updated and SHALL persist updates within an Isar write transaction.

#### Scenario: Confident match updates live fields
- **WHEN** sync runs and an API match maps confidently to a local match with goals 2–1, status "completed", winner "Mexico"
- **THEN** that local match's scoreA/scoreB/matchStatus/winner are updated accordingly
- **AND** the returned count includes this match

#### Scenario: Penalty scores are persisted
- **WHEN** a confidently mapped API match has home penalties 4 and away penalties 3
- **THEN** the local match's penaltyA is 4 and penaltyB is 3

#### Scenario: Unmapped API matches change nothing
- **WHEN** sync runs and an API match does not map to any local match
- **THEN** no local match is created or modified for that API match

#### Scenario: Empty API response is a no-op
- **WHEN** the API returns an empty match list
- **THEN** sync returns 0 and no local match is modified

### Requirement: Lifecycle-aware background polling of live scores

The system SHALL periodically and silently invoke score sync while relevant matches are active, without blocking the UI or showing a full-screen loading indicator. The polling interval SHALL be determined by a pure function of today's matches and the current time: if any of today's matches is `in_progress`, the interval SHALL be 5 minutes; else if today has at least one `future_scheduled` match, the interval SHALL be 10 minutes; otherwise polling SHALL stop. The poller SHALL pause when the app is not in the foreground, run an immediate sync when the app returns to the foreground, re-evaluate the interval after each run, and cancel its timer when disposed. Errors during a poll SHALL be caught and logged without stopping subsequent polling.

#### Scenario: Live match polls every 5 minutes
- **WHEN** the interval function is given today's matches with at least one `in_progress`
- **THEN** it returns a 5-minute duration

#### Scenario: Scheduled-only today polls every 10 minutes
- **WHEN** the interval function is given today's matches where none is `in_progress` but at least one is `future_scheduled`
- **THEN** it returns a 10-minute duration

#### Scenario: No live or upcoming matches stops polling
- **WHEN** the interval function is given today's matches that are all `completed` (or an empty list)
- **THEN** it returns null and the poller does not schedule a timer

#### Scenario: Polling pauses in background and resumes on foreground
- **WHEN** the app transitions to paused/inactive/detached
- **THEN** the poll timer is cancelled
- **WHEN** the app returns to resumed
- **THEN** an immediate sync runs and the timer is rescheduled per the current interval

#### Scenario: Poll updates surface without blocking UI
- **WHEN** a background poll completes a sync that changes a score
- **THEN** the affected screens reflect the new score via reactive updates
- **AND** no full-screen spinner is shown during the poll

#### Scenario: Poll error does not stop polling
- **WHEN** a poll's sync throws a network error
- **THEN** the error is logged and the next scheduled poll still runs

### Requirement: Match detail surfaces live data

The match detail screen SHALL display live data when present on the match: a prominent scoreline (`scoreA` – `scoreB`) when both scores are non-null; a penalty line (e.g. "pen scoreA–scoreB") only when `penaltyA` and `penaltyB` are both non-null and at least one is greater than zero; the `winner` when present; the full `venueName` when present; the `attendance` when present; and a status badge reading LIVE for `in_progress`, FT for `completed`, or a scheduled indicator otherwise. All newly displayed labels SHALL derive from localization keys.

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

### Requirement: Home live and today cards navigate safely

When the user taps a live or today match card on the home screen, the system SHALL resolve the tapped API match to a local match using the confident mapping helper and navigate to that local match's detail. If no local match resolves, the card SHALL NOT navigate to a non-existent match (no NotFound dead-end).

#### Scenario: Tapping a card with a resolvable match navigates to detail
- **WHEN** the user taps a today/live card whose API match maps to a local match
- **THEN** the app navigates to that local match's detail screen

#### Scenario: Tapping a card with no resolvable match does not dead-end
- **WHEN** the user taps a today/live card whose API match does not map to any local match
- **THEN** the app does not navigate to a NotFound detail screen

### Requirement: Group standings show full statistics

The group standings card SHALL display, for each team, wins, draws, and losses (W-D-L), goals for and goals against (GF:GA), in addition to games played, goal differential, and points. The card SHALL visually distinguish ranks 1–2 as qualifying and SHALL apply a distinct lighter treatment to rank 3 indicating possible advancement (best third-placed teams), reflecting the WC2026 format. All column headers and labels SHALL derive from localization keys.

#### Scenario: Standings row shows W-D-L and GF:GA
- **WHEN** a group standings row is rendered for a team with 2 wins, 1 draw, 0 losses, 5 goals for, 2 against
- **THEN** the row shows W-D-L as 2-1-0 and GF:GA as 5:2

#### Scenario: Top two ranks are highlighted as qualifying
- **WHEN** a group standings card is rendered
- **THEN** ranks 1 and 2 use the qualifying highlight treatment

#### Scenario: Third rank shows possible-advancement treatment
- **WHEN** a group standings card is rendered
- **THEN** rank 3 uses a distinct lighter treatment from ranks 1–2 and ranks 4+

### Requirement: Standings provider distinguishes error from empty

The standings provider SHALL surface a genuine network or API error as an error state (so the screen shows its error UI), and SHALL return an empty result for a legitimately empty dataset (so the screen shows its empty state). The provider SHALL NOT collapse network errors into an empty/null success value.

#### Scenario: Network error surfaces as error state
- **WHEN** the teams request fails with a network/API error
- **THEN** the provider yields an error and the screen shows its error UI with a retry action

#### Scenario: Empty dataset surfaces as empty state
- **WHEN** the teams request succeeds but contains no groups
- **THEN** the provider yields an empty result and the screen shows its empty state
