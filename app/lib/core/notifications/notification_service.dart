/// Notification service skeleton.
/// Sprint 3 implements the actual scheduling logic.
/// This file exists so import paths are stable from Sprint 1.
class NotificationService {
  NotificationService._();

  /// Initialize the notification plugin.
  /// TODO(Sprint 3): configure flutter_local_notifications channels.
  Future<void> initialize() async {
    // TODO(Sprint 3): implement
  }

  /// Request notification permissions from the OS.
  /// TODO(Sprint 3): implement platform-specific permission request.
  Future<bool> requestPermissions() async {
    // TODO(Sprint 3): implement
    return false;
  }

  /// Schedule a pre-match reminder for a given match.
  ///
  /// [matchId] — unique identifier for the match.
  /// [kickoffUtc] — UTC kickoff time.
  /// [minutesBefore] — how many minutes before kickoff to fire the reminder.
  /// TODO(Sprint 3): implement with flutter_local_notifications.
  Future<void> scheduleMatchReminder({
    required String matchId,
    required DateTime kickoffUtc,
    int minutesBefore = 30,
  }) async {
    // TODO(Sprint 3): implement
  }

  /// Cancel a previously scheduled reminder.
  /// TODO(Sprint 3): implement.
  Future<void> cancelMatchReminder(String matchId) async {
    // TODO(Sprint 3): implement
  }
}
