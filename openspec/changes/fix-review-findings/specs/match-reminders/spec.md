## MODIFIED Requirements

### Requirement: Save reminders cancels prior schedules and persists offsets

The system SHALL, on save, cancel ALL previously-scheduled notifications for the match, schedule new notifications for each selected offset using `tz.TZDateTime`, and persist the selected offsets to `match.reminders` via the match repository. While a save is in flight, the system SHALL prevent the save action from being triggered again (the Save control SHALL be disabled and reflect an in-progress state) so that repeated taps cannot schedule duplicate notifications. The Save control SHALL be re-enabled when the operation completes, whether it succeeds or fails.

#### Scenario: User saves reminder selection

- **WHEN** the user selects offsets [1440, 30] and taps Save
- **THEN** all prior notifications for this match are cancelled
- **AND** two new notifications are scheduled at `kickoffAtUtc - 1440 min` and `kickoffAtUtc - 30 min`
- **AND** `match.reminders` is updated to `[1440, 30]` via repository upsert
- **AND** the bottom sheet closes
- **AND** a snackbar shows "Reminders saved"

#### Scenario: User clears all reminders

- **WHEN** the user deselects all chips and taps Save
- **THEN** all prior notifications for this match are cancelled
- **AND** `match.reminders = []` is persisted
- **AND** no new notifications are scheduled

#### Scenario: Repeated taps during save do not duplicate notifications

- **WHEN** the user taps Save and, before the save completes, attempts to tap Save again
- **THEN** the second tap is ignored (the Save control is disabled while the save is in flight)
- **AND** only one set of notifications is scheduled for the selected offsets

#### Scenario: Save control re-enables after failure

- **WHEN** a save fails (e.g. repository or scheduling error)
- **THEN** the Save control returns to its enabled state so the user can retry
