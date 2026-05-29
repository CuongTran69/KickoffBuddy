import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_models.dart';
import '../data/match.dart';
import '../data/match_providers.dart';
import 'match_mapping.dart';

/// Service to synchronize match scores and status from the World Cup API to the local Isar database.
class MatchSyncService {
  MatchSyncService(this._isar, this._apiClient);

  final Isar _isar;
  final WorldCupApiClient _apiClient;

  /// Fetches all matches from the API and updates local Isar matches.
  ///
  /// Uses [findLocalMatchFor] (date + both team names, either orientation,
  /// case-insensitive/trimmed) to map each API match to a local fixture.
  /// Only writes when a confident match is found — never corrupts fixtures
  /// from a different tournament or date.
  ///
  /// Returns the count of local matches updated.
  Future<int> syncScores() async {
    try {
      final apiMatches = await _apiClient.getMatches();
      if (apiMatches.isEmpty) return 0;

      // Load all local matches once outside the write transaction.
      final locals = await _isar.matchs.where().findAll();
      if (locals.isEmpty) return 0;

      int updatedCount = 0;

      await _isar.writeTxn(() async {
        for (final ApiMatch apiMatch in apiMatches) {
          final local = findLocalMatchFor(apiMatch, locals);
          if (local == null) continue;

          local.scoreA = apiMatch.homeTeam.goals;
          local.scoreB = apiMatch.awayTeam.goals;
          // Only store penalty scores when they are meaningful (> 0).
          local.penaltyA = apiMatch.homeTeam.penalties > 0
              ? apiMatch.homeTeam.penalties
              : null;
          local.penaltyB = apiMatch.awayTeam.penalties > 0
              ? apiMatch.awayTeam.penalties
              : null;
          local.matchStatus = apiMatch.status;
          local.winner = apiMatch.winner;
          local.venueName = apiMatch.venue;
          local.attendance = apiMatch.attendance;

          await _isar.matchs.put(local);
          updatedCount++;
        }
      });

      debugPrint('[MatchSyncService] Successfully synced $updatedCount matches.');
      return updatedCount;
    } catch (e, stack) {
      debugPrint('[MatchSyncService] Error syncing matches: $e\n$stack');
      rethrow;
    }
  }
}

/// Riverpod provider for [MatchSyncService].
final matchSyncServiceProvider = Provider<MatchSyncService>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  final apiClient = ref.watch(apiClientProvider);
  return MatchSyncService(isar, apiClient);
});
