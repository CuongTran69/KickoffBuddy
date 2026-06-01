## Context

Kickoff Buddy is a Flutter app targeting FIFA World Cup 2026. It is approaching store submission. Seven bugs were identified during pre-launch analysis that either block submission (missing Android permissions, missing compliance disclaimer) or degrade reliability (exact-alarm UX, Isar crash risk, standings refetch, no-op button).

The app uses `flutter_local_notifications` with `AndroidScheduleMode.exactAllowWhileIdle`, which requires `SCHEDULE_EXACT_ALARM` on Android 12+ and `RECEIVE_BOOT_COMPLETED` for rescheduling after reboot. Neither permission is declared. The notification channel ID is `match_reminders` in both code and spec — no mismatch exists. The standings provider uses `FutureProvider.autoDispose` with no keepAlive, causing a full API refetch on every tab navigation. `isarInstanceProvider` calls `requireValue` which throws a `StateError` if Isar is not yet open. The onboarding timezone step shows a "Change timezone" button with `onPressed: null` — a visible dead control. The Settings screen has no About/disclaimer section.

## Goals / Non-Goals

**Goals:**
- Declare `SCHEDULE_EXACT_ALARM` and `RECEIVE_BOOT_COMPLETED` in AndroidManifest.
- Add a `BroadcastReceiver` entry for boot-completed rescheduling.
- Add exact-alarm permission UX on Android 12+ (check → rationale dialog → deep-link to system settings).
- Add `canScheduleExactAlarms()` helper to `NotificationService`.
- Add an About card with unofficial-app disclaimer to the Settings screen.
- Add i18n strings for disclaimer and exact-alarm dialog in both `app_en.arb` and `app_vi.arb`.
- Hide the "Change timezone" button in the onboarding timezone step.
- Guard `isarInstanceProvider` so it returns `null` (or is not called) when Isar is not ready, preventing a `StateError`.
- Add `ref.keepAlive()` to `standingsProvider` so data persists for the session.

**Non-Goals:**
- Implementing manual timezone override (deferred to Sprint 2).
- Adding a boot-completed receiver Dart implementation (the manifest entry is sufficient for `flutter_local_notifications` to reschedule via its own receiver).
- Changing the notification channel ID (code and spec already agree on `match_reminders`).
- Adding Isar-backed offline cache for standings (keepAlive is sufficient for MVP).

## Decisions

**D1: Exact-alarm permission check placement**
Check `canScheduleExactAlarms()` inside `showReminderSheet()` in `reminder_sheet.dart`, after the existing notification-permission check. If exact alarms are not schedulable, show a rationale dialog with a deep-link to `ACTION_REQUEST_SCHEDULE_EXACT_ALARM`. This keeps the permission flow in one place and avoids adding complexity to `NotificationService`.

Alternative considered: check at app boot and show a banner. Rejected — too aggressive; users who never set reminders should not be prompted.

**D2: isarInstanceProvider guard**
Change `isarInstanceProvider` from `Provider<Isar>` (throws on not-ready) to `Provider<Isar?>` returning `null` when `isarProvider` is not yet in `AsyncValue.data`. Callers that currently use `isarInstanceProvider` (`match_sync_service.dart`) already run inside a context where `seedLoaderProvider` has been awaited, so `null` will not occur in practice. The guard prevents the crash in edge cases (e.g., hot-restart during development, or a race on first launch).

Alternative considered: keep `requireValue` and add a try/catch at call sites. Rejected — defensive at the wrong layer; the provider should be safe by design.

**D3: Standings keepAlive**
Use `ref.keepAlive()` inside `standingsProvider`. This is the standard Riverpod pattern for session-scoped caching without adding a new data layer. The data is invalidated when the app process restarts, which is acceptable for standings (tournament data changes slowly).

Alternative considered: add a `standingsCacheProvider` with a TTL. Rejected — over-engineering for MVP; keepAlive is sufficient.

**D4: Disclaimer placement**
Add an "About" card at the bottom of the Settings screen with a short disclaimer: "Kickoff Buddy is an unofficial fan app and is not affiliated with FIFA or any football federation." This satisfies the compliance requirement without a separate screen.

**D5: Hide timezone button**
Set the "Change timezone" `TextButton` to `visible: false` (or remove it entirely from the widget tree). Removing it entirely is cleaner — no dead widget, no confusion. The comment explaining Sprint 2 deferral is preserved in code.

## Risks / Trade-offs

- [Risk] `SCHEDULE_EXACT_ALARM` is a restricted permission on Android 12+; the OS may not auto-grant it. → Mitigation: the exact-alarm UX dialog (D1) guides the user to grant it manually.
- [Risk] Changing `isarInstanceProvider` return type from `Isar` to `Isar?` requires updating all call sites. → Mitigation: there is only one call site (`match_sync_service.dart:72`); update it with a null guard.
- [Risk] `ref.keepAlive()` means standings data is never refreshed within a session. → Mitigation: acceptable for MVP; standings change slowly and the user can force-quit to refresh.
- [Risk] Hiding the timezone button may confuse users who expected to change it. → Mitigation: the body text already explains the timezone is auto-detected; removing the button reduces confusion, not increases it.
