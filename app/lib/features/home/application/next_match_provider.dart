import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../matches/data/match.dart';
import '../../matches/data/match_repository.dart';

/// FutureProvider that returns the next upcoming [Match] (the one with the
/// earliest [kickoffAtUtc] strictly after now), or null if none exists.
///
/// Reads all matches from [matchRepositoryProvider] (already sorted ascending
/// by kickoff time), filters to those in the future, and returns the first.
final nextMatchProvider = FutureProvider<Match?>((ref) async {
  final repo = await ref.watch(matchRepositoryProvider.future);
  final all = await repo.getAll();
  final now = DateTime.now().toUtc();
  final upcoming = all.where(
    (m) => m.kickoffAtUtc.toUtc().isAfter(now),
  );
  return upcoming.isEmpty ? null : upcoming.first;
});
