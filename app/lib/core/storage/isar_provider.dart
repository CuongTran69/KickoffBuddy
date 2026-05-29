// Sprint 2 implementation note:
// Isar 4.x was attempted first (D1) but is not yet published on pub.dev.
// Fell back to Isar 3.x + downgraded riverpod_generator to ^2.4.0 to resolve
// the analyzer version conflict. riverpod_lint is omitted (D1 fallback).
// Chosen path: Isar 3.1.0+1 + isar_generator 3.1.0+1 + riverpod_generator 2.4.0.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/matches/data/match.dart';

/// Opens the Isar database with the [MatchSchema] and returns the instance.
///
/// Uses [path_provider.getApplicationDocumentsDirectory] for the storage path.
/// The database is named "kickoff_buddy".
///
/// Error handling: if [Isar.open] throws, the error propagates through
/// [AsyncValue] so the UI can surface it via [AsyncValue.error].
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [MatchSchema],
    directory: dir.path,
    name: 'kickoff_buddy',
  );
});
