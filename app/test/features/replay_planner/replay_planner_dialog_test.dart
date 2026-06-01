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
import 'package:kickoff_buddy/features/replay_planner/presentation/replay_planner_dialog.dart';
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
    ..kickoffAtUtc = DateTime.utc(2026, 6, 12, 1, 0, 0)
    ..sourceTimezone = 'Asia/Ho_Chi_Minh'
    ..userTimezone = 'Asia/Ho_Chi_Minh'
    ..reminders = []
    ..replayPlannerEnabled = false
    ..replayPlannedAt = null
    ..sourceText = null
    ..notes = ''
    ..createdAt = DateTime.utc(2026, 5, 28)
    ..isSeeded = true
    ..tournamentId = 'wc2026'
    ..worldCupGroup = 'A'
    ..worldCupRound = 'group_stage'
    ..matchday = 1
    ..venueCity = 'Test City'
    ..venueIanaTimezone = 'Asia/Ho_Chi_Minh';

  Future<Widget> buildDialog(WidgetTester tester, Match match) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        matchRepositoryProvider.overrideWith(
          (ref) async => _FakeMatchRepository(match),
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
              onPressed: () => showReplayPlannerDialog(ctx, match),
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );
  }

  group('ReplayPlannerDialog', () {
    testWidgets('dialog opens with date and time picker buttons',
        (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildDialog(tester, match));
      await tester.pump();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Lên kế hoạch xem lại'), findsOneWidget);
      expect(find.text('Chọn ngày'), findsOneWidget);
      expect(find.text('Chọn giờ'), findsOneWidget);
    });

    testWidgets('Save button is disabled when no date/time picked',
        (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildDialog(tester, match));
      await tester.pump();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Find the Save button — it should be disabled (no date/time picked)
      final saveButtons = find.widgetWithText(FilledButton, 'Lưu');
      expect(saveButtons, findsOneWidget);

      final saveButton = tester.widget<FilledButton>(saveButtons);
      expect(saveButton.onPressed, isNull,
          reason: 'Save should be disabled when no date/time is picked');
    });

    testWidgets('Cancel plan button not shown when no plan exists',
        (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildDialog(tester, match));
      await tester.pump();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // "Hủy kế hoạch" should not appear when no plan exists
      expect(find.text('Hủy kế hoạch'), findsNothing);
    });

    testWidgets('Close button dismisses dialog', (tester) async {
      final match = makeFutureMatch();
      await tester.pumpWidget(await buildDialog(tester, match));
      await tester.pump();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Đóng'));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.text('Lên kế hoạch xem lại'), findsNothing);
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
  Future<void> upsert(Match match) async {}

  @override
  Future<void> delete(String matchId) async {}

  @override
  Stream<List<Match>> watchAll() => Stream.value([_match]);

  @override
  Stream<Match?> watchById(String matchId) =>
      Stream.value(matchId == _match.matchId ? _match : null);
}

/// Fake NotificationService that does nothing.
class _FakeNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermissions() async => true;

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
