import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../matches/data/match.dart';
import '../../matches/data/match_repository.dart';

/// StreamProvider that returns the next upcoming [Match] (the one with the
/// earliest [kickoffAtUtc] strictly after now), or null if none exists.
///
/// Backed by [MatchRepository.watchAll] so score/status updates written by
/// background polling surface immediately on the home screen.
final nextMatchProvider = StreamProvider<Match?>((ref) async* {
  final repo = await ref.watch(matchRepositoryProvider.future);
  yield* repo.watchAll().map((all) {
    final now = DateTime.now().toUtc();
    final upcoming = all.where(
      (m) => m.kickoffAtUtc.toUtc().isAfter(now),
    );
    return upcoming.isEmpty ? null : upcoming.first;
  });
});
