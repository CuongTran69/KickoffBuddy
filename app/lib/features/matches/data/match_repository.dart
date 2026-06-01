import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/storage/isar_provider.dart';
import 'match.dart';

/// Repository providing CRUD operations over the [Match] Isar collection.
///
/// All methods are async and use Isar transactions where required.
/// Exposed via [matchRepositoryProvider].
class MatchRepository {
  const MatchRepository(this._isar);

  final Isar _isar;

  /// Returns all matches sorted by kickoff time ascending.
  Future<List<Match>> getAll() async {
    return _isar.matchs
        .where()
        .sortByKickoffAtUtc()
        .findAll();
  }

  /// Returns the match with the given application-level [matchId], or null.
  Future<Match?> getById(String matchId) async {
    return _isar.matchs
        .where()
        .matchIdEqualTo(matchId)
        .findFirst();
  }

  /// Returns all group-stage matches for the given [group] letter (A-L).
  Future<List<Match>> getByGroup(String group) async {
    return _isar.matchs
        .filter()
        .worldCupGroupEqualTo(group)
        .sortByKickoffAtUtc()
        .findAll();
  }

  /// Returns all matches for the given [round] string
  /// (e.g. "group_stage", "round_of_16", "final").
  Future<List<Match>> getByRound(String round) async {
    return _isar.matchs
        .filter()
        .worldCupRoundEqualTo(round)
        .sortByKickoffAtUtc()
        .findAll();
  }

  /// Inserts or replaces a match. Uses the [matchId] unique index for upsert.
  Future<void> upsert(Match match) async {
    await _isar.writeTxn(() async {
      await _isar.matchs.put(match);
    });
  }

  /// Deletes the match with the given application-level [matchId].
  Future<void> delete(String matchId) async {
    final match = await getById(matchId);
    if (match == null) return;
    await _isar.writeTxn(() async {
      await _isar.matchs.delete(match.id);
    });
  }

  /// Returns a stream that emits the full match list whenever any match
  /// is added, modified, or removed.
  Stream<List<Match>> watchAll() {
    return _isar.matchs
        .where()
        .sortByKickoffAtUtc()
        .watch(fireImmediately: true);
  }

  /// Returns a stream that emits the match with the given [matchId] whenever
  /// it is created, updated, or deleted. Emits null when no match is found.
  Stream<Match?> watchById(String matchId) {
    return _isar.matchs
        .where()
        .matchIdEqualTo(matchId)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }
}

/// Riverpod provider for [MatchRepository].
///
/// Awaits [isarProvider] before constructing the repository, so callers
/// receive [AsyncValue.loading] until Isar is ready.
final matchRepositoryProvider = FutureProvider<MatchRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return MatchRepository(isar);
});
