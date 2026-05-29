## ADDED Requirements

### Requirement: Browse vocabulary terms alphabetically

The system SHALL display all 17 vocabulary terms from the bundled JSON, sorted alphabetically by `term_vi`. The list MUST be a single scrollable surface with no pagination.

#### Scenario: User opens vocabulary screen

- **WHEN** the user navigates to `/vocabulary`
- **AND** the JSON bundle has loaded
- **THEN** all 17 terms render in alphabetical order by `term_vi`
- **AND** each row shows the VN term in bold and the EN term as subtitle

#### Scenario: Loading state

- **WHEN** the user opens `/vocabulary` and the repository has not yet loaded the JSON
- **THEN** the screen shows a centered `CircularProgressIndicator`

### Requirement: Real-time search with diacritic-insensitive matching

The system SHALL provide a search bar that filters the term list in real time. Matching MUST be case-insensitive and accent-insensitive — typing "viet vi" SHALL match "Việt vị". The system SHALL match against `term_vi`, `term_vi_no_diacritics`, and `term_en` fields.

#### Scenario: Empty query shows all terms

- **WHEN** the search query is empty
- **THEN** all 17 terms are visible

#### Scenario: VN exact match

- **WHEN** the user types "Việt vị"
- **THEN** the list filters to show only the "Việt vị" term

#### Scenario: VN diacritic-insensitive match

- **WHEN** the user types "viet vi"
- **THEN** the list filters to show only the "Việt vị" term (matches via `term_vi_no_diacritics`)

#### Scenario: EN match

- **WHEN** the user types "offside"
- **THEN** the list filters to show terms whose `term_en` contains "offside" (case-insensitive)

#### Scenario: Partial match

- **WHEN** the user types "vi"
- **THEN** the list shows all terms whose `term_vi`, `term_vi_no_diacritics`, OR `term_en` contains "vi" (e.g., "Việt vị", "VAR" if applicable, "Video assistant")

#### Scenario: No matches

- **WHEN** the user types a query with no matches (e.g., "zzz")
- **THEN** the list is empty
- **AND** an empty state shows "No matches found" with a "Clear search" button
- **AND** tapping "Clear search" empties the search bar

### Requirement: Search input is debounced

The search bar SHALL debounce input by approximately 200 ms before re-filtering, but an empty query SHALL be applied immediately so the user can clear filters without delay.

#### Scenario: Rapid typing triggers single re-filter

- **WHEN** the user types five characters quickly within 100 ms total
- **THEN** the filter computes once after the debounce window elapses (not five separate filters)

#### Scenario: Clearing the search is immediate

- **WHEN** the user clears the search bar (sets it to empty)
- **THEN** the full list reappears immediately without waiting for debounce

### Requirement: Tap term to expand inline

The system SHALL expand a term's full content inline when the row is tapped — no separate detail route. Expanded content SHALL include full VN + EN definition, VN + EN example, and related-term chips.

#### Scenario: User taps a collapsed row

- **WHEN** the user taps a collapsed term row
- **THEN** the row expands to show full VN definition, full EN definition, VN example, EN example, and related-term chips
- **AND** other expanded rows do not collapse (multi-expand is allowed)

#### Scenario: User taps an expanded row

- **WHEN** the user taps a row that is already expanded
- **THEN** the row collapses back to the compact two-line view

#### Scenario: No related terms

- **WHEN** an expanded term has empty or null `related` field
- **THEN** the related-term chips section is omitted

### Requirement: Tap related-term chip navigates within the list

The system SHALL, when the user taps a related-term chip, scroll to that term in the list and expand it. No separate route navigation occurs.

#### Scenario: Related term exists in current list

- **WHEN** the user taps a related-term chip whose target term is in the current filter
- **THEN** the list scrolls to that term
- **AND** that term's row becomes expanded

#### Scenario: Related term filtered out

- **WHEN** the user taps a related-term chip whose target term is currently filtered out by an active search
- **THEN** the search is cleared
- **AND** the list scrolls to the target term and expands it

### Requirement: Repository loads vocabulary from JSON bundle

The system SHALL provide a `VocabularyRepository` that reads `app/assets/data/vocabulary.json` once via `rootBundle.loadString`, deserializes into 17 `VocabularyItem` instances, and caches in memory.

#### Scenario: First read loads the JSON

- **WHEN** any consumer first invokes `getAll()`
- **THEN** the repository reads `assets/data/vocabulary.json`, parses it, and returns the items

#### Scenario: Subsequent reads use the cache

- **WHEN** `getAll()` is invoked a second time
- **THEN** no asset read occurs; the cached list is returned

#### Scenario: Search returns matching items

- **WHEN** `search("viet vi")` is invoked
- **THEN** the repository returns items where `term_vi`, `term_vi_no_diacritics`, or `term_en` contains "viet vi" (case-insensitive)

#### Scenario: Empty search returns all items

- **WHEN** `search("")` or `search(null)` is invoked
- **THEN** the repository returns all 17 items
