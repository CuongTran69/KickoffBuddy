import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/analytics/analytics_events.dart';
import '../../../core/analytics/analytics_provider.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../features/matches/data/match.dart';
import '../../../features/matches/data/match_repository.dart';
import '../../../features/reminders/application/reminder_scheduler.dart';

/// State for the replay planner controller.
class ReplayPlanState {
  const ReplayPlanState({
    required this.enabled,
    this.plannedAt,
  });

  /// Whether a replay plan is active for this match.
  final bool enabled;

  /// The planned replay time in UTC, or null if no plan.
  final DateTime? plannedAt;

  ReplayPlanState copyWith({
    bool? enabled,
    DateTime? plannedAt,
    bool clearPlannedAt = false,
  }) {
    return ReplayPlanState(
      enabled: enabled ?? this.enabled,
      plannedAt: clearPlannedAt ? null : (plannedAt ?? this.plannedAt),
    );
  }
}

/// Controller for the replay planner feature, keyed by match ID.
///
/// Manages plan/cancel lifecycle and orchestrates notification scheduling.
class ReplayPlannerController
    extends FamilyNotifier<ReplayPlanState, String> {
  @override
  ReplayPlanState build(String matchId) {
    // Initialize from the match record asynchronously.
    _loadInitial(matchId);
    return const ReplayPlanState(enabled: false);
  }

  Future<void> _loadInitial(String matchId) async {
    final repo = await ref.read(matchRepositoryProvider.future);
    final match = await repo.getById(matchId);
    if (match == null) return;
    state = ReplayPlanState(
      enabled: match.replayPlannerEnabled,
      plannedAt: match.replayPlannedAt,
    );
  }

  /// Saves a replay plan for [match] at [plannedAt].
  ///
  /// Validates:
  /// - [plannedAt] must be strictly after [match.kickoffAtUtc].
  /// - [plannedAt] must be in the future.
  ///
  /// On success:
  /// - Cancels any existing replay reminder (D2).
  /// - Schedules a new reminder at [plannedAt] - 5 min (D8).
  /// - Persists the plan to the match record.
  Future<void> savePlan(Match match, DateTime plannedAt) async {
    final now = DateTime.now().toUtc();
    final plannedAtUtc = plannedAt.toUtc();

    if (!plannedAtUtc.isAfter(match.kickoffAtUtc.toUtc())) {
      throw ArgumentError('Replay time must be after kickoff');
    }
    if (!plannedAtUtc.isAfter(now)) {
      throw ArgumentError('Replay time must be in the future');
    }

    final notifService = ref.read(notificationServiceProvider);
    final repo = await ref.read(matchRepositoryProvider.future);

    // D2: Cancel existing replay reminder before scheduling new one.
    await notifService.cancel(replayNotificationIdFor(match.matchId));

    // D8: Schedule reminder 5 minutes before replay.
    final fireTime = tz.TZDateTime.from(plannedAtUtc, tz.local)
        .subtract(const Duration(minutes: 5));
    final id = replayNotificationIdFor(match.matchId);

    await notifService.scheduleAt(
      id,
      'Sắp đến giờ xem lại',
      '${match.teamA} vs ${match.teamB}',
      fireTime,
      payload: match.matchId,
    );

    // Persist to match record.
    match.replayPlannerEnabled = true;
    match.replayPlannedAt = plannedAtUtc;
    await repo.upsert(match);

    // Fire analytics event after persistence.
    ref.read(analyticsServiceProvider).logEvent(
      AnalyticsEvents.replayPlannerSet,
      {'match_id': match.matchId},
    );

    state = ReplayPlanState(
      enabled: true,
      plannedAt: plannedAtUtc,
    );
  }

  /// Cancels the replay plan for [match].
  ///
  /// Cancels the scheduled notification and clears the plan from the record.
  Future<void> cancelPlan(Match match) async {
    final notifService = ref.read(notificationServiceProvider);
    final repo = await ref.read(matchRepositoryProvider.future);

    // Cancel the scheduled replay reminder.
    await notifService.cancel(replayNotificationIdFor(match.matchId));

    // Clear plan from match record.
    match.replayPlannerEnabled = false;
    match.replayPlannedAt = null;
    await repo.upsert(match);

    state = const ReplayPlanState(enabled: false);
  }
}

/// Family provider for [ReplayPlannerController], keyed by match ID.
final replayPlannerControllerProvider = NotifierProvider.family<
    ReplayPlannerController, ReplayPlanState, String>(
  ReplayPlannerController.new,
);
