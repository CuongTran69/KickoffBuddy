import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/core/network/api_models.dart';
import 'package:kickoff_buddy/features/matches/application/match_polling_controller.dart';

/// Helper to build a minimal [ApiMatch] with a given status.
ApiMatch _makeApiMatch(String status) {
  return ApiMatch(
    id: 1,
    venue: 'Test Venue',
    location: 'Test City',
    status: status,
    stageName: 'Group Stage',
    homeTeamCountry: 'Team A',
    awayTeamCountry: 'Team B',
    datetime: DateTime.utc(2026, 6, 14, 18, 0, 0),
    homeTeam: const ApiTeamResult(
      country: 'Team A',
      name: 'Team A',
      goals: 0,
      penalties: 0,
    ),
    awayTeam: const ApiTeamResult(
      country: 'Team B',
      name: 'Team B',
      goals: 0,
      penalties: 0,
    ),
  );
}

void main() {
  final now = DateTime.utc(2026, 6, 14, 19, 0, 0);

  group('pollIntervalFor', () {
    test('returns 5 minutes when at least one match is in_progress', () {
      final today = [
        _makeApiMatch('in_progress'),
        _makeApiMatch('future_scheduled'),
        _makeApiMatch('completed'),
      ];
      final result = pollIntervalFor(today: today, now: now);
      expect(result, const Duration(minutes: 5));
    });

    test('returns 5 minutes when only one match is in_progress', () {
      final today = [_makeApiMatch('in_progress')];
      final result = pollIntervalFor(today: today, now: now);
      expect(result, const Duration(minutes: 5));
    });

    test('returns 10 minutes when no in_progress but at least one future_scheduled', () {
      final today = [
        _makeApiMatch('future_scheduled'),
        _makeApiMatch('completed'),
      ];
      final result = pollIntervalFor(today: today, now: now);
      expect(result, const Duration(minutes: 10));
    });

    test('returns 10 minutes when only future_scheduled matches', () {
      final today = [
        _makeApiMatch('future_scheduled'),
        _makeApiMatch('future_scheduled'),
      ];
      final result = pollIntervalFor(today: today, now: now);
      expect(result, const Duration(minutes: 10));
    });

    test('returns null when all matches are completed', () {
      final today = [
        _makeApiMatch('completed'),
        _makeApiMatch('completed'),
      ];
      final result = pollIntervalFor(today: today, now: now);
      expect(result, isNull);
    });

    test('returns null for an empty list', () {
      final result = pollIntervalFor(today: [], now: now);
      expect(result, isNull);
    });

    test('in_progress takes priority over future_scheduled', () {
      final today = [
        _makeApiMatch('future_scheduled'),
        _makeApiMatch('in_progress'),
      ];
      final result = pollIntervalFor(today: today, now: now);
      expect(result, const Duration(minutes: 5));
    });
  });
}
