## ADDED Requirements

### Requirement: Fan Etiquette Guide list screen shows 7 tips
The system SHALL provide an `EtiquetteListScreen` accessible from the Settings screen that displays all 7 etiquette tips as tappable tiles. Each tile SHALL show the tip's icon and Vietnamese title. The screen SHALL show a loading indicator while data loads, an inline error state with a retry button if loading fails, and navigate to the detail screen on tile tap.

#### Scenario: List loads successfully
- **WHEN** the user navigates to the Etiquette Guide from Settings
- **THEN** a list of 7 tip tiles is displayed
- **AND** each tile shows an icon and a Vietnamese title
- **AND** the screen title is "Văn hóa xem bóng đá" (vi) / "Fan Etiquette" (en)

#### Scenario: List loading error
- **WHEN** the JSON asset fails to load
- **THEN** an error message is shown with a retry button
- **AND** tapping retry re-attempts loading

#### Scenario: Tap navigates to detail
- **WHEN** the user taps a tip tile
- **THEN** the app navigates to `/etiquette/:id` for that tip

### Requirement: Fan Etiquette Guide detail screen shows full tip body
The system SHALL provide an `EtiquetteDetailScreen` at route `/etiquette/:id` that displays the full Vietnamese body text of the selected tip. The screen SHALL show a not-found state if the tip ID is invalid.

#### Scenario: Detail loads successfully
- **WHEN** the user navigates to `/etiquette/:id` with a valid tip ID
- **THEN** the tip title and full body text are displayed
- **AND** the body text is scrollable

#### Scenario: Invalid tip ID
- **WHEN** the user navigates to `/etiquette/:id` with an unknown ID
- **THEN** a "not found" message is shown with a back button

### Requirement: Settings screen provides entry to Etiquette Guide
The system SHALL add an "Etiquette Guide" navigation tile to the "Resources & Reference" card in the Settings screen. Tapping the tile SHALL navigate to `/etiquette`.

#### Scenario: Etiquette tile visible in Settings
- **WHEN** the user opens the Settings screen
- **THEN** the "Resources & Reference" card contains both a Vocabulary tile and an Etiquette Guide tile

#### Scenario: Tap navigates to list
- **WHEN** the user taps the Etiquette Guide tile in Settings
- **THEN** the app navigates to the Etiquette Guide list screen at `/etiquette`

### Requirement: Etiquette tips are bundled as a JSON asset
The system SHALL bundle 7 etiquette tips in `assets/data/etiquette_tips.json`. Each tip SHALL have an `id`, `titleVi`, `bodyVi`, and `icon` field. The 7 tip IDs SHALL be: `no_spoil`, `watch_together`, `explain_rules`, `sports_bar`, `when_to_cheer`, `referee_reactions`, `time_wasting`.

#### Scenario: All 7 tips present
- **WHEN** `EtiquetteRepository.getAll()` is called
- **THEN** it returns exactly 7 tips
- **AND** each tip has a non-empty `id`, `titleVi`, `bodyVi`, and `icon`

#### Scenario: Get by ID
- **WHEN** `EtiquetteRepository.getById('no_spoil')` is called
- **THEN** it returns the tip with id `no_spoil`
- **WHEN** `EtiquetteRepository.getById('unknown')` is called
- **THEN** it returns `null`
