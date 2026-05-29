## Why

Sprint 2 delivered the Match Scheduler with 104 World Cup 2026 matches, repository, list/detail screens, manual add, and Magic Add Lite. The Match Detail screen has two placeholder buttons — "Set reminder" and "Plan replay" — that show a "Coming in Sprint 3" tooltip but do nothing.

Sprint 3 turns those placeholders into real features. Reminders give users on-time alerts before kickoff (a primary value driver — the "Plan" pillar in the 3P framework). Replay Planner gives users in lopsided timezones the ability to defer a match and avoid spoilers (the "Protect" pillar). Together they convert Kickoff Buddy from a passive catalog into an active companion.

This sprint also closes 3 test coverage gaps left over from Sprint 2 verification (real Isar CRUD via integration_test, full MatchListScreen widget test with mock repository, "past date shows error" widget test).

## What Changes

### Reminders (new capability)
- Real implementation of `core/notifications/notification_service.dart` (currently a Sprint 1 stub) wrapping `flutter_local_notifications` v18+.
- Android NotificationChannel "match_reminders" + POST_NOTIFICATIONS permission (Android 13+).
- iOS notification permission request (alert, badge, sound).
- Permission flow: request on first "Set reminder" tap (NOT during onboarding).
- Permission denied → explanatory dialog with "Open Settings" deep link.
- 4 preset reminder offsets: 1 day (1440 min), 3 hours (180 min), 30 min, 5 min — multi-select.
- Bottom sheet UI launched from Match Detail "Set reminder" button.
- Cancel-then-reschedule pattern: clear existing notifications for a match before scheduling new offsets.
- Edge cases: kicked-off match → button shows "Match started" disabled; past offsets skipped silently with snackbar.

### Replay Planner (new capability)
- Real implementation of "Plan replay" button on Match Detail.
- AlertDialog with datetime picker; picked time must be after kickoff and in future.
- Save sets `match.replayPlannerEnabled = true`, `match.replayPlannedAt`, schedules a 5-min-before-replay reminder.
- Cancel button clears the plan and cancels the scheduled reminder.
- Spoiler shield mode visual marker: when `replayPlannerEnabled` AND now > kickoff AND now < replayPlannedAt, match list cards + detail show "Spoiler-protected" badge.
- Match Detail full-width banner during spoiler shield window.

### Sprint 2 test gap fixes
- Rename `test/features/matches/match_repository_test.dart` → `match_model_test.dart` (current content is model-only).
- Create `integration_test/match_repository_integration_test.dart` for real Isar CRUD (runs on device/simulator).
- Add full MatchListScreen widget test with `ProviderScope` overrides + 3 mock matches (today/tomorrow/past).
- Add "past date shows error" widget test on ManualAdd screen.

### Wiring
- `app/lib/main.dart` initializes NotificationService before `runApp`.
- `app/pubspec.yaml` adds `app_settings: ^5.1.1` for "Open Settings" deep link.
- `match_detail_screen.dart` enables both buttons; integrates spoiler banner widget.
- `match_card.dart` shows spoiler badge when applicable.

### No spec-level changes to Match Scheduler or Match Data Store
The existing `match-scheduler` capability already includes "disabled placeholder buttons for Sprint 3 features" — Sprint 3 implements those features as separate capabilities that interact with Match Scheduler via the detail screen. Match data store schema (`Match.reminders`, `Match.replayPlannerEnabled`, `Match.replayPlannedAt` fields) is unchanged — those fields already exist from Sprint 2.

## Capabilities

### New Capabilities
- `match-reminders`: Schedule local notifications at user-selected offsets before kickoff. Covers permission flow, schedule/cancel lifecycle, edge cases (match started, past offsets, permission denied).
- `replay-planner`: Defer a match for later viewing with spoiler-shield visual mode. Covers plan/cancel lifecycle, datetime validation, spoiler shield trigger window, banner + badge UI.

### Modified Capabilities
- None. Existing `match-scheduler` and `match-data-store` capabilities stay as-is.

## Impact

### Affected code
- `app/pubspec.yaml` — add `app_settings`.
- `app/lib/core/notifications/notification_service.dart` — real implementation replacing Sprint 1 stub.
- `app/lib/main.dart` — add NotificationService.initialize() to boot sequence.
- `app/lib/features/reminders/` — new feature directory (5 files).
- `app/lib/features/replay_planner/` — new feature directory (4 files).
- `app/lib/features/matches/presentation/match_detail_screen.dart` — enable buttons + integrate banner.
- `app/lib/features/matches/presentation/widgets/match_card.dart` — show spoiler badge when applicable.
- `app/test/features/matches/match_repository_test.dart` → renamed to `match_model_test.dart`.
- `app/integration_test/match_repository_integration_test.dart` — new file, real Isar CRUD.
- `app/test/features/matches/match_list_screen_test.dart` — extend with mock-repo widget test.
- `app/test/features/matches/manual_add_screen_test.dart` — extend with past-date test.
- `app/test/features/reminders/` — new test directory (3 files: reminder_scheduler, reminder_sheet, plus notification_service test under `app/test/core/notifications/`).
- `app/test/features/replay_planner/` — new test directory (3 files: controller, dialog, spoiler_banner widget).

### Permissions / native config
- Android: `POST_NOTIFICATIONS` permission entry already standard since Android 13; verify AndroidManifest.xml has it.
- iOS: notification permission triggered programmatically; no Info.plist change needed beyond standard `flutter_local_notifications` requirements.

### Build pipeline
- No new code-gen requirements beyond Sprint 2 (Match Isar schema unchanged).

### No backend / external systems
- All notifications scheduled locally via `flutter_local_notifications`. No push, no server.
