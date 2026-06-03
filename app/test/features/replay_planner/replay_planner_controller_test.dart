import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:kickoff_buddy/core/notifications/notification_service.dart';
import 'package:kickoff_buddy/features/matches/data/match.dart';
import 'package:kickoff_buddy/features/matches/data/match_repository.dart';
import 'package:kickoff_buddy/features/replay_planner/application/replay_planner_controller.dart';

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  });

  Match makeMatch({bool enabled = false, DateTime? plannedAt}) => Match()
    ..matchId = 'test_match'
    ..title = 'Brazil vs Argentina'
    ..teamA = 'Brazil'
    ..teamB = 'Argentina'
    ..kickoffAtUtc = DateTime.utc(2026, 6, 12, 1, 0, 0)
    ..sourceTimezone = 'Asia/Ho_Chi_Minh'
    ..userTimezone = 'Asia/Ho_Chi_Minh'
    ..reminders = []
    ..replayPlannerEnabled = enabled
    ..replayPlannedAt = plannedAt
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

  ProviderContainer makeContainer(Match match) {
    return ProviderContainer(
      overrides: [
        matchRepositoryProvider.overrideWith(
          (ref) async => _FakeMatchRepository(match),
        ),
        notificationServiceProvider.overrideWith(
          (_) => _FakeNotificationService(),
        ),
      ],
    );
  }

  group('ReplayPlannerController', () {
    test('initial state is disabled with no plannedAt', () {
      final match = makeMatch();
      final container = makeContainer(match);
      addTearDown(container.dispose);

      final state =
          container.read(replayPlannerControllerProvider('test_match'));
      expect(state.enabled, isFalse);
      expect(state.plannedAt, isNull);
    });

    test('savePlan with valid datetime updates state', () async {
      final match = makeMatch();
      final container = makeContainer(match);
      addTearDown(container.dispose);

      final controller = container
          .read(replayPlannerControllerProvider('test_match').notifier);

      // Plan for 2 days after kickoff, in the future
      final plannedAt = DateTime.utc(2026, 6, 14, 20, 0, 0);
      await controller.savePlan(match, plannedAt);

      final state =
          container.read(replayPlannerControllerProvider('test_match'));
      expect(state.enabled, isTrue);
      expect(state.plannedAt, isNotNull);
    });

    test('savePlan with datetime before kickoff throws', () async {
      final match = makeMatch();
      final container = makeContainer(match);
      addTearDown(container.dispose);

      final controller = container
          .read(replayPlannerControllerProvider('test_match').notifier);

      // Before kickoff (kickoff is 2026-06-12 01:00 UTC)
      final beforeKickoff = DateTime.utc(2026, 6, 11, 12, 0, 0);

      expect(
        () => controller.savePlan(match, beforeKickoff),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('savePlan with datetime in the past throws', () async {
      final match = makeMatch();
      final container = makeContainer(match);
      addTearDown(container.dispose);

      final controller = container
          .read(replayPlannerControllerProvider('test_match').notifier);

      // Past datetime (well before kickoff and now)
      final pastTime = DateTime.utc(2020, 1, 1, 12, 0, 0);

      expect(
        () => controller.savePlan(match, pastTime),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('cancelPlan clears state and persists', () async {
      final plannedAt = DateTime.utc(2026, 6, 14, 20, 0, 0);
      final match = makeMatch(enabled: true, plannedAt: plannedAt);
      final container = makeContainer(match);
      addTearDown(container.dispose);

      final controller = container
          .read(replayPlannerControllerProvider('test_match').notifier);

      await controller.cancelPlan(match);

      final state =
          container.read(replayPlannerControllerProvider('test_match'));
      expect(state.enabled, isFalse);
      expect(state.plannedAt, isNull);
    });
  });
}

/// Fake MatchRepository for unit tests.
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
    _match.replayPlannerEnabled = match.replayPlannerEnabled;
    _match.replayPlannedAt = match.replayPlannedAt;
  }

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
