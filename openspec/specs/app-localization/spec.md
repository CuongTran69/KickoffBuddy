# app-localization Specification

## Purpose
TBD - created by archiving change polish-and-store-submission-sprint5. Update Purpose after archive.
## Requirements
### Requirement: Bundle ARB-based localization with VN default and EN fallback

The system SHALL provide bilingual UI strings via ARB files. Vietnamese SHALL be the default locale; English SHALL be the fallback when the system locale is unsupported.

#### Scenario: App launches on Vietnamese device

- **WHEN** the app launches on a device with system locale `vi-VN`
- **THEN** all user-facing primary copy renders in Vietnamese (from `app_vi.arb`)

#### Scenario: App launches on English device

- **WHEN** the app launches on a device with system locale `en-US`
- **THEN** all user-facing primary copy renders in English (from `app_en.arb`)

#### Scenario: App launches on unsupported locale

- **WHEN** the app launches on a device with system locale `fr-FR` (or any unsupported locale)
- **THEN** all user-facing primary copy renders in Vietnamese (default locale fallback)

### Requirement: User-facing primary copy is sourced from ARB

The system SHALL source all user-facing primary copy from `app/lib/l10n/app_en.arb` and `app/lib/l10n/app_vi.arb`. Primary copy SHALL include screen titles, button labels, snackbar messages, dialog text, and form field hints. Test labels, log strings, identifiers, and developer-facing comments SHALL remain hardcoded.

#### Scenario: Match list screen renders localized strings

- **WHEN** the user navigates to `/matches`
- **THEN** the AppBar title, filter chip labels, date section headers, and "Add match" CTA all derive from ARB keys (not hardcoded literals)

#### Scenario: Onboarding renders localized strings

- **WHEN** the user opens the onboarding flow
- **THEN** the welcome step, timezone step, language step, and ready step all derive their text from ARB keys

#### Scenario: Reminder sheet renders localized snackbars

- **WHEN** the user saves reminder selections
- **THEN** the resulting snackbar text ("Đã lưu nhắc nhở" or "Reminders saved") comes from ARB keys

### Requirement: Localization keys follow naming convention

The system SHALL name ARB keys using the pattern `screen_section_purpose` (e.g., `matches_filter_groupStage`, `rules_detail_readTime`, `onboarding_welcome_title`). Each key in `app_en.arb` SHALL include a `description` metadata field for translators.

#### Scenario: Key has description metadata

- **WHEN** an ARB entry is added
- **THEN** the entry includes a sibling `@key` entry with a `description` field describing the string's purpose

### Requirement: MaterialApp wires localization delegates

The system SHALL configure `MaterialApp.router` with `localizationsDelegates` and `supportedLocales` for English and Vietnamese.

#### Scenario: MaterialApp registered delegates

- **WHEN** the app constructs its root `MaterialApp.router`
- **THEN** `localizationsDelegates` includes `AppLocalizations.delegate`, `GlobalMaterialLocalizations.delegate`, `GlobalWidgetsLocalizations.delegate`, `GlobalCupertinoLocalizations.delegate`
- **AND** `supportedLocales` is `[Locale('vi'), Locale('en')]`

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

