import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/matches/data/match.dart';

/// Stream provider that emits [DateTime.now()] every 60 seconds.
///
/// Used by spoiler shield widgets to re-evaluate the shield window
/// without requiring a full rebuild cycle.
final shieldClockProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(
    const Duration(seconds: 60),
    (_) => DateTime.now(),
  ).startWith(DateTime.now());
});

/// Returns true if the spoiler shield is currently active for [match].
///
/// Shield is active when ALL three conditions hold:
/// 1. [match.replayPlannerEnabled] is true.
/// 2. [now] is after [match.kickoffAtUtc].
/// 3. [now] is before [match.replayPlannedAt].
bool isShieldActive(Match match, DateTime now) {
  if (!match.replayPlannerEnabled) return false;
  if (match.replayPlannedAt == null) return false;
  final kickoffUtc = match.kickoffAtUtc.toUtc();
  final plannedAtUtc = match.replayPlannedAt!.toUtc();
  final nowUtc = now.toUtc();
  return nowUtc.isAfter(kickoffUtc) && nowUtc.isBefore(plannedAtUtc);
}

/// Extension on [Stream] to add a startWith operator.
extension _StartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
