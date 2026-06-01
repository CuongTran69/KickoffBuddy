## ADDED Requirements

### Requirement: AndroidManifest declares exact-alarm and boot-received permissions
The system SHALL declare `SCHEDULE_EXACT_ALARM` and `RECEIVE_BOOT_COMPLETED` permissions in `AndroidManifest.xml` so that exact notifications fire at the correct time and are rescheduled after device reboot.

#### Scenario: Exact-alarm permission declared
- **WHEN** the app is installed on Android 12+ (API 31+)
- **THEN** `AndroidManifest.xml` contains `<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />`

#### Scenario: Boot-completed permission declared
- **WHEN** the app is installed on any Android version
- **THEN** `AndroidManifest.xml` contains `<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />`

### Requirement: NotificationService exposes canScheduleExactAlarms helper
The system SHALL provide a `canScheduleExactAlarms()` method on `NotificationService` that returns `true` if the app can schedule exact alarms on the current device, and `true` unconditionally on Android < 12 and on iOS.

#### Scenario: Android 12+ with permission granted
- **WHEN** `canScheduleExactAlarms()` is called on Android 12+
- **AND** the user has granted exact-alarm permission
- **THEN** the method returns `true`

#### Scenario: Android 12+ with permission not granted
- **WHEN** `canScheduleExactAlarms()` is called on Android 12+
- **AND** the user has NOT granted exact-alarm permission
- **THEN** the method returns `false`

#### Scenario: Android < 12 or iOS
- **WHEN** `canScheduleExactAlarms()` is called on Android < 12 or iOS
- **THEN** the method returns `true` unconditionally

### Requirement: Exact-alarm UX dialog shown when permission missing
The system SHALL show a rationale dialog when the user attempts to set a reminder and exact-alarm permission is not granted on Android 12+. The dialog SHALL offer a button to open the system exact-alarm settings screen.

#### Scenario: User taps Set Reminder without exact-alarm permission
- **WHEN** the user taps "Set reminder" on Android 12+
- **AND** notification permission is already granted
- **AND** `canScheduleExactAlarms()` returns `false`
- **THEN** a dialog appears explaining that exact alarms are needed for on-time reminders
- **AND** the dialog has an "Open Settings" button that deep-links to `ACTION_REQUEST_SCHEDULE_EXACT_ALARM`
- **AND** the dialog has a "Cancel" button that dismisses without opening the sheet

#### Scenario: User taps Set Reminder with exact-alarm permission granted
- **WHEN** the user taps "Set reminder" on Android 12+
- **AND** notification permission is already granted
- **AND** `canScheduleExactAlarms()` returns `true`
- **THEN** the reminder bottom sheet opens directly without showing the exact-alarm dialog
