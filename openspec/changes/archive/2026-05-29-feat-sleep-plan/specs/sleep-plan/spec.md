## ADDED Requirements

### Requirement: Sleep Plan card shown for late-night matches
The system SHALL display a `SleepPlanCard` on the Match Detail screen when the match kickoff time in the user's local timezone falls between 22:00 and 04:59 (inclusive). The card SHALL NOT be shown when the match has already kicked off.

#### Scenario: Late-night match not yet started
- **WHEN** the user opens Match Detail for a match with local kickoff hour >= 22 or < 5
- **AND** the match has not yet kicked off
- **THEN** the `SleepPlanCard` is visible between the match info card and the action buttons

#### Scenario: Daytime match
- **WHEN** the user opens Match Detail for a match with local kickoff hour between 05 and 21 (inclusive)
- **THEN** the `SleepPlanCard` is NOT shown

#### Scenario: Match already kicked off
- **WHEN** the user opens Match Detail for a match whose kickoff time is in the past
- **THEN** the `SleepPlanCard` is NOT shown, regardless of the kickoff hour

### Requirement: Sleep Plan card displays three watch modes
The `SleepPlanCard` SHALL display exactly three modes: Late Watcher, Balanced, and Healthy Replay. Each mode SHALL have a title and a one-line suggestion. All text SHALL be localized in Vietnamese and English.

#### Scenario: Three modes visible
- **WHEN** the `SleepPlanCard` is shown
- **THEN** it contains a "Late Watcher" row with its suggestion text
- **AND** it contains a "Balanced" row with its suggestion text
- **AND** it contains a "Healthy Replay" row with its suggestion text

#### Scenario: Vietnamese locale
- **WHEN** the app language is Vietnamese
- **THEN** all mode titles and suggestion texts are displayed in Vietnamese

#### Scenario: English locale
- **WHEN** the app language is English
- **THEN** all mode titles and suggestion texts are displayed in English

### Requirement: Healthy Replay mode has a Replay Planner CTA
The Healthy Replay mode row SHALL include a button that opens the Replay Planner dialog for the current match. The button SHALL use the same `showReplayPlannerDialog` function used elsewhere in Match Detail.

#### Scenario: User taps Replay Planner CTA
- **WHEN** the user taps the "Set up Replay Planner" button in the Healthy Replay row
- **THEN** the Replay Planner dialog opens for the current match
- **AND** the user can set a replay time as normal

### Requirement: Sleep Plan card displays a medical disclaimer
The `SleepPlanCard` SHALL display a disclaimer at the bottom stating that the suggestions are personal schedule guidance and not medical advice. The disclaimer SHALL be visible without scrolling within the card.

#### Scenario: Disclaimer visible
- **WHEN** the `SleepPlanCard` is shown
- **THEN** a disclaimer text is visible at the bottom of the card
- **AND** the disclaimer text is localized (Vietnamese and English)
- **AND** the disclaimer does NOT use the word "medical advice" in a way that implies the app provides it — it explicitly states it does NOT
