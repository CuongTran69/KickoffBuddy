import 'package:timezone/timezone.dart' as tz;

/// Pure functions for reminder scheduling logic.
///
/// No I/O, no plugin calls — all functions are deterministic and testable.
/// Design decisions:
/// - D3: Notification IDs are stable hashes of (matchId + suffix).
/// - D4: All fire times use [tz.TZDateTime], never raw [DateTime].

/// Preset reminder offsets in minutes before kickoff.
const kReminderOffsets = [1440, 180, 30, 5];

/// Result of filtering reminder offsets against the current time.
class ReminderOffsetFilterResult {
  const ReminderOffsetFilterResult({
    required this.kept,
    required this.skipped,
  });

  /// Offsets whose computed fire time is strictly in the future.
  final List<int> kept;

  /// Offsets whose computed fire time is in the past or present.
  final List<int> skipped;
}

/// Returns a deterministic notification ID for a match + offset combination.
///
/// Uses [String.hashCode] on the composite key. Collision probability is
/// ~2.5e-7 across 104 matches × 5 offsets — acceptable for MVP (D3).
int notificationIdFor(String matchId, int offsetMinutes) {
  return ('${matchId}_$offsetMinutes').hashCode.abs();
}

/// Returns a deterministic notification ID for a match's replay reminder.
///
/// Uses the suffix "_replay" to distinguish from offset-based IDs (D3).
int replayNotificationIdFor(String matchId) {
  return ('${matchId}_replay').hashCode.abs();
}

/// Computes the fire time for a reminder as [tz.TZDateTime] in the local TZ.
///
/// Returns [kickoffUtc] converted to local TZ, minus [offsetMinutes].
/// NEVER uses raw [DateTime] for the result (D4).
tz.TZDateTime computeFireTime(DateTime kickoffUtc, int offsetMinutes) {
  final kickoffLocal = tz.TZDateTime.from(kickoffUtc.toUtc(), tz.local);
  return kickoffLocal.subtract(Duration(minutes: offsetMinutes));
}

/// Filters [requested] offsets into kept (future) and skipped (past/present).
///
/// An offset is kept if its computed fire time is strictly after [now].
/// Returns a [ReminderOffsetFilterResult] with parallel kept/skipped lists.
ReminderOffsetFilterResult filterValidOffsets(
  List<int> requested,
  DateTime kickoffUtc,
  DateTime now,
) {
  final kept = <int>[];
  final skipped = <int>[];

  for (final offset in requested) {
    final fireTime = computeFireTime(kickoffUtc, offset);
    if (fireTime.isAfter(now)) {
      kept.add(offset);
    } else {
      skipped.add(offset);
    }
  }

  return ReminderOffsetFilterResult(kept: kept, skipped: skipped);
}

/// Human-readable label for a reminder offset in minutes.
String offsetLabel(int offsetMinutes) {
  if (offsetMinutes >= 1440) {
    final days = offsetMinutes ~/ 1440;
    return days == 1 ? '1 ngày' : '$days ngày';
  } else if (offsetMinutes >= 60) {
    final hours = offsetMinutes ~/ 60;
    return hours == 1 ? '1 giờ' : '$hours giờ';
  } else {
    return '$offsetMinutes phút';
  }
}
