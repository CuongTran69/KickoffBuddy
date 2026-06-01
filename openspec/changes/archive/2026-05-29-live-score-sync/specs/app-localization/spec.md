## ADDED Requirements

### Requirement: Home, standings, and match-detail copy is localized

The system SHALL source all user-facing primary copy on the home dashboard, standings screen, group standings card, match list sync feedback, and match detail live-data labels from ARB keys in both `app_en.arb` and `app_vi.arb`, with no hardcoded Vietnamese literals in these widgets. New keys SHALL follow the existing `screen_section_purpose` naming convention and SHALL include `description` metadata in the English template.

#### Scenario: Home live and today sections render localized strings
- **WHEN** the home dashboard renders the live indicator, the "view detail" action, and the today-matches section header
- **THEN** all three derive from ARB keys (not hardcoded literals) in the active locale

#### Scenario: Standings states and headers render localized strings
- **WHEN** the standings screen shows its empty state, error state, retry action, and the group card column headers (group, team, played, W-D-L, GF:GA, goal difference, points)
- **THEN** all of them derive from ARB keys in the active locale

#### Scenario: Match list sync error renders localized string
- **WHEN** a score sync triggered from the match list fails
- **THEN** the snackbar message derives from an ARB key with the error reason as a placeholder

#### Scenario: Match detail live-data labels render localized strings
- **WHEN** the match detail screen shows status badge, winner, venue, attendance, and penalty labels
- **THEN** each label derives from an ARB key in the active locale
