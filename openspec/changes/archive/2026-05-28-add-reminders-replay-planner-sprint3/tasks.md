## 1. Sprint 2 test gap fixes (folded in)

- [x] 1.1 Rename `app/test/features/matches/match_repository_test.dart` → `app/test/features/matches/match_model_test.dart` (content stays — it's model tests)
- [x] 1.2 Create `app/integration_test/match_repository_integration_test.dart` exercising real `MatchRepository` against a real Isar instance opened in a temp directory; cover: `getAll` after seed, `getById` hit + miss, `getByGroup("A")`, `getByRound("group_stage")`, `upsert` insert + update, `delete`, `watchAll` stream emits on insert
- [x] 1.3 In `app/test/features/matches/match_list_screen_test.dart`, add a widget test that mounts `MatchListScreen` inside a `ProviderScope` with `matchRepositoryProvider` overridden to a `_FakeMatchRepository` returning 3 mock matches (today/tomorrow/past in user TZ); pump and verify "Today", "Tomorrow", "Past" date section headers each render
- [x] 1.4 In `app/test/features/matches/manual_add_screen_test.dart`, add a "past date shows error" test: pump the screen, locate the date `TextField` or `OutlinedButton` that opens the picker, assert the rendered `firstDate` parameter equals `now.startOfDay()` (read via finder + widget tree introspection); if `firstDate` is not directly inspectable, instead assert that the Save button is disabled when no date has been picked and remains disabled if you call the date validation method directly with a past date
- [x] 1.5 Run `cd app && /Users/cuongtran/flutter/bin/flutter test` — confirm 44 existing tests + 2 new widget tests pass ← (verify: integration_test file compiles, all unit/widget tests pass, no regressions)

## 2. Pubspec + plugin setup

- [x] 2.1 Add `app_settings: ^5.1.1` to dependencies in `app/pubspec.yaml` (under existing UI block)
- [x] 2.2 Run `cd app && /Users/cuongtran/flutter/bin/flutter pub get` — exits 0 ← (verify: pub get succeeds, no version conflicts)

## 3. NotificationService real implementation

- [x] 3.1 Rewrite `app/lib/core/notifications/notification_service.dart`:
  - Class `NotificationService` with private `_plugin = FlutterLocalNotificationsPlugin()`
  - `Future<void> initialize()`: configure Android (`AndroidInitializationSettings('@mipmap/ic_launcher')`), iOS (`DarwinInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false)`), call `_plugin.initialize(...)`, then create the Android channel `match_reminders` with `Importance.high`, name "Match reminders", description "Notifications before match kickoff and replay time"
  - `Future<bool> requestPermissions()`: call iOS `requestPermissions(alert: true, badge: true, sound: true)` returning bool; on Android 13+, request via `_plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission()` returning bool; on older Android return true
  - `Future<void> scheduleAt(int id, String title, String body, tz.TZDateTime when, {String? payload})`: call `_plugin.zonedSchedule(id, title, body, when, NotificationDetails(android: ..., iOS: ...), androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, uiLocalNotificationDateInterpretation: ...)` — NEVER raw DateTime
  - `Future<void> cancel(int id)`: `_plugin.cancel(id)`
  - `Future<void> cancelAll()`: `_plugin.cancelAll()`
- [x] 3.2 Update `notificationServiceProvider` to expose the singleton instance (replacing Sprint 1 stub)
- [x] 3.3 In `app/lib/main.dart`, add `await NotificationService.initialize()` after timezone init and before `runApp` ← (verify: notification plugin initialized, channel created on Android, build/analyze clean)

## 4. Reminder scheduler (pure logic)

- [x] 4.1 Create `app/lib/features/reminders/application/reminder_scheduler.dart` exposing:
  - Function `int notificationIdFor(String matchId, int offsetMinutes)` returning `(matchId + "_" + offsetMinutes).hashCode.abs()`
  - Function `int replayNotificationIdFor(String matchId)` returning `(matchId + "_replay").hashCode.abs()`
  - Function `tz.TZDateTime computeFireTime(DateTime kickoffUtc, int offsetMinutes)` → returns `tz.TZDateTime.from(kickoffUtc.toUtc(), tz.local).subtract(Duration(minutes: offsetMinutes))`
  - Function `List<int> filterValidOffsets(List<int> requested, DateTime kickoffUtc, DateTime now)` returns offsets whose computed fire time is strictly after `now`; returns the skipped offsets via a parallel `List<int>` (or use a small result class `ReminderOffsetFilterResult { kept, skipped }`)
- [x] 4.2 No I/O in this file — pure functions, easy to unit test ← (verify: every function pure, deterministic, no plugin calls)

## 5. Reminder controller + storage

- [x] 5.1 Create `app/lib/features/reminders/data/reminder_storage.dart`:
  - Helper functions `Future<void> saveReminders(MatchRepository repo, Match match, List<int> offsets)` (copies match with new reminders, calls `upsert`) and `Future<List<int>> loadReminders(MatchRepository repo, String matchId)` (reads via `getById`)
- [x] 5.2 Create `app/lib/features/reminders/application/reminder_controller.dart`:
  - `class RemindersState { Set<int> selectedOffsets; List<int> initialOffsets; }`
  - `class ReminderController extends Notifier<RemindersState>` (or family-based by match ID)
  - Methods: `void toggleOffset(int offset)`, `Future<void> save(String matchId)` (calls cancel-then-reschedule + persist via reminder_storage)
  - Family provider: `final reminderControllerProvider = NotifierProvider.family<ReminderController, RemindersState, String>` keyed by match ID, init reads existing match.reminders ← (verify: state transitions correct, save invokes cancel-all then schedule each kept offset, persists offsets to repo)

## 6. Reminder bottom sheet UI

- [x] 6.1 Create `app/lib/features/reminders/presentation/widgets/reminder_offset_chip.dart`:
  - StatelessWidget receives `int offsetMinutes`, `bool selected`, `VoidCallback onTap`
  - Renders a `ChoiceChip` or `FilterChip` with label "1 day" / "3 hours" / "30 min" / "5 min" depending on offsetMinutes
- [x] 6.2 Create `app/lib/features/reminders/presentation/reminder_sheet.dart`:
  - Function `Future<void> showReminderSheet(BuildContext context, Match match)` opens `showModalBottomSheet`
  - Sheet content: title "Remind me before kickoff", 4 chips for 1440/180/30/5 (built from a const list), Save and Cancel buttons
  - On Save: invoke `ref.read(reminderControllerProvider(match.id).notifier).save(match.id)`; if any offsets were skipped (in past), show snackbar "Skipped Xm, Ym (already passed)"; close sheet ← (verify: sheet renders 4 chips, multi-select works, save persists offsets and shows skip snackbar correctly)

## 7. Permission gate flow

- [x] 7.1 In reminder_sheet.dart entry point (or helper before showing sheet):
  - Read SharedPreferences key `notification_permission_decision` (values: null/granted/denied)
  - If null → call `NotificationService.requestPermissions()`; persist result; if granted → open sheet; if denied → show explanatory dialog
  - If granted → open sheet directly
  - If denied → show explanatory dialog with "Open Settings" (uses `app_settings` package: `AppSettings.openAppSettings(type: AppSettingsType.notification)`) and "Cancel" buttons
- [x] 7.2 The explanatory dialog text reads: "Kickoff Buddy needs permission to send match reminders. Open Settings to enable notifications." ← (verify: first tap requests OS prompt; subsequent taps respect stored decision; deep link opens OS settings)

## 8. Match-started disabled state

- [x] 8.1 In `app/lib/features/matches/presentation/match_detail_screen.dart`, when rendering the "Set reminder" button, branch on `match.kickoffAtUtc.isBefore(DateTime.now().toUtc())`:
  - If true → render disabled label "Match started" (no tap handler)
  - If false → render enabled button that calls `showReminderSheet(context, match)` after permission gate ← (verify: kicked-off match shows label not button; upcoming match shows enabled button)

## 9. Replay Planner controller

- [x] 9.1 Create `app/lib/features/replay_planner/application/replay_planner_controller.dart`:
  - `class ReplayPlanState { bool enabled; DateTime? plannedAt; }`
  - `class ReplayPlannerController extends Notifier<ReplayPlanState>`
  - Methods: `Future<void> savePlan(Match match, DateTime plannedAt)` (validate plannedAt > kickoff && plannedAt > now; cancel previous replay reminder; schedule new replay reminder at `plannedAt - 5 min`; persist match with `replayPlannerEnabled=true, replayPlannedAt=plannedAt.toUtc()`); `Future<void> cancelPlan(Match match)` (cancel notification, persist match with enabled=false, plannedAt=null)
  - Family by match ID, init reads existing flags from match ← (verify: validation rules block bad input, save schedules notification, cancel both clears state and notification)

## 10. Replay Planner dialog UI

- [x] 10.1 Create `app/lib/features/replay_planner/presentation/replay_planner_dialog.dart`:
  - Function `Future<void> showReplayPlannerDialog(BuildContext context, Match match)` opens `showDialog` with `AlertDialog`
  - Body: date picker button + time picker button + selected datetime label
  - Validation: Save button disabled if picked datetime is null OR before max(kickoff, now)
  - Inline error text below picker when invalid: "Replay time must be after kickoff" or "Replay time must be in the future"
  - On Save: invoke `ref.read(replayPlannerControllerProvider(match.id).notifier).savePlan(match, plannedAt)`; close dialog with snackbar "Replay planned for [local time]"
  - On Cancel button (visible only if existing plan): show confirmation dialog → cancelPlan ← (verify: validation rules enforced, save persists and snackbars, cancel-with-existing-plan flow works)

## 11. Spoiler shield UI components

- [x] 11.1 Create `app/lib/features/replay_planner/presentation/widgets/spoiler_badge.dart`:
  - StatelessWidget rendering small badge with `Icons.shield_outlined`/`material_symbols_icons` shield + label "Protected"
  - Background uses theme `surfaceVariant`, foreground uses theme `onSurfaceVariant`
- [x] 11.2 Create `app/lib/features/replay_planner/presentation/widgets/spoiler_banner.dart`:
  - StatelessWidget receives `DateTime plannedAtLocal`; renders full-width Container with shield icon + text "Spoiler-protected until [day-of-week, HH:mm]"
  - Background `surfaceVariant`, padding 12dp
- [x] 11.3 Create `app/lib/features/replay_planner/application/shield_status_provider.dart`:
  - `final shieldClockProvider = StreamProvider<DateTime>` emitting `DateTime.now()` every 60 seconds via `Stream.periodic`
  - Function/provider `bool isShieldActive(Match match, DateTime now)` returns true iff `match.replayPlannerEnabled && now.isAfter(match.kickoffAtUtc) && match.replayPlannedAt != null && now.isBefore(match.replayPlannedAt!)` ← (verify: provider re-emits every 60s, shield logic correct for all 4 windows: before kickoff / during shield / after replay / no plan)

## 12. Wire Match Detail screen

- [x] 12.1 In `match_detail_screen.dart`:
  - Replace the disabled "Set reminder" tooltip button with the conditional logic from task 8.1
  - Replace the disabled "Plan replay" tooltip button with `OutlinedButton` that calls `showReplayPlannerDialog(context, match)`; if `match.replayPlannerEnabled == true` → render an additional "Cancel replay plan" button below
  - Add the spoiler banner at the top of the body Column when `isShieldActive(match, ref.watch(shieldClockProvider).valueOrNull ?? DateTime.now())` returns true
- [x] 12.2 Ensure existing Edit/Delete logic for `isSeeded == false` matches stays intact ← (verify: detail screen shows correct buttons in all 4 states: future-match no-plan, future-match planned, past-match no-plan, past-match planned-and-in-shield)

## 13. Wire Match Card

- [x] 13.1 In `app/lib/features/matches/presentation/widgets/match_card.dart`:
  - Receive shield status from `shieldClockProvider` + `isShieldActive`
  - When active → render `SpoilerBadge` in a corner of the card (top-right or alongside the date)
  - When not active → no badge ← (verify: badge appears on cards in shield window, hidden otherwise)

## 14. Tests for Sprint 3 features

- [x] 14.1 Create `app/test/core/notifications/notification_service_test.dart` — tests for the public API contract using a mock plugin instance: initialize is idempotent, schedule rejects past times (let scheduler caller filter), cancel(id) calls plugin.cancel
- [x] 14.2 Create `app/test/features/reminders/reminder_scheduler_test.dart` — 8+ tests:
  - `notificationIdFor` deterministic (same inputs → same output)
  - `notificationIdFor` differs for different match IDs and different offsets
  - `replayNotificationIdFor` differs from offset-based IDs
  - `computeFireTime` returns kickoff - offset in user TZ
  - `filterValidOffsets` keeps future offsets, drops past
  - `filterValidOffsets` returns parallel kept/skipped lists
  - DST transition handling (use `tz.getLocation('America/New_York')` and a date crossing March DST)
- [x] 14.3 Create `app/test/features/reminders/reminder_sheet_test.dart` — widget tests:
  - 4 chips render
  - Tapping a chip toggles selection
  - Save with no chips → snackbar "Reminders cleared"
  - Save with all chips → "Reminders saved" snackbar
  - Sheet shows existing reminders preselected
- [x] 14.4 Create `app/test/features/replay_planner/replay_planner_controller_test.dart` — 5+ tests:
  - Initial state from match (enabled=false, plannedAt=null)
  - savePlan with valid datetime updates state and persists
  - savePlan with datetime before kickoff throws or returns error
  - savePlan with datetime in past throws or returns error
  - cancelPlan clears state and persists
- [x] 14.5 Create `app/test/features/replay_planner/replay_planner_dialog_test.dart` — widget test for picker validation: Save disabled when picked time is before kickoff
- [x] 14.6 Create `app/test/features/replay_planner/widgets/spoiler_banner_test.dart` — widget test: banner visible when shield active, hidden when not
- [x] 14.7 Run `cd app && /Users/cuongtran/flutter/bin/flutter test` — all tests pass (44 prior + new ones from Sprint 3 + 2 new from Phase 1) ← (verify: full test suite passes, no Sprint 2 regressions, all Sprint 3 widget tests pass)

## 15. Final verification

- [x] 15.1 `cd app && /Users/cuongtran/flutter/bin/flutter pub get` exits 0
- [x] 15.2 `cd app && dart run build_runner build --delete-conflicting-outputs` exits 0 (no new generated code expected, but confirm clean)
- [x] 15.3 `cd app && /Users/cuongtran/flutter/bin/flutter analyze` reports "No issues found"
- [x] 15.4 `cd app && /Users/cuongtran/flutter/bin/flutter test` all unit + widget tests pass
- [x] 15.5 Spot-check `notification_service.dart` uses `tz.TZDateTime` only, never raw `DateTime` for schedules (grep confirms 0 hits of `_plugin.zonedSchedule.*DateTime[^.]`) ← (verify: all 4 checks pass; no time-handling violations; permission gate works on simulator; spoiler banner visible during shield window)
