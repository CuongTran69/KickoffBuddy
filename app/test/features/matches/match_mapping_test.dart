import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/core/network/api_models.dart';
import 'package:kickoff_buddy/features/matches/application/match_mapping.dart';
import 'package:kickoff_buddy/features/matches/data/match.dart';

/// Helper to build a minimal [Match] for testing.
Match _makeLocal({
  required String matchId,
  required String teamA,
  required String teamB,
  required DateTime kickoffAtUtc,
}) {
  return Match()
    ..matchId = matchId
    ..title = '$teamA vs $teamB'
    ..teamA = teamA
    ..teamB = teamB
    ..kickoffAtUtc = kickoffAtUtc
    ..sourceTimezone = 'UTC'
    ..userTimezone = 'UTC'
    ..reminders = []
    ..replayPlannerEnabled = false
    ..notes = ''
    ..createdAt = DateTime.utc(2026, 1, 1)
    ..isSeeded = true;
}

/// Helper to build a minimal [ApiMatch] for testing.
ApiMatch _makeApi({
  required String homeTeamName,
  required String awayTeamName,
  required DateTime datetime,
  int id = 1,
  String status = 'future_scheduled',
}) {
  return ApiMatch(
    id: id,
    venue: 'Test Venue',
    location: 'Test City',
    status: status,
    stageName: 'Group Stage',
    homeTeamCountry: homeTeamName,
    awayTeamCountry: awayTeamName,
    datetime: datetime,
    homeTeam: ApiTeamResult(
      country: homeTeamName,
      name: homeTeamName,
      goals: 0,
      penalties: 0,
    ),
    awayTeam: ApiTeamResult(
      country: awayTeamName,
      name: awayTeamName,
      goals: 0,
      penalties: 0,
    ),
  );
}

void main() {
  group('findLocalMatchFor', () {
    final day = DateTime.utc(2026, 6, 14, 18, 0, 0);
    final differentDay = DateTime.utc(2026, 6, 15, 18, 0, 0);

    final localMexicoSA = _makeLocal(
      matchId: 'match_001',
      teamA: 'Mexico',
      teamB: 'South Africa',
      kickoffAtUtc: day,
    );

    final localBrazilArg = _makeLocal(
      matchId: 'match_002',
      teamA: 'Brazil',
      teamB: 'Argentina',
      kickoffAtUtc: day,
    );

    final locals = [localMexicoSA, localBrazilArg];

    test('same day, same orientation returns the correct local match', () {
      final api = _makeApi(
        homeTeamName: 'Mexico',
        awayTeamName: 'South Africa',
        datetime: day,
      );
      final result = findLocalMatchFor(api, locals);
      expect(result, isNotNull);
      expect(result!.matchId, 'match_001');
    });

    test('same day, swapped orientation still returns the correct local match', () {
      final api = _makeApi(
        homeTeamName: 'South Africa',
        awayTeamName: 'Mexico',
        datetime: day,
      );
      final result = findLocalMatchFor(api, locals);
      expect(result, isNotNull);
      expect(result!.matchId, 'match_001');
    });

    test('case and whitespace differences still match', () {
      final api = _makeApi(
        homeTeamName: '  mexico ',
        awayTeamName: 'SOUTH AFRICA',
        datetime: day,
      );
      final result = findLocalMatchFor(api, locals);
      expect(result, isNotNull);
      expect(result!.matchId, 'match_001');
    });

    test('same teams on a different UTC day returns null', () {
      final api = _makeApi(
        homeTeamName: 'Mexico',
        awayTeamName: 'South Africa',
        datetime: differentDay,
      );
      final result = findLocalMatchFor(api, locals);
      expect(result, isNull);
    });

    test('2022 API data does not corrupt 2026 fixtures', () {
      // Simulate 2022 API match: Qatar vs Ecuador on 2022-11-20.
      final api2022 = _makeApi(
        id: 1,
        homeTeamName: 'Qatar',
        awayTeamName: 'Ecuador',
        datetime: DateTime.utc(2022, 11, 20, 17, 0, 0),
      );
      // Local catalog only has 2026 fixtures.
      final result = findLocalMatchFor(api2022, locals);
      expect(result, isNull);
    });

    test('empty locals list returns null', () {
      final api = _makeApi(
        homeTeamName: 'Mexico',
        awayTeamName: 'South Africa',
        datetime: day,
      );
      final result = findLocalMatchFor(api, []);
      expect(result, isNull);
    });

    test('does not match a different pair on the same day', () {
      final api = _makeApi(
        homeTeamName: 'Mexico',
        awayTeamName: 'Argentina',
        datetime: day,
      );
      final result = findLocalMatchFor(api, locals);
      expect(result, isNull);
    });

    test('matches second entry in list when first does not match', () {
      final api = _makeApi(
        homeTeamName: 'Brazil',
        awayTeamName: 'Argentina',
        datetime: day,
      );
      final result = findLocalMatchFor(api, locals);
      expect(result, isNotNull);
      expect(result!.matchId, 'match_002');
    });
  });
}
