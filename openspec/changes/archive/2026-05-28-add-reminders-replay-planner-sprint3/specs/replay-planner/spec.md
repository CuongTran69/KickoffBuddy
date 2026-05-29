## ADDED Requirements

### Requirement: Plan a replay viewing time for a match

The system SHALL allow the user to plan a future viewing time for any match via a dialog launched from the match detail screen. The picked datetime MUST be after the match kickoff and in the future.

#### Scenario: Open Plan Replay dialog

- **WHEN** the user taps "Plan replay" on a match detail screen
- **THEN** an AlertDialog opens with a date picker and time picker
- **AND** the date picker's `firstDate` is `max(today, kickoffDate)`
- **AND** the time picker defaults to a time after the kickoff time on the picked date

#### Scenario: User saves a valid replay plan

- **WHEN** the user picks date+time strictly after `match.kickoffAtUtc` and in the future
- **AND** taps Save
- **THEN** `match.replayPlannerEnabled` is set to `true`
- **AND** `match.replayPlannedAt` is set to the picked datetime in UTC
- **AND** a reminder notification is scheduled at `replayPlannedAt - 5 minutes`
- **AND** the match is persisted via repository upsert
- **AND** the dialog closes
- **AND** a snackbar shows "Replay planned for [local time]"

#### Scenario: User picks time before kickoff

- **WHEN** the user picks a datetime that is before or equal to `match.kickoffAtUtc`
- **THEN** the Save button is disabled
- **AND** an inline error shows "Replay time must be after kickoff"

#### Scenario: User picks time in the past

- **WHEN** the user picks a datetime that is in the past
- **THEN** the Save button is disabled
- **AND** an inline error shows "Replay time must be in the future"

### Requirement: Cancel an existing replay plan

The system SHALL show a "Cancel replay plan" action when a match has `replayPlannerEnabled = true`. Cancelling MUST clear the plan and cancel the scheduled replay reminder.

#### Scenario: User cancels replay plan

- **WHEN** the user views a match with `replayPlannerEnabled = true` and taps "Cancel replay plan"
- **THEN** a confirmation dialog appears
- **AND** on confirm, `match.replayPlannerEnabled` is set to `false`
- **AND** `match.replayPlannedAt` is set to null
- **AND** the scheduled replay reminder notification is cancelled
- **AND** the match is persisted via repository upsert
- **AND** the spoiler banner disappears
- **AND** a snackbar shows "Replay plan cancelled"

#### Scenario: User dismisses cancel confirmation

- **WHEN** the user taps "Cancel replay plan" but dismisses the confirmation
- **THEN** the plan and notification remain unchanged

### Requirement: Spoiler shield trigger window

The system SHALL show spoiler-protection visuals (badge on match card, banner on match detail) when ALL three conditions hold: `match.replayPlannerEnabled == true`, current time is after `match.kickoffAtUtc`, and current time is before `match.replayPlannedAt`.

#### Scenario: Spoiler shield active

- **WHEN** a match has `replayPlannerEnabled = true`
- **AND** current time is after kickoff
- **AND** current time is before the planned replay time
- **THEN** the match card on the list shows a "Spoiler-protected" badge with shield icon
- **AND** the match detail screen shows a full-width banner "Spoiler-protected until [planned local time]"

#### Scenario: Spoiler shield not yet active (before kickoff)

- **WHEN** a match has `replayPlannerEnabled = true`
- **AND** current time is before kickoff
- **THEN** no spoiler badge or banner is shown
- **AND** the match card displays normally

#### Scenario: Spoiler shield window has passed

- **WHEN** a match has `replayPlannerEnabled = true`
- **AND** current time is after the planned replay time
- **THEN** no spoiler badge or banner is shown
- **AND** the user is expected to either watch now or cancel the plan

#### Scenario: No replay planned

- **WHEN** a match has `replayPlannerEnabled = false` or no `replayPlannedAt`
- **THEN** no spoiler badge or banner is shown regardless of current time

### Requirement: Spoiler banner on match detail

The match detail screen SHALL render a full-width subtle banner above the match info when the spoiler shield is active. The banner SHALL display a shield icon, the text "Spoiler-protected until X", where X is the planned replay time formatted in the user's local timezone.

#### Scenario: Banner shown during shield window

- **WHEN** the user opens detail of a match in the shield window
- **THEN** a banner appears at the top of the screen below the AppBar
- **AND** the banner contains a shield icon
- **AND** the banner text reads "Spoiler-protected until [day-of-week, time local]"
- **AND** the banner uses a calm/neutral background distinct from error red

#### Scenario: Banner hidden outside shield window

- **WHEN** the user opens detail of a match not in the shield window
- **THEN** no banner is rendered

### Requirement: Spoiler badge on match card

The match list card SHALL render a small badge with shield icon and "Protected" label when the spoiler shield is active for that match. The badge MUST NOT replace any existing card content; it is an additional visual marker.

#### Scenario: Badge shown on protected card

- **WHEN** a match list card renders a match in the shield window
- **THEN** a small badge with shield icon and "Protected" label appears in a non-intrusive corner of the card

#### Scenario: Badge hidden on unprotected card

- **WHEN** a match list card renders a match outside the shield window
- **THEN** no badge appears

### Requirement: Replay reminder scheduling

The system SHALL schedule a single notification at `replayPlannedAt - 5 minutes` when the user saves a replay plan. The notification ID MUST be deterministic per match for cancellation.

#### Scenario: Replay reminder fires 5 minutes before plan

- **WHEN** the user plans a replay for `2026-06-15T20:00:00 local`
- **THEN** a notification is scheduled at `2026-06-15T19:55:00 local`
- **AND** the notification title is "Replay time approaching"
- **AND** the body references the match teams

#### Scenario: Replay reminder cancelled on plan cancel

- **WHEN** the user cancels a replay plan
- **THEN** the previously scheduled replay notification is cancelled (not just the plan flag cleared)
