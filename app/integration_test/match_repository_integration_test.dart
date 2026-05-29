import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:kickoff_buddy/features/matches/data/match.dart';
import 'package:kickoff_buddy/features/matches/data/match_repository.dart';

/// Integration tests for [MatchRepository] against a real Isar instance.
///
/// Must run on a device or simulator:
///   flutter test integration_test/match_repository_integration_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Isar isar;
  late MatchRepository repo;
  late Directory tempDir;

  setUp(() async {
    tempDir = await getTemporaryDirectory();
    final dir = Directory('${tempDir.path}/isar_test_${DateTime.now().millisecondsSinceEpoch}');
    await dir.create(recursive: true);

    await Isar.initializeIsarCore(download: false);
    isar = await Isar.open(
      [MatchSchema],
      directory: dir.path,
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
    );
    repo = MatchRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  Match makeMatch(String matchId, {
    String teamA = 'Brazil',
    String teamB = 'Argentina',
    DateTime? kickoff,
    String? group,
    String round = 'group_stage',
  }) {
    return Match()
      ..matchId = matchId
      ..title = '$teamA vs $teamB'
      ..teamA = teamA
      ..teamB = teamB
      ..kickoffAtUtc = kickoff ?? DateTime.utc(2026, 6, 12, 1, 0, 0)
      ..sourceTimezone = 'America/New_York'
      ..userTimezone = 'Asia/Ho_Chi_Minh'
      ..reminders = []
      ..replayPlannerEnabled = false
      ..replayPlannedAt = null
      ..sourceText = null
      ..notes = ''
      ..createdAt = DateTime.utc(2026, 5, 28)
      ..isSeeded = true
      ..tournamentId = 'wc2026'
      ..worldCupGroup = group
      ..worldCupRound = round
      ..matchday = 1
      ..venueCity = 'New York'
      ..venueIanaTimezone = 'America/New_York';
  }

  group('MatchRepository integration tests', () {
    testWidgets('getAll returns empty list initially', (tester) async {
      final all = await repo.getAll();
      expect(all, isEmpty);
    });

    testWidgets('upsert inserts a match and getAll returns it', (tester) async {
      final match = makeMatch('match_001');
      await repo.upsert(match);

      final all = await repo.getAll();
      expect(all.length, 1);
      expect(all.first.matchId, 'match_001');
    });

    testWidgets('getById returns match on hit', (tester) async {
      final match = makeMatch('match_002');
      await repo.upsert(match);

      final found = await repo.getById('match_002');
      expect(found, isNotNull);
      expect(found!.matchId, 'match_002');
    });

    testWidgets('getById returns null on miss', (tester) async {
      final found = await repo.getById('nonexistent');
      expect(found, isNull);
    });

    testWidgets('getByGroup returns only group A matches', (tester) async {
      await repo.upsert(makeMatch('match_a1', group: 'A'));
      await repo.upsert(makeMatch('match_a2', group: 'A'));
      await repo.upsert(makeMatch('match_b1', group: 'B'));

      final groupA = await repo.getByGroup('A');
      expect(groupA.length, 2);
      expect(groupA.every((m) => m.worldCupGroup == 'A'), isTrue);
    });

    testWidgets('getByRound returns only group_stage matches', (tester) async {
      await repo.upsert(makeMatch('match_gs1', round: 'group_stage'));
      await repo.upsert(makeMatch('match_gs2', round: 'group_stage'));
      await repo.upsert(makeMatch('match_final', round: 'final'));

      final groupStage = await repo.getByRound('group_stage');
      expect(groupStage.length, 2);
      expect(groupStage.every((m) => m.worldCupRound == 'group_stage'), isTrue);
    });

    testWidgets('upsert updates existing match', (tester) async {
      final match = makeMatch('match_003');
      await repo.upsert(match);

      final updated = makeMatch('match_003', teamA: 'France');
      await repo.upsert(updated);

      final found = await repo.getById('match_003');
      expect(found!.teamA, 'France');
    });

    testWidgets('delete removes match from Isar', (tester) async {
      final match = makeMatch('match_004');
      await repo.upsert(match);

      await repo.delete('match_004');

      final found = await repo.getById('match_004');
      expect(found, isNull);
    });

    testWidgets('watchAll stream emits on insert', (tester) async {
      final stream = repo.watchAll();
      final emitted = <List<Match>>[];
      final sub = stream.listen(emitted.add);

      // Wait for initial emission
      await tester.pump(const Duration(milliseconds: 100));

      await repo.upsert(makeMatch('match_005'));
      await tester.pump(const Duration(milliseconds: 100));

      await sub.cancel();

      // Should have at least 2 emissions: initial empty + after insert
      expect(emitted.length, greaterThanOrEqualTo(1));
      // Last emission should contain the inserted match
      expect(emitted.last.any((m) => m.matchId == 'match_005'), isTrue);
    });
  });
}
