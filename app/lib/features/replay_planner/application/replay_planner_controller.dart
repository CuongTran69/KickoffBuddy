import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/analytics/analytics_events.dart';
import '../../../core/analytics/analytics_provider.dart';
import '../../../core/constants/app_constants.dart';
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
    try {
      final repo = await ref.read(matchRepositoryProvider.future);
      final match = await repo.getById(matchId);
      if (match == null) return;
      state = ReplayPlanState(
        enabled: match.replayPlannerEnabled,
        plannedAt: match.replayPlannedAt,
      );
    } catch (e) {
      // Surface for diagnostics but keep the safe default state so the UI is
      // not stuck — the user can still create a fresh plan (design D7).
      debugPrint('[ReplayPlannerController] _loadInitial error: $e');
    }
  }

  /// Saves a replay plan for [match] at [plannedAt].
  ///
  /// Validates:
  /// - [plannedAt] must be strictly after [match.kickoffAtUtc].
  /// - [plannedAt] must be in the future.
  ///
  /// On success:
  /// - Cancels any existing replay reminder (D2).
  /// - Schedules a new reminder at [plannedAt] - pre-fire offset (D8).
  /// - Persists the plan to the match record atomically (design D5): the match
  ///   record is written FIRST and the exposed Notifier state is only updated
  ///   after that write succeeds. On failure the original record fields are
  ///   restored and the error is rethrown so the caller can show it.
  ///
  /// [notificationTitle]/[notificationBody] let the caller pass localized
  /// notification copy (design D8). They fall back to sensible defaults when
  /// omitted (e.g. in tests).
  Future<void> savePlan(
    Match match,
    DateTime plannedAt, {
    String? notificationTitle,
    String? notificationBody,
  }) async {
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

    // D5: persist FIRST so state never leads the write. Snapshot the original
    // record fields so we can roll back the in-memory match if the write fails.
    final prevEnabled = match.replayPlannerEnabled;
    final prevPlannedAt = match.replayPlannedAt;

    match.replayPlannerEnabled = true;
    match.replayPlannedAt = plannedAtUtc;
    try {
      await repo.upsert(match);
    } catch (e) {
      // Roll back the shared match so memory matches disk, then rethrow.
      match.replayPlannerEnabled = prevEnabled;
      match.replayPlannedAt = prevPlannedAt;
      rethrow;
    }

    // D2: Cancel existing replay reminder before scheduling new one.
    await notifService.cancel(replayNotificationIdFor(match.matchId));

    // D8: Schedule reminder before the planned replay time.
    final fireTime = tz.TZDateTime.from(plannedAtUtc, tz.local)
        .subtract(AppConstants.replayPrefireOffset);
    final id = replayNotificationIdFor(match.matchId);

    await notifService.scheduleAt(
      id,
      notificationTitle ?? 'Sắp đến giờ xem lại',
      notificationBody ?? '${match.teamA} vs ${match.teamB}',
      fireTime,
      payload: match.matchId,
    );

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
  /// Persists the cleared plan FIRST (design D5); only updates state and
  /// cancels the scheduled notification after the write succeeds. On write
  /// failure the original record fields are restored and the error rethrown.
  Future<void> cancelPlan(Match match) async {
    final notifService = ref.read(notificationServiceProvider);
    final repo = await ref.read(matchRepositoryProvider.future);

    final prevEnabled = match.replayPlannerEnabled;
    final prevPlannedAt = match.replayPlannedAt;

    match.replayPlannerEnabled = false;
    match.replayPlannedAt = null;
    try {
      await repo.upsert(match);
    } catch (e) {
      match.replayPlannerEnabled = prevEnabled;
      match.replayPlannedAt = prevPlannedAt;
      rethrow;
    }

    // Cancel the scheduled replay reminder after the record is cleared.
    await notifService.cancel(replayNotificationIdFor(match.matchId));

    state = const ReplayPlanState(enabled: false);
  }
}

/// Family provider for [ReplayPlannerController], keyed by match ID.
final replayPlannerControllerProvider = NotifierProvider.family<
    ReplayPlannerController, ReplayPlanState, String>(
  ReplayPlannerController.new,
);
