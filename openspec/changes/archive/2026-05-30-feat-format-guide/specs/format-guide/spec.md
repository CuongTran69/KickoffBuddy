# Format Guide Specification

## ADDED Requirements

### Requirement: Format Guide content model

The system SHALL define an immutable `FormatGuideSection` model with the fields `id` (String), `titleVi` (String), `bodyVi` (String), `icon` (String — a Material icon name), and `bullets` (List of String) which SHALL default to an empty list when absent. The model SHALL provide a `fromJson` factory and SHALL use value equality based on `id`.

#### Scenario: Parse a section with bullets

- **WHEN** `FormatGuideSection.fromJson` is given a JSON object containing `id`, `titleVi`, `bodyVi`, `icon`, and a non-empty `bullets` array
- **THEN** the resulting section exposes all scalar fields and a `bullets` list preserving the JSON order

#### Scenario: Parse a section without bullets

- **WHEN** `FormatGuideSection.fromJson` is given a JSON object with no `bullets` key
- **THEN** the resulting section's `bullets` is an empty list (never null)

#### Scenario: Equality by id

- **WHEN** two `FormatGuideSection` instances share the same `id`
- **THEN** they compare as equal and produce the same `hashCode`

### Requirement: Format Guide repository

The system SHALL load Format Guide sections from the bundled asset `assets/data/format_guide.json`, whose root object contains a `sections` array. The repository SHALL lazily load on first access and cache the parsed list in memory for subsequent calls. It SHALL expose `getAll()` returning all sections in asset order and `getById(id)` returning the matching section or `null` when none matches. On asset-read or JSON-parse failure, `getAll()` SHALL propagate the error to the caller.

#### Scenario: Load all sections in order

- **WHEN** `getAll()` is called for the first time
- **THEN** the repository reads `assets/data/format_guide.json`, parses the `sections` array, and returns the sections in the order they appear in the asset

#### Scenario: Cache after first load

- **WHEN** `getAll()` is called more than once
- **THEN** the asset is read only on the first call and later calls return the cached list

#### Scenario: Lookup by id — hit

- **WHEN** `getById(id)` is called with an id present in the asset
- **THEN** the matching `FormatGuideSection` is returned

#### Scenario: Lookup by id — miss

- **WHEN** `getById(id)` is called with an id that does not exist
- **THEN** `null` is returned

#### Scenario: Asset load failure propagates

- **WHEN** the asset cannot be read or contains invalid JSON
- **THEN** `getAll()` throws, allowing the presentation layer to surface an error state

### Requirement: Format Guide content coverage and accuracy

The Format Guide content SHALL include six ordered sections covering: (1) format overview, (2) group stage scoring, (3) advancement, (4) tiebreakers, (5) best third-placed teams, and (6) the knockout stage. Numeric and procedural facts SHALL match official FIFA WC2026 reporting: 48 teams in 12 groups (A–L) of 4, 104 total matches; three points for a win, one for a draw, none for a loss; the top two teams per group (24) plus the eight best third-placed teams advance to a 32-team knockout, while the four worst third-placed teams and all fourth-placed teams are eliminated. The tiebreakers section SHALL present the ranking sequence as ordered bullets (goal difference, goals scored, head-to-head, fair-play points, FIFA ranking/draw) and SHALL include a disclaimer that FIFA may update the exact criteria. The knockout section SHALL list the rounds as ordered bullets from Round of 32 through the final, including the third-place match.

#### Scenario: Six ordered sections present

- **WHEN** the Format Guide asset is loaded
- **THEN** it contains sections with ids `overview`, `groups`, `advancement`, `tiebreakers`, `best_thirds`, and `knockout`, in that order

#### Scenario: Tiebreakers expose an ordered sequence and disclaimer

- **WHEN** the `tiebreakers` section is read
- **THEN** its `bullets` list contains the ranking criteria in order and its body text includes a note that FIFA may update the exact criteria

#### Scenario: Knockout lists rounds in order

- **WHEN** the `knockout` section is read
- **THEN** its `bullets` list names the knockout rounds in progression order from the Round of 32 to the final, including the third-place match

### Requirement: Format Guide list screen

The system SHALL provide a list screen that displays every Format Guide section as a tappable tile showing the section's localized icon and Vietnamese title, rendered on the shared premium background. The screen SHALL show a loading indicator while sections load, an inline error state with a retry control that reloads the data on failure, and the list of section tiles on success. Tapping a tile SHALL navigate to that section's detail screen.

#### Scenario: Sections render as tiles

- **WHEN** sections load successfully
- **THEN** the screen shows one tile per section, each displaying the section's icon and Vietnamese title

#### Scenario: Loading state

- **WHEN** sections are still loading
- **THEN** a loading indicator is shown

#### Scenario: Error state with retry

- **WHEN** loading sections fails
- **THEN** an error message and a retry control are shown, and activating retry re-attempts the load

#### Scenario: Navigate to detail

- **WHEN** the user taps a section tile
- **THEN** the app navigates to the detail screen for that section's id

### Requirement: Format Guide detail screen

The system SHALL provide a detail screen for a single section identified by id. It SHALL render the section's Vietnamese title and body, and when the section has a non-empty `bullets` list it SHALL render those bullets as an ordered numbered list; when `bullets` is empty it SHALL render the body only. The screen SHALL show a loading state while resolving the section, an error state with a back control on load failure, and a not-found state with a back control when no section matches the id.

#### Scenario: Render body only when no bullets

- **WHEN** a section with an empty `bullets` list is shown
- **THEN** the detail screen renders the title and body text and renders no numbered list

#### Scenario: Render ordered bullets

- **WHEN** a section with a non-empty `bullets` list is shown
- **THEN** the detail screen renders the bullets as an ordered numbered list beneath the body

#### Scenario: Section not found

- **WHEN** the detail screen is opened with an id that matches no section
- **THEN** a not-found state with a back control is shown

#### Scenario: Load failure on detail

- **WHEN** resolving the section fails
- **THEN** an error state with a back control is shown

### Requirement: Format Guide routing

The system SHALL expose a route constant for the Format Guide list at `/format-guide` and a helper producing the detail path `/format-guide/<id>`. Both routes SHALL be registered outside the bottom-navigation shell so they push over it, consistent with the existing Fan Etiquette routes.

#### Scenario: Open the list route

- **WHEN** the app navigates to `/format-guide`
- **THEN** the Format Guide list screen is shown over the current shell

#### Scenario: Open a detail route

- **WHEN** the app navigates to `/format-guide/<id>`
- **THEN** the Format Guide detail screen for that id is shown

### Requirement: Format Guide entry point

The system SHALL provide an entry point to the Format Guide from the Settings screen "Resources & Reference" card as a navigation tile, placed alongside the existing Vocabulary and Fan Etiquette tiles. The tile SHALL use a localized label and SHALL navigate to the Format Guide list when activated.

#### Scenario: Navigate from Settings

- **WHEN** the user activates the Format Guide tile in the Settings "Resources & Reference" card
- **THEN** the app navigates to the Format Guide list screen

### Requirement: Format Guide localization

The system SHALL provide localized UI chrome strings for the Format Guide in both English and Vietnamese, covering the app-bar title, the load-error message, the retry control, the not-found message, and the back control. The English app-bar title SHALL be "Tournament Format" and the Vietnamese app-bar title SHALL be "Thể thức giải đấu".

#### Scenario: English locale labels

- **WHEN** the app locale is English
- **THEN** the Format Guide screens display English chrome strings, with the app-bar title "Tournament Format"

#### Scenario: Vietnamese locale labels

- **WHEN** the app locale is Vietnamese
- **THEN** the Format Guide screens display Vietnamese chrome strings, with the app-bar title "Thể thức giải đấu"
