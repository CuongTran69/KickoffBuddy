# match-reminders Specification

## Purpose
TBD - created by archiving change add-reminders-replay-planner-sprint3. Update Purpose after archive.
## Requirements
### Requirement: Initialize local notifications plugin at app start

The system SHALL initialize `flutter_local_notifications` and the timezone database during app boot. Initialization MUST complete before any UI is rendered.

#### Scenario: App boot wires notifications

- **WHEN** the app starts
- **THEN** `WidgetsFlutterBinding.ensureInitialized()` runs
- **AND** `TimezoneService.initialize()` runs
- **AND** `NotificationService.initialize()` runs
- **AND** `SharedPreferences.getInstance()` is awaited
- **AND** only then `runApp(...)` is called

#### Scenario: Android notification channel registered

- **WHEN** `NotificationService.initialize()` runs on Android
- **THEN** an `AndroidNotificationChannel` named `match_reminders` is created
- **AND** the channel has `Importance.high`
- **AND** the channel description references match kickoff alerts

#### Scenario: iOS plugin requests permission category

- **WHEN** `NotificationService.initialize()` runs on iOS
- **THEN** the iOS plugin is configured with `requestAlertPermission`, `requestBadgePermission`, `requestSoundPermission` set to false at init time (deferred until user opts in)

### Requirement: Defer notification permission request until first use

The system SHALL request notification permission only when the user first interacts with the "Set reminder" feature. The system MUST NOT request permission during onboarding or app boot.

#### Scenario: User taps "Set reminder" for the first time

- **WHEN** the user taps "Set reminder" on a match detail screen
- **AND** notification permission has never been requested
- **THEN** the OS permission dialog appears
- **AND** if granted, the reminder bottom sheet opens
- **AND** if denied, an explanatory dialog appears with "Open Settings" and "Cancel" buttons

#### Scenario: User taps "Set reminder" with permission already granted

- **WHEN** the user taps "Set reminder" and permission was previously granted
- **THEN** the reminder bottom sheet opens immediately without re-prompting

#### Scenario: User taps "Set reminder" with permission denied previously

- **WHEN** the user taps "Set reminder" and permission was previously denied
- **THEN** the explanatory dialog appears with "Open Settings" deep link
- **AND** tapping "Open Settings" opens the OS app settings via `app_settings`
- **AND** tapping "Cancel" dismisses the dialog with no further action

### Requirement: Reminder bottom sheet with preset offsets

The system SHALL display a bottom sheet with 4 preset reminder offset chips (1 day, 3 hours, 30 minutes, 5 minutes) when the user opens the reminder UI for a match. Chips SHALL be multi-select (0 to 4) and reflect any previously-saved offsets for that match.

#### Scenario: Empty reminder state

- **WHEN** the user opens the reminder sheet for a match with `reminders = []`
- **THEN** all 4 chips render as unselected

#### Scenario: Existing reminder state

- **WHEN** the user opens the reminder sheet for a match with `reminders = [1440, 30]`
- **THEN** the "1 day" and "30 min" chips render as selected
- **AND** "3 hours" and "5 min" chips render as unselected

#### Scenario: User toggles chips

- **WHEN** the user taps an unselected chip
- **THEN** the chip becomes selected
- **AND** tapping it again deselects it

### Requirement: Save reminders cancels prior schedules and persists offsets

The system SHALL, on save, cancel ALL previously-scheduled notifications for the match, schedule new notifications for each selected offset using `tz.TZDateTime`, and persist the selected offsets to `match.reminders` via the match repository.

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

### Requirement: Skip reminder offsets that fall in the past

The system SHALL silently skip any reminder offset whose computed schedule time is in the past (relative to now) and notify the user via snackbar listing the skipped offsets.

#### Scenario: Kickoff in 20 minutes, user picks 30-minute offset

- **WHEN** the kickoff is in 20 minutes and the user saves offsets [180, 30, 5]
- **THEN** notifications are scheduled only for the 5-min offset
- **AND** the 180-min and 30-min offsets are skipped
- **AND** a snackbar shows "Skipped 3h, 30m (already passed)"

#### Scenario: All chosen offsets in the past

- **WHEN** every chosen offset would schedule a past notification
- **THEN** no notifications are scheduled
- **AND** a snackbar shows the skip list
- **AND** `match.reminders` is still updated (the user's preferred set is recorded for future re-use)

### Requirement: Disable reminder UI for kicked-off matches

The system SHALL replace the "Set reminder" button with a disabled "Match started" label when the match's `kickoffAtUtc` is in the past.

#### Scenario: Match already kicked off

- **WHEN** the user views the detail of a match whose `kickoffAtUtc < now`
- **THEN** the "Set reminder" interactive button is replaced with a disabled label "Match started"
- **AND** the label has no tap handler

#### Scenario: Match still upcoming

- **WHEN** the user views a match whose `kickoffAtUtc > now`
- **THEN** the "Set reminder" button is enabled and tappable

### Requirement: Notification IDs are deterministic

The system SHALL compute a stable integer notification ID from the match ID and offset, allowing the same notification to be cancelled on a different invocation.

#### Scenario: Same inputs yield same ID

- **WHEN** `notificationIdFor(match.id="m1", offset=180)` is called twice
- **THEN** both calls return the same integer

#### Scenario: Different inputs yield different IDs

- **WHEN** `notificationIdFor(match.id="m1", offset=180)` and `notificationIdFor(match.id="m1", offset=30)` are called
- **THEN** the returned integers differ

- **WHEN** `notificationIdFor(match.id="m1", offset=180)` and `notificationIdFor(match.id="m2", offset=180)` are called
- **THEN** the returned integers differ

### Requirement: Notification payload includes match info

Each scheduled notification SHALL contain a title, body, and payload that allow the user to identify the match when the notification fires.

#### Scenario: Notification scheduled with proper title and body

- **WHEN** a reminder is scheduled for match "USA vs Mexico" at the 30-min offset
- **THEN** the notification title is "Match in 30 minutes"
- **AND** the body contains "USA vs Mexico" or its localized equivalent
- **AND** the payload contains the match ID for tap-to-open routing

