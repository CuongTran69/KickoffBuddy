## ADDED Requirements

### Requirement: Settings screen displays unofficial-app disclaimer
The system SHALL display an "About" card at the bottom of the Settings screen containing a disclaimer that Kickoff Buddy is an unofficial fan app not affiliated with FIFA or any football federation.

#### Scenario: Disclaimer visible in Settings
- **WHEN** the user navigates to the Settings screen
- **THEN** an "About" card is visible at the bottom of the list
- **AND** the card contains the text "Kickoff Buddy is an unofficial fan app and is not affiliated with FIFA or any football federation." (or the localized equivalent)

#### Scenario: Disclaimer text is localized
- **WHEN** the app language is set to Vietnamese
- **THEN** the disclaimer text is displayed in Vietnamese
- **WHEN** the app language is set to English
- **THEN** the disclaimer text is displayed in English
