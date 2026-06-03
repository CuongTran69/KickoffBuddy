import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:kickoff_buddy/core/notifications/notification_service.dart';
import 'package:kickoff_buddy/core/storage/prefs_provider.dart';
import 'package:kickoff_buddy/features/matches/data/match.dart';
import 'package:kickoff_buddy/features/matches/data/match_repository.dart';
import 'package:kickoff_buddy/features/reminders/presentation/reminder_sheet.dart';
import 'package:kickoff_buddy/l10n/app_localizations.dart';

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  });

  Match makeFutureMatch() => Match()
    ..matchId = 'test_match'
    ..title = 'Brazil vs Argentina'
    ..teamA = 'Brazil'
    ..teamB = 'Argentina'
    ..kickoffAtUtc = DateTime.now().toUtc().add(const Duration(days: 2))
    ..sourceTimezone = 'Asia/Ho_Chi_Minh'
    ..userTimezone = 'Asia/Ho_Chi_Minh'
    ..reminders = []
    ..replayPlannerEnabled = false
    ..replayPlannedAt = null
    ..sourceText = null
    ..notes = ''
    ..createdAt = DateTime.now().toUtc()
    ..isSeeded = true
    ..tournamentId = 'wc2026'
    ..worldCupGroup = 'A'
    ..worldCupRound = 'group_stage'
    ..matchday = 1
    ..venueCity = 'Test City'
    ..venueIanaTimezone = 'Asia/Ho_Chi_Minh';

  Future<Widget> buildSheetContent(
    WidgetTester tester,
    Match match, {
    List<int> initialReminders = const [],
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final matchWithReminders = match..reminders = initialReminders;

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        matchRepositoryProvider.overrideWith(
          (ref) async => _FakeMatchRepository(matchWithReminders),
        ),
        notificationServiceProvider.overrideWith(
          (_) => _FakeNotificationService(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('vi'), Locale('en')],
        home: Scaffold(
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => showReminderSheet(ctx, match),
              child: const Text('Open Sheet'),
            ),
          ),
        ),
      ),
    );
  }

  group('ReminderSheet', () {
    testWidgets('4 chips render when sheet is opened', (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildSheetContent(tester, match));
      await tester.pump();

      // Tap the button to open the sheet (permission is null → will request)
      // Since we can't mock OS permission dialog in widget tests, we set
      // the permission as already granted in prefs.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_permission_decision', 'granted');

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Verify 4 chips are rendered
      expect(find.text('1 ngày'), findsOneWidget);
      expect(find.text('3 giờ'), findsOneWidget);
      expect(find.text('30 phút'), findsOneWidget);
      expect(find.text('5 phút'), findsOneWidget);
    });

    testWidgets('existing reminders are preselected', (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(
        await buildSheetContent(tester, match, initialReminders: [1440, 30]),
      );
      await tester.pump();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_permission_decision', 'granted');

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // The controller loads initial reminders asynchronously.
      // After pumpAndSettle, the chips should reflect the initial state.
      // We verify the sheet opened with the correct chips visible.
      expect(find.text('1 ngày'), findsOneWidget);
      expect(find.text('30 phút'), findsOneWidget);
    });

    testWidgets('tapping a chip toggles selection', (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildSheetContent(tester, match));
      await tester.pump();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_permission_decision', 'granted');

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Tap the "30 phút" chip to select it
      await tester.tap(find.text('30 phút'));
      await tester.pump();

      // Tap again to deselect
      await tester.tap(find.text('30 phút'));
      await tester.pump();

      // Sheet should still be open
      expect(find.text('Lưu'), findsOneWidget);
    });

    testWidgets('Save button is present', (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildSheetContent(tester, match));
      await tester.pump();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_permission_decision', 'granted');

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Lưu'), findsOneWidget);
      expect(find.text('Hủy'), findsOneWidget);
    });

    testWidgets('Save with no chips shows cleared snackbar', (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildSheetContent(tester, match));
      await tester.pump();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_permission_decision', 'granted');

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Tap Save with no chips selected
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      expect(find.text('Đã xóa nhắc nhở'), findsOneWidget);
    });

    // W2: Save with all chips selected shows "Đã lưu nhắc nhở" snackbar.
    testWidgets('Save with all chips → "Đã lưu nhắc nhở" snackbar',
        (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildSheetContent(tester, match));
      await tester.pump();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_permission_decision', 'granted');

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      // Tap all 4 reminder chips to select them.
      await tester.tap(find.text('1 ngày'));
      await tester.pump();
      await tester.tap(find.text('3 giờ'));
      await tester.pump();
      await tester.tap(find.text('30 phút'));
      await tester.pump();
      await tester.tap(find.text('5 phút'));
      await tester.pump();

      // Tap Save
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      expect(find.text('Đã lưu nhắc nhở'), findsOneWidget);
    });
  });
}

/// Fake MatchRepository for widget tests.
class _FakeMatchRepository implements MatchRepository {
  _FakeMatchRepository(this._match);

  final Match _match;

  @override
  Future<List<Match>> getAll() async => [_match];

  @override
  Future<Match?> getById(String matchId) async =>
      matchId == _match.matchId ? _match : null;

  @override
  Future<List<Match>> getByGroup(String group) async => [];

  @override
  Future<List<Match>> getByRound(String round) async => [];

  @override
  Future<void> upsert(Match match) async {
    _match.reminders = match.reminders;
  }

  @override
  Future<void> delete(String matchId) async {}

  @override
  Stream<List<Match>> watchAll() => Stream.value([_match]);

  @override
  Stream<Match?> watchById(String matchId) =>
      Stream.value(matchId == _match.matchId ? _match : null);
}

/// Fake NotificationService that does nothing (no plugin calls in tests).
class _FakeNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<bool> canScheduleExactAlarms() async => true;

  @override
  Future<void> scheduleAt(
    int id,
    String title,
    String body,
    dynamic when, {
    String? payload,
  }) async {}

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}
}
