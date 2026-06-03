## MODIFIED Requirements

### Requirement: User-facing primary copy is sourced from ARB

The system SHALL source all user-facing primary copy from `app/lib/l10n/app_en.arb` and `app/lib/l10n/app_vi.arb`. Primary copy SHALL include screen titles, button labels, snackbar messages, dialog text, form field hints, the home dashboard (header title/subtitle, quick-action labels, quick-learn labels and descriptions), the settings "Resources & Reference" section title, reminder and replay notification copy (notification title and body), reminder offset unit labels (day/hour/minute), the spoiler-protection badge label, the rule-card empty-state message, and accessibility tooltips (e.g. the vocabulary search clear-button tooltip). Test labels, log strings, identifiers, and developer-facing comments SHALL remain hardcoded.

#### Scenario: Match list screen renders localized strings

- **WHEN** the user navigates to `/matches`
- **THEN** the AppBar title, filter chip labels, date section headers, and "Add match" CTA all derive from ARB keys (not hardcoded literals)

#### Scenario: Onboarding renders localized strings

- **WHEN** the user opens the onboarding flow
- **THEN** the welcome step, timezone step, language step, and ready step all derive their text from ARB keys

#### Scenario: Reminder sheet renders localized snackbars

- **WHEN** the user saves reminder selections
- **THEN** the resulting snackbar text ("Đã lưu nhắc nhở" or "Reminders saved") comes from ARB keys

#### Scenario: Home dashboard renders localized strings

- **WHEN** the user opens the home screen on either locale
- **THEN** the dashboard header title and subtitle, every quick-action label, and the quick-learn section labels and descriptions all derive from ARB keys (no hardcoded Vietnamese literals)

#### Scenario: Notification copy is localized

- **WHEN** a reminder or replay notification is composed
- **THEN** its title and body text derive from ARB keys for the active locale (no hardcoded Vietnamese literals in the controller layer)

#### Scenario: Reminder offset labels are localized

- **WHEN** a reminder offset label such as "1 day" / "30 minutes" is rendered or used in notification copy
- **THEN** the day/hour/minute unit words derive from ARB keys for the active locale

#### Scenario: Spoiler badge and rule-card empty state are localized

- **WHEN** the spoiler-protection badge or the rule-card "no cards for this level" empty state is rendered
- **THEN** their text derives from ARB keys for the active locale

#### Scenario: Settings resources section title is localized

- **WHEN** the settings screen renders the "Resources & Reference" section
- **THEN** the section title derives from an ARB key (not an inline `languageCode == 'vi' ? ... : ...` conditional)
