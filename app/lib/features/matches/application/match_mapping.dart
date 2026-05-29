// Shared helper for mapping API matches to local Isar fixtures.
//
// Used by both [MatchSyncService] (score sync) and the home screen
// live/today card tap handlers (navigation resolution).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_models.dart';
import '../data/match.dart';
import '../data/match_repository.dart';

/// Returns the local [Match] that corresponds to [apiMatch], or null if no
/// confident match is found.
///
/// A confident match requires BOTH:
/// (a) Same UTC calendar day: [apiMatch.datetime] and [local.kickoffAtUtc]
///     share the same year, month, and day when both are converted to UTC.
/// (b) Team names match in either orientation — `(apiHome == teamA && apiAway
///     == teamB)` OR `(apiHome == teamB && apiAway == teamA)` — compared
///     case-insensitively with surrounding whitespace trimmed.
///
/// When no local match satisfies both conditions, returns null and the caller
/// MUST NOT write any data for that API match.
Match? findLocalMatchFor(ApiMatch apiMatch, List<Match> locals) {
  final apiDay = apiMatch.datetime.toUtc();
  final apiHome = apiMatch.homeTeam.name.trim().toLowerCase();
  final apiAway = apiMatch.awayTeam.name.trim().toLowerCase();

  for (final local in locals) {
    final localDay = local.kickoffAtUtc.toUtc();

    // (a) Same UTC calendar day.
    if (apiDay.year != localDay.year ||
        apiDay.month != localDay.month ||
        apiDay.day != localDay.day) {
      continue;
    }

    // (b) Team names match in either orientation.
    final localA = local.teamA.trim().toLowerCase();
    final localB = local.teamB.trim().toLowerCase();

    final sameOrientation = apiHome == localA && apiAway == localB;
    final swappedOrientation = apiHome == localB && apiAway == localA;

    if (sameOrientation || swappedOrientation) {
      return local;
    }
  }

  return null;
}

/// Provider that returns all local [Match] objects from Isar.
///
/// Used by the home screen to resolve API match cards to local match IDs
/// for safe navigation.
final allLocalMatchesProvider = FutureProvider<List<Match>>((ref) async {
  final repo = await ref.watch(matchRepositoryProvider.future);
  return repo.getAll();
});
