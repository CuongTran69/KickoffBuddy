## MODIFIED Requirements

### Requirement: Plan a replay viewing time for a match

The system SHALL allow the user to plan a future viewing time for any match via a dialog launched from the match detail screen. The picked datetime MUST be after the match kickoff and in the future. The persistence SHALL be atomic with respect to in-memory state: the system SHALL persist the plan via repository upsert FIRST and update the controller's exposed state only after that write succeeds; if the write fails, the controller SHALL NOT leave the in-memory `Match` or exposed state in a partially-mutated (enabled) condition, and the failure SHALL surface to the caller so an error can be shown. While a save is in flight, the Save control SHALL be disabled and reflect an in-progress state so repeated taps cannot schedule duplicate replay reminders.

#### Scenario: Open Plan Replay dialog

- **WHEN** the user taps "Plan replay" on a match detail screen
- **THEN** an AlertDialog opens with a date picker and time picker
- **AND** the date picker's `firstDate` is `max(today, kickoffDate)`
- **AND** the time picker defaults to a time after the kickoff time on the picked date

#### Scenario: User saves a valid replay plan

- **WHEN** the user picks date+time strictly after `match.kickoffAtUtc` and in the future
- **AND** taps Save
- **THEN** the match is persisted via repository upsert with `replayPlannerEnabled = true` and `replayPlannedAt` set to the picked datetime in UTC
- **AND** the controller's exposed state is updated only after the upsert succeeds
- **AND** a reminder notification is scheduled at `replayPlannedAt - REPLAY_PREFIRE_OFFSET` (5 minutes)
- **AND** the dialog closes
- **AND** a snackbar shows "Replay planned for [local time]"

#### Scenario: Save fails and state stays consistent

- **WHEN** the repository upsert throws while saving a replay plan
- **THEN** the controller's exposed state is not changed to enabled
- **AND** the failure surfaces to the caller (an error is shown), with no permanently-mutated in-memory match

#### Scenario: Repeated taps during save do not duplicate the replay reminder

- **WHEN** the user taps Save and, before it completes, attempts to tap Save again
- **THEN** the second tap is ignored (the Save control is disabled while the save is in flight)
- **AND** only one replay reminder is scheduled

#### Scenario: User picks time before kickoff

- **WHEN** the user picks a datetime that is before or equal to `match.kickoffAtUtc`
- **THEN** the Save button is disabled
- **AND** an inline error shows "Replay time must be after kickoff"

#### Scenario: User picks time in the past

- **WHEN** the user picks a datetime that is in the past
- **THEN** the Save button is disabled
- **AND** an inline error shows "Replay time must be in the future"

### Requirement: Cancel an existing replay plan

The system SHALL show a "Cancel replay plan" action when a match has `replayPlannerEnabled = true`. Cancelling MUST clear the plan and cancel the scheduled replay reminder. The persistence SHALL be atomic with respect to in-memory state: the system SHALL persist the cleared plan via repository upsert FIRST and update the controller's exposed state only after that write succeeds; if the write fails, the failure SHALL surface to the caller and the state SHALL NOT be left partially mutated. While a cancel is in flight, the cancel control SHALL be disabled to prevent repeated invocation.

#### Scenario: User cancels replay plan

- **WHEN** the user views a match with `replayPlannerEnabled = true` and taps "Cancel replay plan"
- **THEN** a confirmation dialog appears
- **AND** on confirm, the match is persisted via repository upsert with `replayPlannerEnabled = false` and `replayPlannedAt = null`
- **AND** the controller's exposed state is updated only after the upsert succeeds
- **AND** the scheduled replay reminder notification is cancelled
- **AND** the spoiler banner disappears
- **AND** a snackbar shows "Replay plan cancelled"

#### Scenario: Cancel fails and state stays consistent

- **WHEN** the repository upsert throws while cancelling a replay plan
- **THEN** the controller's exposed state remains enabled (unchanged)
- **AND** the failure surfaces to the caller, with no partially-mutated in-memory match

#### Scenario: User dismisses cancel confirmation

- **WHEN** the user taps "Cancel replay plan" but dismisses the confirmation
- **THEN** the plan and notification remain unchanged
