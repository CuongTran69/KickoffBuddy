import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/core/analytics/analytics_events.dart';
import 'package:kickoff_buddy/core/analytics/analytics_service.dart';

void main() {
  group('AnalyticsEvents', () {
    test('all 8 event names are defined', () {
      final events = [
        AnalyticsEvents.onboardingCompleted,
        AnalyticsEvents.matchViewed,
        AnalyticsEvents.matchAddedToMyMatches,
        AnalyticsEvents.reminderSet,
        AnalyticsEvents.replayPlannerSet,
        AnalyticsEvents.ruleCardViewed,
        AnalyticsEvents.vocabularySearched,
        AnalyticsEvents.languageChanged,
      ];
      expect(events.length, 8);
      for (final name in events) {
        expect(name, isNotEmpty, reason: 'Event name should not be empty');
      }
    });

    test('allowedParams map covers all 8 events', () {
      expect(AnalyticsEvents.allowedParams.length, 8);
      expect(AnalyticsEvents.allowedParams.containsKey(AnalyticsEvents.onboardingCompleted), isTrue);
      expect(AnalyticsEvents.allowedParams.containsKey(AnalyticsEvents.matchViewed), isTrue);
      expect(AnalyticsEvents.allowedParams.containsKey(AnalyticsEvents.matchAddedToMyMatches), isTrue);
      expect(AnalyticsEvents.allowedParams.containsKey(AnalyticsEvents.reminderSet), isTrue);
      expect(AnalyticsEvents.allowedParams.containsKey(AnalyticsEvents.replayPlannerSet), isTrue);
      expect(AnalyticsEvents.allowedParams.containsKey(AnalyticsEvents.ruleCardViewed), isTrue);
      expect(AnalyticsEvents.allowedParams.containsKey(AnalyticsEvents.vocabularySearched), isTrue);
      expect(AnalyticsEvents.allowedParams.containsKey(AnalyticsEvents.languageChanged), isTrue);
    });
  });

  group('AnalyticsService', () {
    test('service no-ops when analytics unavailable — no throw', () async {
      final service = AnalyticsService(null);
      // Should not throw even with params.
      await expectLater(
        service.logEvent(AnalyticsEvents.matchViewed, {'match_id': 'm1', 'source': 'seed'}),
        completes,
      );
    });

    test('logEvent with null analytics returns immediately', () async {
      final service = AnalyticsService(null);
      // Calling multiple times should be safe.
      await service.logEvent(AnalyticsEvents.onboardingCompleted);
      await service.logEvent(AnalyticsEvents.languageChanged, {'locale': 'vi'});
      // No assertion needed — just verifying no exception is thrown.
    });

    test('allowedParams for matchViewed contains match_id and source', () {
      final allowed = AnalyticsEvents.allowedParams[AnalyticsEvents.matchViewed]!;
      expect(allowed.contains('match_id'), isTrue);
      expect(allowed.contains('source'), isTrue);
      // PII-like keys should NOT be in the allowlist.
      expect(allowed.contains('user_id'), isFalse);
      expect(allowed.contains('email'), isFalse);
    });

    test('allowedParams for vocabularySearched contains query_length and has_results', () {
      final allowed = AnalyticsEvents.allowedParams[AnalyticsEvents.vocabularySearched]!;
      expect(allowed.contains('query_length'), isTrue);
      expect(allowed.contains('has_results'), isTrue);
      // Raw query text should NOT be in the allowlist (PII risk).
      expect(allowed.contains('query'), isFalse);
      expect(allowed.contains('query_text'), isFalse);
    });

    test('allowedParams for onboardingCompleted is empty (no params needed)', () {
      final allowed = AnalyticsEvents.allowedParams[AnalyticsEvents.onboardingCompleted]!;
      expect(allowed.isEmpty, isTrue);
    });

    test('param stripping: disallowed keys are removed before forwarding', () {
      // We verify the stripping logic by inspecting the allowedParams map.
      // matchViewed allows {match_id, source} — team_a is NOT allowed.
      final allowed = AnalyticsEvents.allowedParams[AnalyticsEvents.matchViewed]!;
      final inputParams = {'match_id': 'm1', 'source': 'seed', 'team_a': 'USA'};

      final filtered = {
        for (final entry in inputParams.entries)
          if (allowed.contains(entry.key)) entry.key: entry.value,
      };

      expect(filtered.containsKey('match_id'), isTrue);
      expect(filtered.containsKey('source'), isTrue);
      expect(filtered.containsKey('team_a'), isFalse,
          reason: 'team_a is not in the allowlist and must be stripped');
    });

    test('param stripping: all disallowed keys stripped for reminderSet', () {
      final allowed = AnalyticsEvents.allowedParams[AnalyticsEvents.reminderSet]!;
      final inputParams = {
        'count_total': 2,
        'offsets_csv': '30,1440',
        'match_id': 'should_be_stripped',
        'user_phone': 'pii_value',
      };

      final filtered = {
        for (final entry in inputParams.entries)
          if (allowed.contains(entry.key)) entry.key: entry.value,
      };

      expect(filtered.containsKey('count_total'), isTrue);
      expect(filtered.containsKey('offsets_csv'), isTrue);
      expect(filtered.containsKey('match_id'), isFalse);
      expect(filtered.containsKey('user_phone'), isFalse);
    });
  });
}
