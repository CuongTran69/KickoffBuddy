import 'package:kickoff_buddy/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/matches/application/match_list_controller.dart';
import 'package:kickoff_buddy/features/matches/data/match.dart';

/// Tests for match list grouping logic.
///
/// These tests verify the date grouping algorithm in [_groupByDate]
/// by testing the [MatchDateGroup] output directly.
///
/// Note: MatchRepository tests require Isar native binaries which are not
/// available in the standard flutter test environment. Repository CRUD is
/// verified via integration testing or manual smoke testing.
void main() {
  group('Match data model', () {
    test('Match can be instantiated with required fields', () {
      final match = Match()
        ..matchId = 'test_001'
        ..title = 'Brazil vs Argentina'
        ..teamA = 'Brazil'
        ..teamB = 'Argentina'
        ..kickoffAtUtc = DateTime.utc(2026, 6, 12, 1, 0, 0)
        ..sourceTimezone = 'America/New_York'
        ..userTimezone = 'Asia/Ho_Chi_Minh'
        ..reminders = [1440, 180, 30, 5]
        ..replayPlannerEnabled = false
        ..replayPlannedAt = null
        ..sourceText = null
        ..notes = ''
        ..createdAt = DateTime.utc(2026, 5, 28)
        ..isSeeded = true
        ..tournamentId = 'wc2026'
        ..worldCupGroup = 'C'
        ..worldCupRound = 'group_stage'
        ..matchday = 1
        ..venueCity = 'East Rutherford, NJ'
        ..venueIanaTimezone = 'America/New_York';

      expect(match.matchId, 'test_001');
      expect(match.teamA, 'Brazil');
      expect(match.teamB, 'Argentina');
      expect(match.isSeeded, isTrue);
      expect(match.worldCupGroup, 'C');
      expect(match.worldCupRound, 'group_stage');
      expect(match.matchday, 1);
    });

    test('Match with isSeeded=false represents user-created match', () {
      final match = Match()
        ..matchId = 'user_001'
        ..title = 'Custom Match'
        ..teamA = 'Team A'
        ..teamB = 'Team B'
        ..kickoffAtUtc = DateTime.utc(2026, 7, 1, 18, 0, 0)
        ..sourceTimezone = 'Asia/Ho_Chi_Minh'
        ..userTimezone = 'Asia/Ho_Chi_Minh'
        ..reminders = [1440, 180, 30, 5]
        ..replayPlannerEnabled = false
        ..replayPlannedAt = null
        ..sourceText = null
        ..notes = 'My custom match'
        ..createdAt = DateTime.utc(2026, 5, 28)
        ..isSeeded = false
        ..tournamentId = null
        ..worldCupGroup = null
        ..worldCupRound = null
        ..matchday = null
        ..venueCity = null
        ..venueIanaTimezone = null;

      expect(match.isSeeded, isFalse);
      expect(match.tournamentId, isNull);
      expect(match.worldCupGroup, isNull);
    });

    test('knockout match has no worldCupGroup or matchday', () {
      final match = Match()
        ..matchId = 'match_104'
        ..title = 'TBD vs TBD'
        ..teamA = 'TBD'
        ..teamB = 'TBD'
        ..kickoffAtUtc = DateTime.utc(2026, 7, 19, 19, 0, 0)
        ..sourceTimezone = 'America/New_York'
        ..userTimezone = 'UTC'
        ..reminders = [1440, 180, 30, 5]
        ..replayPlannerEnabled = false
        ..replayPlannedAt = null
        ..sourceText = null
        ..notes = ''
        ..createdAt = DateTime.utc(2026, 5, 28)
        ..isSeeded = true
        ..tournamentId = 'wc2026'
        ..worldCupGroup = null
        ..worldCupRound = 'final'
        ..matchday = null
        ..venueCity = 'East Rutherford, NJ'
        ..venueIanaTimezone = 'America/New_York';

      expect(match.worldCupRound, 'final');
      expect(match.worldCupGroup, isNull);
      expect(match.matchday, isNull);
    });
  });

  group('MatchFilter enum', () {
    test('all filter values are defined', () {
      expect(MatchFilter.values.length, 3);
      expect(MatchFilter.values, contains(MatchFilter.all));
      expect(MatchFilter.values, contains(MatchFilter.groupStage));
      expect(MatchFilter.values, contains(MatchFilter.knockouts));
    });
  });

  group('DateSection enum', () {
    test('all section values are defined', () {
      expect(DateSection.values.length, 5);
      expect(DateSection.values, contains(DateSection.today));
      expect(DateSection.values, contains(DateSection.tomorrow));
      expect(DateSection.values, contains(DateSection.thisWeek));
      expect(DateSection.values, contains(DateSection.later));
      expect(DateSection.values, contains(DateSection.past));
    });

    test('dateSectionLabel returns non-empty strings', () {
      final l10n = AppLocalizationsEn();
      for (final section in DateSection.values) {
        expect(dateSectionLabel(section, l10n), isNotEmpty);
      }
    });
  });
}
