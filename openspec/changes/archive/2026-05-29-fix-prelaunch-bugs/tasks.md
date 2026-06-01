## 1. Android Manifest Permissions

- [x] 1.1 Add `<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />` to `app/android/app/src/main/AndroidManifest.xml`
- [x] 1.2 Add `<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />` to `app/android/app/src/main/AndroidManifest.xml` ← (verify: both permissions present in manifest, no duplicate entries)

## 2. NotificationService: canScheduleExactAlarms helper

- [x] 2.1 Add `canScheduleExactAlarms()` async method to `app/lib/core/notifications/notification_service.dart` that returns `true` on iOS and Android < 12, and calls `AndroidFlutterLocalNotificationsPlugin.canScheduleExactNotifications()` on Android 12+ ← (verify: method compiles, returns correct type, handles null platform result)

## 3. Exact-Alarm UX Dialog in Reminder Sheet

- [x] 3.1 Add i18n strings for exact-alarm dialog to `app/lib/l10n/app_en.arb`: `reminder_exactAlarm_title`, `reminder_exactAlarm_body`, `reminder_exactAlarm_openSettings`
- [x] 3.2 Add matching i18n strings to `app/lib/l10n/app_vi.arb`
- [x] 3.3 In `app/lib/features/reminders/presentation/reminder_sheet.dart`, after the notification-permission check, call `canScheduleExactAlarms()` on Android 12+ and show a rationale dialog with "Open Settings" (deep-link to `ACTION_REQUEST_SCHEDULE_EXACT_ALARM` via `app_settings` or `url_launcher`) and "Cancel" if it returns `false` ← (verify: dialog appears on Android 12+ when exact alarm not granted, sheet opens directly when granted, no dialog on iOS/Android < 12)

## 4. Settings Screen: About / Disclaimer Card

- [x] 4.1 Add i18n strings `settings_about_title` and `settings_about_disclaimer` to `app/lib/l10n/app_en.arb`
- [x] 4.2 Add matching i18n strings to `app/lib/l10n/app_vi.arb`
- [x] 4.3 Add an About `_PremiumSettingsCard` at the bottom of the `ListView` in `app/lib/features/settings/presentation/settings_screen.dart` displaying the disclaimer text ← (verify: card visible in Settings, text matches spec, both languages render correctly)

## 5. Onboarding: Hide No-Op Timezone Button

- [x] 5.1 Remove the `TextButton` with `onPressed: null` ("Change timezone") from `app/lib/features/onboarding/presentation/steps/timezone_step.dart`; preserve a code comment noting Sprint 2 manual override ← (verify: button no longer visible in onboarding timezone step, no layout regression)

## 6. isarInstanceProvider: Null-Safe Guard

- [x] 6.1 Change `isarInstanceProvider` in `app/lib/features/matches/data/match_providers.dart` from `Provider<Isar>` returning `requireValue` to `Provider<Isar?>` returning `asData?.value` (null when not ready)
- [x] 6.2 Update the call site in `app/lib/features/matches/application/match_sync_service.dart` to null-check the result before using the Isar instance ← (verify: no StateError thrown on hot-restart or first launch race; sync service skips gracefully when isar is null)

## 7. Standings Provider: Session Cache

- [x] 7.1 Add `final link = ref.keepAlive();` inside `standingsProvider` in `app/lib/features/standings/application/standings_provider.dart` so standings data is not disposed on tab navigation ← (verify: navigating away from and back to Standings tab does not trigger a new API call within the same session)
