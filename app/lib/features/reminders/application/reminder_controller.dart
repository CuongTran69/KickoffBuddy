import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics_events.dart';
import '../../../core/analytics/analytics_provider.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../features/matches/data/match_repository.dart';
import '../application/reminder_scheduler.dart';
import '../data/reminder_storage.dart';

/// State for the reminder controller.
class RemindersState {
  const RemindersState({
    required this.selectedOffsets,
    required this.initialOffsets,
  });

  /// Currently selected offsets (may differ from persisted state).
  final Set<int> selectedOffsets;

  /// Offsets loaded from the match record at init time.
  final List<int> initialOffsets;

  RemindersState copyWith({
    Set<int>? selectedOffsets,
    List<int>? initialOffsets,
  }) {
    return RemindersState(
      selectedOffsets: selectedOffsets ?? this.selectedOffsets,
      initialOffsets: initialOffsets ?? this.initialOffsets,
    );
  }
}

/// Controller for the reminder bottom sheet, keyed by match ID.
///
/// Manages chip selection state and orchestrates the cancel-then-reschedule
/// pattern (D2) on save.
class ReminderController extends FamilyNotifier<RemindersState, String> {
  @override
  RemindersState build(String matchId) {
    // Load existing reminders asynchronously; start with empty state.
    _loadInitial(matchId);
    return const RemindersState(
      selectedOffsets: {},
      initialOffsets: [],
    );
  }

  Future<void> _loadInitial(String matchId) async {
    try {
      final repo = await ref.read(matchRepositoryProvider.future);
      final offsets = await loadReminders(repo, matchId);
      state = RemindersState(
        selectedOffsets: Set<int>.from(offsets),
        initialOffsets: List<int>.from(offsets),
      );
    } catch (e) {
      // Keep the empty default state so the sheet still works; log for
      // diagnostics (design D7 — no silent stuck UI).
      debugPrint('[ReminderController] _loadInitial error: $e');
    }
  }

  /// Toggles [offset] in the selected set.
  void toggleOffset(int offset) {
    final current = Set<int>.from(state.selectedOffsets);
    if (current.contains(offset)) {
      current.remove(offset);
    } else {
      current.add(offset);
    }
    state = state.copyWith(selectedOffsets: current);
  }

  /// Saves the current selection:
  /// 1. Cancels all existing notifications for this match (D2).
  /// 2. Filters out past offsets.
  /// 3. Schedules new notifications for kept offsets.
  /// 4. Persists the full selected set (including skipped) to the match record.
  ///
  /// [notificationTitleBuilder] receives the localized offset label for each
  /// kept offset and returns the localized notification title (design D8).
  /// [notificationBody] is the localized body. Both fall back to Vietnamese
  /// defaults when omitted (e.g. in tests). [labelFor] builds the per-offset
  /// label; defaults to [offsetLabel] with Vietnamese units.
  ///
  /// Returns a [ReminderSaveResult] describing what was scheduled and skipped.
  Future<ReminderSaveResult> save(
    String matchId, {
    String Function(String label)? notificationTitleBuilder,
    String? notificationBody,
    String Function(int offset)? labelFor,
  }) async {
    final repo = await ref.read(matchRepositoryProvider.future);
    final notifService = ref.read(notificationServiceProvider);
    final match = await repo.getById(matchId);
    if (match == null) {
      return const ReminderSaveResult(scheduled: [], skipped: []);
    }

    final selectedList = state.selectedOffsets.toList();

    // D2: Cancel all existing notifications for this match first.
    for (final offset in kReminderOffsets) {
      await notifService.cancel(notificationIdFor(matchId, offset));
    }

    // Filter offsets: skip those whose fire time is already past.
    final now = DateTime.now().toUtc();
    final filterResult = filterValidOffsets(
      selectedList,
      match.kickoffAtUtc,
      now,
    );

    // Schedule notifications for kept offsets.
    for (final offset in filterResult.kept) {
      final fireTime = computeFireTime(match.kickoffAtUtc, offset);
      final id = notificationIdFor(matchId, offset);
      final label = (labelFor ?? offsetLabel)(offset);
      final title = notificationTitleBuilder != null
          ? notificationTitleBuilder(label)
          : 'Trận đấu trong $label';
      await notifService.scheduleAt(
        id,
        title,
        notificationBody ?? '${match.teamA} vs ${match.teamB}',
        fireTime,
        payload: matchId,
      );
    }

    // Persist the full selected set (user's preference, even if some skipped).
    await saveReminders(repo, match, selectedList);

    // Fire analytics event after persistence.
    if (filterResult.kept.isNotEmpty) {
      final offsetsCsv = filterResult.kept.join(',');
      ref.read(analyticsServiceProvider).logEvent(
        AnalyticsEvents.reminderSet,
        {
          'count_total': filterResult.kept.length,
          'offsets_csv': offsetsCsv,
        },
      );
    }

    return ReminderSaveResult(
      scheduled: filterResult.kept,
      skipped: filterResult.skipped,
    );
  }
}

/// Result of a reminder save operation.
class ReminderSaveResult {
  const ReminderSaveResult({
    required this.scheduled,
    required this.skipped,
  });

  /// Offsets that were successfully scheduled.
  final List<int> scheduled;

  /// Offsets that were skipped because their fire time is in the past.
  final List<int> skipped;
}

/// Family provider for [ReminderController], keyed by match ID.
final reminderControllerProvider =
    NotifierProvider.family<ReminderController, RemindersState, String>(
  ReminderController.new,
);
