// Background polling service for live score updates.
//
// Exposes:
//   - [pollIntervalFor]: pure function deciding the next poll interval.
//   - [MatchPollingController]: Riverpod-managed service owning a single Timer.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_models.dart';
import 'match_sync_service.dart';

/// Returns the polling interval based on today's matches and the current time.
///
/// - Any match `in_progress` → 5 minutes.
/// - No live match but at least one `future_scheduled` → 10 minutes.
/// - All completed or empty → null (stop polling).
///
/// This is a pure function with no side effects, making it unit-testable
/// without timers or Riverpod.
Duration? pollIntervalFor({
  required List<ApiMatch> today,
  required DateTime now,
}) {
  if (today.any((m) => m.status == 'in_progress')) {
    return const Duration(minutes: 5);
  }
  if (today.any((m) => m.status == 'future_scheduled')) {
    return const Duration(minutes: 10);
  }
  return null;
}

/// Lifecycle-aware background polling controller.
///
/// Owns a single [Timer] that calls [MatchSyncService.syncScores] silently
/// on each tick. The interval is re-evaluated after every run via
/// [pollIntervalFor]. Errors are caught and logged; polling continues.
///
/// Lifecycle is driven externally by a [WidgetsBindingObserver] wired at the
/// app root (see [app.dart]):
///   - resumed  → [onResumed]  (immediate sync + reschedule)
///   - paused / inactive / detached → [onBackground] (cancel timer)
class MatchPollingController {
  MatchPollingController(this._ref);

  final Ref _ref;
  Timer? _timer;

  /// Called when the app returns to the foreground.
  ///
  /// Runs an immediate sync then schedules the next tick.
  Future<void> onResumed() async {
    _cancelTimer();
    await _runPoll();
  }

  /// Called when the app goes to the background (paused/inactive/detached).
  void onBackground() {
    _cancelTimer();
  }

  /// Cancels the timer and releases resources.
  void dispose() {
    _cancelTimer();
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Future<void> _runPoll() async {
    try {
      await _ref.read(matchSyncServiceProvider)?.syncScores();
    } catch (e) {
      debugPrint('[MatchPollingController] poll error (continuing): $e');
    }

    // Re-evaluate interval after each run.
    final interval = await _computeInterval();
    if (interval != null) {
      _scheduleNext(interval);
    }
    // If interval is null, no timer is scheduled — polling self-stops.
  }

  Future<Duration?> _computeInterval() async {
    try {
      final client = _ref.read(apiClientProvider);
      final today = await client.getTodayMatches();
      return pollIntervalFor(today: today, now: DateTime.now());
    } catch (e) {
      debugPrint('[MatchPollingController] interval check error: $e');
      return null;
    }
  }

  void _scheduleNext(Duration interval) {
    _cancelTimer();
    _timer = Timer(interval, () async {
      await _runPoll();
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Riverpod provider for [MatchPollingController].
///
/// The controller is kept alive for the app lifetime; the lifecycle observer
/// in [app.dart] drives it.
final matchPollingControllerProvider =
    Provider<MatchPollingController>((ref) {
  final controller = MatchPollingController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});
