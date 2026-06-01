# rule-cards Specification

## Purpose
TBD - created by archiving change add-rules-vocabulary-sprint4. Update Purpose after archive.
## Requirements
### Requirement: Browse rule cards grouped by topic

The system SHALL display 21 rule cards from the bundled JSON, grouped into 7 topic sections (offside, penalty, VAR, cards, stoppage time, extra time, penalty shootout). The list view MUST show exactly one card per topic at any time, matching the user's selected level.

#### Scenario: User opens the rule cards list

- **WHEN** the user navigates to `/rules`
- **AND** the JSON bundle has loaded
- **THEN** 7 topic sections render in fixed order: offside, penalty, VAR, cards, stoppage time, extra time, penalty shootout
- **AND** each section shows a single card whose `level` matches the active filter (default Newbie)

#### Scenario: List loading state

- **WHEN** the user opens `/rules` and the repository has not yet loaded the JSON
- **THEN** the screen shows a centered `CircularProgressIndicator`

#### Scenario: List error state

- **WHEN** the JSON load throws (e.g., asset corrupt — defensive)
- **THEN** the screen shows an error message with a "Retry" button
- **AND** tapping "Retry" re-invokes the load

### Requirement: Filter rule cards by level

The system SHALL provide three filter chips — Newbie, Casual, Advanced — that update the visible card per topic. The default selection MUST be Newbie. Only one level can be active at a time.

#### Scenario: User switches to Casual level

- **WHEN** the user taps the "Casual" filter chip
- **THEN** the active filter becomes "casual"
- **AND** each topic section shows the card whose `level == "casual"`

#### Scenario: User switches to Advanced level

- **WHEN** the user taps the "Advanced" filter chip
- **THEN** each topic section shows the card whose `level == "advanced"`

#### Scenario: User returns to Newbie level

- **WHEN** any other level is active and the user taps "Newbie"
- **THEN** the active filter becomes "newbie"
- **AND** each topic section shows its newbie card

### Requirement: View rule card detail with VN and EN content

The system SHALL provide a `/rules/:id` detail screen showing the card's VN title, level badge, full body, tags, read time, and related cards. The body MUST display Vietnamese by default with a toggle to switch to English.

#### Scenario: Open detail of an existing card

- **WHEN** the user taps a card in the list
- **THEN** the app navigates to `/rules/<card-id>`
- **AND** the detail screen shows the card's VN title, level badge, VN body, tags as chips, "Read time: X seconds" estimate
- **AND** an EN/VN toggle is available

#### Scenario: User toggles to English

- **WHEN** the user taps the EN/VN toggle while VN is showing
- **THEN** the body text changes to English (`body_en`)
- **AND** the title changes to English (`title_en`)
- **AND** the toggle reflects the new active language

#### Scenario: Detail for a non-existent card

- **WHEN** the user navigates to `/rules/nonexistent_id`
- **THEN** the screen shows "Rule not found" with a "Back" button

### Requirement: Navigate between related cards

The detail screen SHALL show a "Related" section listing cards from the `relatedIds` array. Tapping a related card MUST navigate to that card's detail screen.

#### Scenario: Card has related entries

- **WHEN** a card with `relatedIds = ["offside_casual", "var_basic"]` is shown
- **THEN** the detail screen shows a "Related" section with two tappable links to those cards

#### Scenario: Card has no related entries

- **WHEN** a card with empty or null `relatedIds` is shown
- **THEN** the "Related" section is omitted or shows "No related cards"

### Requirement: Repository loads rule cards from JSON bundle

The system SHALL provide a `RuleCardRepository` that reads `app/assets/data/rule_cards.json` once via `rootBundle.loadString`, deserializes into 21 `RuleCard` instances, and caches in memory for subsequent reads. No Isar persistence.

#### Scenario: First read loads the JSON

- **WHEN** any consumer first invokes `getAll()`
- **THEN** the repository reads `assets/data/rule_cards.json`, parses it, and returns the cards

#### Scenario: Subsequent reads use the cache

- **WHEN** `getAll()` is invoked a second time
- **THEN** no asset read occurs; the cached list is returned

#### Scenario: Get card by ID

- **WHEN** `getById("offside_newbie")` is invoked and the card exists
- **THEN** the matching `RuleCard` is returned

- **WHEN** `getById("nonexistent")` is invoked
- **THEN** null is returned

#### Scenario: Get cards by topic

- **WHEN** `getByTopic("offside")` is invoked
- **THEN** all 3 cards (newbie, casual, advanced) for offside are returned

#### Scenario: Get cards by topic and level

- **WHEN** `getByTopicAndLevel("offside", "newbie")` is invoked
- **THEN** the single newbie offside card is returned in a list of length 1

