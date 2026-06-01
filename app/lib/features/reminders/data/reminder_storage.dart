import '../../../features/matches/data/match.dart';
import '../../../features/matches/data/match_repository.dart';

/// Helper functions for persisting reminder offsets to the [Match] Isar record.
///
/// These are thin wrappers around [MatchRepository] — no business logic here.

/// Saves [offsets] to [match.reminders] via repository upsert.
///
/// Creates a copy of [match] with the new reminders list and upserts it.
Future<void> saveReminders(
  MatchRepository repo,
  Match match,
  List<int> offsets,
) async {
  // Isar objects are mutable — update in place and upsert.
  match.reminders = List<int>.from(offsets);
  await repo.upsert(match);
}

/// Loads the current reminder offsets for [matchId] from the repository.
///
/// Returns an empty list if the match is not found.
Future<List<int>> loadReminders(
  MatchRepository repo,
  String matchId,
) async {
  final match = await repo.getById(matchId);
  return match?.reminders ?? [];
}
