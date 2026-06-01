## ADDED Requirements

### Requirement: ManualAddScreen supports edit mode
The ManualAddScreen SHALL accept an optional `editMatchId` parameter. When `editMatchId` is non-null, the screen SHALL load the existing match from the repository and pre-fill all form fields (home team, away team, date, time, venue, notes) with the match's current values.

#### Scenario: Edit mode loads existing match data
- **WHEN** ManualAddScreen is opened with `editMatchId` set to a valid match ID
- **THEN** the form fields are pre-filled with the match's teamA, teamB, kickoffAtUtc (converted to local date/time), venueCity, and notes

#### Scenario: Edit mode saves as update
- **WHEN** user modifies fields and taps Save in edit mode
- **THEN** the system calls `upsert` with the existing matchId (not a new UUID), preserving the original match's createdAt, isSeeded, and other metadata

#### Scenario: Edit mode shows appropriate title
- **WHEN** ManualAddScreen is in edit mode
- **THEN** the app bar title SHALL display the edit-specific l10n string (e.g., "Edit match") instead of "Add match"

#### Scenario: Match detail edit button navigates correctly
- **WHEN** user taps "Edit" on a user-created match in MatchDetailScreen
- **THEN** the app navigates to ManualAddScreen with `editMatchId` set to that match's ID

### Requirement: Router passes edit parameter to ManualAddScreen
The app router SHALL read an `edit` query parameter from the `/matches/add` route and pass it as `editMatchId` to ManualAddScreen.

#### Scenario: Route with edit parameter
- **WHEN** navigation occurs to `/matches/add?edit=<matchId>`
- **THEN** ManualAddScreen receives `editMatchId` equal to `<matchId>`

#### Scenario: Route without edit parameter
- **WHEN** navigation occurs to `/matches/add` without an edit parameter
- **THEN** ManualAddScreen receives `editMatchId` as null (add mode)
