## Why

Seven pre-launch bugs block store submission or degrade user experience on Android: missing platform permissions, a missing compliance disclaimer, no UX flow for exact-alarm permission, a visible no-op button in onboarding, a potential crash from unguarded Isar access, and standings data that refetches on every navigation. These must be resolved before the app can be submitted.

## What Changes

- Add `SCHEDULE_EXACT_ALARM` and `RECEIVE_BOOT_COMPLETED` permissions to `AndroidManifest.xml` so reminders fire at the correct time and survive device reboots.
- Add an "Unofficial app" disclaimer section to the Settings screen (About card) for FIFA compliance.
- Add an exact-alarm permission UX flow on Android 12+ (API 31+): check `canScheduleExactAlarms`, show a rationale dialog, and deep-link to the system exact-alarm settings screen if the user needs to grant it.
- Hide the no-op "Change timezone" button in the onboarding timezone step (Sprint 2 feature not yet implemented).
- Guard `isarInstanceProvider` so it does not throw when Isar is not yet ready; the app root widget already watches `seedLoaderProvider` but the guard is missing at the provider level.
- Add `ref.keepAlive()` to `standingsProvider` so standings data is cached for the session instead of refetching on every navigation.

## Capabilities

### New Capabilities

- `android-permissions`: Android manifest permissions and exact-alarm UX flow for reliable notification scheduling.
- `settings-about`: Unofficial-app disclaimer section in the Settings screen.

### Modified Capabilities

- `match-reminders`: Add exact-alarm permission check step to the reminder permission flow on Android 12+.

## Impact

- `app/android/app/src/main/AndroidManifest.xml` — add two `<uses-permission>` entries and a `<receiver>` for boot.
- `app/lib/core/notifications/notification_service.dart` — add `canScheduleExactAlarms()` helper.
- `app/lib/features/reminders/presentation/reminder_sheet.dart` — add exact-alarm check before opening the sheet on Android 12+.
- `app/lib/features/settings/presentation/settings_screen.dart` — add About card with disclaimer text.
- `app/lib/features/onboarding/presentation/steps/timezone_step.dart` — hide the "Change timezone" button.
- `app/lib/features/matches/data/match_providers.dart` — guard `isarInstanceProvider` with `AsyncValue.when` or return null instead of throwing.
- `app/lib/features/standings/application/standings_provider.dart` — add `ref.keepAlive()`.
- `app/lib/l10n/app_en.arb` and `app_vi.arb` — add i18n strings for disclaimer and exact-alarm dialog.
