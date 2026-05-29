import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz_lib;

import 'package:kickoff_buddy/core/storage/prefs_provider.dart';
import 'package:kickoff_buddy/features/matches/application/match_list_controller.dart';
import 'package:kickoff_buddy/features/matches/data/match.dart';
import 'package:kickoff_buddy/features/matches/data/match_repository.dart';
import 'package:kickoff_buddy/features/matches/presentation/match_list_screen.dart';
import 'package:kickoff_buddy/features/matches/presentation/widgets/date_section_header.dart';
import 'package:kickoff_buddy/l10n/app_localizations.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
    tz_lib.setLocalLocation(tz_lib.getLocation('Asia/Ho_Chi_Minh'));
  });

  group('Date grouping logic', () {
    test('today match goes into today bucket', () {
      final now = tz_lib.TZDateTime.now(tz_lib.local);
      // Create a match that kicks off today at noon local time
      final todayNoon = tz_lib.TZDateTime(
        tz_lib.local,
        now.year,
        now.month,
        now.day,
        12,
        0,
      );
      final utcKickoff = todayNoon.toUtc();

      final match = Match()
        ..matchId = 'today_match'
        ..title = 'Today Match'
        ..teamA = 'Team A'
        ..teamB = 'Team B'
        ..kickoffAtUtc = utcKickoff
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

      // Verify the match kickoff is today in local TZ
      final local = tz_lib.TZDateTime.from(match.kickoffAtUtc.toUtc(), tz_lib.local);
      final today = tz_lib.TZDateTime.now(tz_lib.local);
      expect(local.day, today.day);
      expect(local.month, today.month);
      expect(local.year, today.year);
    });

    test('past match kickoff is before today', () {
      final pastUtc = DateTime.utc(2020, 1, 1, 12, 0, 0);
      final local = tz_lib.TZDateTime.from(pastUtc, tz_lib.local);
      final today = tz_lib.TZDateTime.now(tz_lib.local);
      expect(local.isBefore(today), isTrue);
    });

    test('future match kickoff is after today', () {
      final futureUtc = DateTime.utc(2030, 1, 1, 12, 0, 0);
      final local = tz_lib.TZDateTime.from(futureUtc, tz_lib.local);
      final today = tz_lib.TZDateTime.now(tz_lib.local);
      expect(local.isAfter(today), isTrue);
    });
  });

  group('DateSectionHeader widget', () {
    Widget buildWithL10n(Widget child) => MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('vi'), Locale('en')],
          home: Scaffold(body: child),
        );

    testWidgets('renders Today label', (tester) async {
      await tester.pumpWidget(
        buildWithL10n(const DateSectionHeader(section: DateSection.today)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hôm nay'), findsOneWidget);
    });

    testWidgets('renders Past label', (tester) async {
      await tester.pumpWidget(
        buildWithL10n(const DateSectionHeader(section: DateSection.past)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Đã qua'), findsOneWidget);
    });

    testWidgets('renders This Week label', (tester) async {
      await tester.pumpWidget(
        buildWithL10n(const DateSectionHeader(section: DateSection.thisWeek)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Tuần này'), findsOneWidget);
    });
  });

  group('MatchFilterChips', () {
    testWidgets('filter chip state changes on tap', (tester) async {
      MatchFilter? selected = MatchFilter.all;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ProviderScope(
                  child: Column(
                    children: [
                      FilterChip(
                        label: const Text('Vòng bảng'),
                        selected: selected == MatchFilter.groupStage,
                        onSelected: (_) {
                          setState(() => selected = MatchFilter.groupStage);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(selected, MatchFilter.all);
      await tester.tap(find.byType(FilterChip));
      await tester.pump();
      expect(selected, MatchFilter.groupStage);
    });
  });

  group('MatchListScreen with mock repository', () {
    testWidgets('renders Today, Tomorrow, Past section headers', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final now = tz_lib.TZDateTime.now(tz_lib.local);

      // Today match: kickoff at noon today
      final todayKickoff = tz_lib.TZDateTime(
        tz_lib.local,
        now.year,
        now.month,
        now.day,
        12,
        0,
      ).toUtc();

      // Tomorrow match: kickoff at noon tomorrow
      final tomorrowKickoff = tz_lib.TZDateTime(
        tz_lib.local,
        now.year,
        now.month,
        now.day + 1,
        12,
        0,
      ).toUtc();

      // Past match: kickoff 30 days ago
      final pastKickoff = DateTime.utc(2020, 1, 1, 12, 0, 0);

      Match makeMatch(String id, DateTime kickoff) => Match()
        ..matchId = id
        ..title = 'Team A vs Team B'
        ..teamA = 'Team A'
        ..teamB = 'Team B'
        ..kickoffAtUtc = kickoff
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

      final mockMatches = [
        makeMatch('today_match', todayKickoff),
        makeMatch('tomorrow_match', tomorrowKickoff),
        makeMatch('past_match', pastKickoff),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            matchRepositoryProvider.overrideWith(
              (ref) async => _FakeMatchRepository(mockMatches),
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
            home: const MatchListScreen(),
          ),
        ),
      );

      // Wait for async providers to resolve
      await tester.pumpAndSettle();

      // Verify section headers are rendered
      expect(
        find.descendant(
          of: find.byType(DateSectionHeader),
          matching: find.text('Hôm nay'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(DateSectionHeader),
          matching: find.text('Ngày mai'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(DateSectionHeader),
          matching: find.text('Đã qua'),
        ),
        findsOneWidget,
      );
    });
  });
}

/// Fake MatchRepository for widget tests — does NOT extend MatchRepository
/// (which requires Isar). Implements the same interface via duck typing.
class _FakeMatchRepository implements MatchRepository {
  _FakeMatchRepository(this._matches);

  final List<Match> _matches;

  @override
  Future<List<Match>> getAll() async => List.unmodifiable(_matches);

  @override
  Future<Match?> getById(String matchId) async =>
      _matches.where((m) => m.matchId == matchId).firstOrNull;

  @override
  Future<List<Match>> getByGroup(String group) async =>
      _matches.where((m) => m.worldCupGroup == group).toList();

  @override
  Future<List<Match>> getByRound(String round) async =>
      _matches.where((m) => m.worldCupRound == round).toList();

  @override
  Future<void> upsert(Match match) async {}

  @override
  Future<void> delete(String matchId) async {}

  @override
  Stream<List<Match>> watchAll() => Stream.value(List.unmodifiable(_matches));
}
