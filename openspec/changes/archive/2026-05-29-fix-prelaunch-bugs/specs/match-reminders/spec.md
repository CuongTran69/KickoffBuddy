## MODIFIED Requirements

### Requirement: Defer notification permission request until first use
The system SHALL request notification permission only when the user first interacts with the "Set reminder" feature. On Android 12+, the system SHALL additionally check for exact-alarm permission after notification permission is confirmed, and SHALL show a rationale dialog if exact-alarm permission is missing. The system MUST NOT request either permission during onboarding or app boot.

#### Scenario: User taps "Set reminder" for the first time
- **WHEN** the user taps "Set reminder" on a match detail screen
- **AND** notification permission has never been requested
- **THEN** the OS notification permission dialog appears
- **AND** if granted on Android 12+, the exact-alarm check runs next
- **AND** if granted on Android < 12 or iOS, the reminder bottom sheet opens
- **AND** if notification permission is denied, an explanatory dialog appears with "Open Settings" and "Cancel" buttons

#### Scenario: User taps "Set reminder" with notification permission already granted on Android 12+
- **WHEN** the user taps "Set reminder" and notification permission was previously granted
- **AND** the device is Android 12+
- **AND** `canScheduleExactAlarms()` returns `false`
- **THEN** the exact-alarm rationale dialog appears
- **AND** the reminder bottom sheet does NOT open until the user grants exact-alarm permission or dismisses

#### Scenario: User taps "Set reminder" with notification permission already granted and exact alarms available
- **WHEN** the user taps "Set reminder" and notification permission was previously granted
- **AND** either the device is Android < 12, iOS, or `canScheduleExactAlarms()` returns `true`
- **THEN** the reminder bottom sheet opens immediately without any permission dialog

#### Scenario: User taps "Set reminder" with notification permission denied previously
- **WHEN** the user taps "Set reminder" and notification permission was previously denied
- **THEN** the explanatory dialog appears with "Open Settings" deep link
- **AND** tapping "Open Settings" opens the OS app settings via `app_settings`
- **AND** tapping "Cancel" dismisses the dialog with no further action
