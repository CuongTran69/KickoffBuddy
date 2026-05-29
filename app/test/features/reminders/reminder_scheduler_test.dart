import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:kickoff_buddy/features/reminders/application/reminder_scheduler.dart';

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  });

  group('notificationIdFor', () {
    test('same inputs yield same ID (deterministic)', () {
      final id1 = notificationIdFor('m1', 180);
      final id2 = notificationIdFor('m1', 180);
      expect(id1, equals(id2));
    });

    test('different offsets yield different IDs', () {
      final id180 = notificationIdFor('m1', 180);
      final id30 = notificationIdFor('m1', 30);
      expect(id180, isNot(equals(id30)));
    });

    test('different match IDs yield different IDs', () {
      final idM1 = notificationIdFor('m1', 180);
      final idM2 = notificationIdFor('m2', 180);
      expect(idM1, isNot(equals(idM2)));
    });

    test('returns non-negative integer', () {
      final id = notificationIdFor('match_001', 1440);
      expect(id, greaterThanOrEqualTo(0));
    });
  });

  group('replayNotificationIdFor', () {
    test('same match ID yields same replay ID', () {
      final id1 = replayNotificationIdFor('m1');
      final id2 = replayNotificationIdFor('m1');
      expect(id1, equals(id2));
    });

    test('replay ID differs from offset-based IDs', () {
      final replayId = replayNotificationIdFor('m1');
      final offsetId = notificationIdFor('m1', 5);
      expect(replayId, isNot(equals(offsetId)));
    });

    test('returns non-negative integer', () {
      final id = replayNotificationIdFor('match_001');
      expect(id, greaterThanOrEqualTo(0));
    });
  });

  group('computeFireTime', () {
    test('returns kickoff minus offset in local TZ', () {
      // Kickoff at 2026-06-12 01:00 UTC = 2026-06-12 08:00 ICT
      final kickoffUtc = DateTime.utc(2026, 6, 12, 1, 0, 0);
      final fireTime = computeFireTime(kickoffUtc, 30);

      // Expected: 2026-06-12 07:30 ICT
      expect(fireTime.hour, 7);
      expect(fireTime.minute, 30);
    });

    test('returns tz.TZDateTime (not raw DateTime)', () {
      final kickoffUtc = DateTime.utc(2026, 6, 12, 1, 0, 0);
      final fireTime = computeFireTime(kickoffUtc, 60);
      expect(fireTime, isA<tz.TZDateTime>());
    });

    test('1440 min offset subtracts 1 day', () {
      final kickoffUtc = DateTime.utc(2026, 6, 12, 1, 0, 0);
      final fireTime = computeFireTime(kickoffUtc, 1440);
      final kickoffLocal = tz.TZDateTime.from(kickoffUtc, tz.local);
      expect(
        fireTime.isAtSameMomentAs(
          kickoffLocal.subtract(const Duration(minutes: 1440)),
        ),
        isTrue,
      );
    });
  });

  group('filterValidOffsets', () {
    test('keeps offsets whose fire time is in the future', () {
      // Kickoff in 2 hours from now
      final now = DateTime.now().toUtc();
      final kickoffUtc = now.add(const Duration(hours: 2));

      final result = filterValidOffsets([1440, 180, 30, 5], kickoffUtc, now);

      // 1440 min = 24h before kickoff → fire time is 22h in the past → skipped
      // 180 min = 3h before kickoff → fire time is 1h in the past → skipped
      // 30 min = 30min before kickoff → fire time is 90min in future → kept
      // 5 min = 5min before kickoff → fire time is 115min in future → kept
      expect(result.kept, containsAll([30, 5]));
      expect(result.skipped, containsAll([1440, 180]));
    });

    test('skips all offsets when kickoff is in the past', () {
      final now = DateTime.now().toUtc();
      final kickoffUtc = now.subtract(const Duration(hours: 1));

      final result = filterValidOffsets([1440, 180, 30, 5], kickoffUtc, now);

      expect(result.kept, isEmpty);
      expect(result.skipped, containsAll([1440, 180, 30, 5]));
    });

    test('keeps all offsets when kickoff is far in the future', () {
      final now = DateTime.now().toUtc();
      final kickoffUtc = now.add(const Duration(days: 30));

      final result = filterValidOffsets([1440, 180, 30, 5], kickoffUtc, now);

      expect(result.kept, containsAll([1440, 180, 30, 5]));
      expect(result.skipped, isEmpty);
    });

    test('returns parallel kept/skipped lists', () {
      final now = DateTime.now().toUtc();
      final kickoffUtc = now.add(const Duration(minutes: 10));

      final result = filterValidOffsets([30, 5], kickoffUtc, now);

      // 30 min before kickoff = 20 min in the past → skipped
      // 5 min before kickoff = 5 min in the future → kept
      expect(result.kept, [5]);
      expect(result.skipped, [30]);
    });

    test('DST transition: America/New_York March boundary', () {
      // Set local to America/New_York for this test
      final nyLocation = tz.getLocation('America/New_York');
      tz.setLocalLocation(nyLocation);

      try {
        // 2026-03-08 is the DST spring-forward Sunday in the US
        // Kickoff at 03:00 local (which doesn't exist — clocks jump to 04:00)
        // Use UTC equivalent: 2026-03-08 08:00 UTC = 03:00 EST (before spring)
        final kickoffUtc = DateTime.utc(2026, 3, 8, 8, 0, 0);
        final now = DateTime.utc(2026, 3, 8, 6, 0, 0); // 2h before kickoff

        final result = filterValidOffsets([180, 30, 5], kickoffUtc, now);

        // 180 min before kickoff = 5h before kickoff → fire at 03:00 UTC
        // which is 1h before now (06:00 UTC) → skipped
        // 30 min before kickoff → fire at 07:30 UTC → after now → kept
        // 5 min before kickoff → fire at 07:55 UTC → after now → kept
        expect(result.kept, containsAll([30, 5]));
        expect(result.skipped, contains(180));
      } finally {
        // Restore local timezone
        tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
      }
    });
  });

  group('offsetLabel', () {
    test('1440 minutes returns day label', () {
      expect(offsetLabel(1440), '1 ngày');
    });

    test('180 minutes returns hour label', () {
      expect(offsetLabel(180), '3 giờ');
    });

    test('30 minutes returns minute label', () {
      expect(offsetLabel(30), '30 phút');
    });

    test('5 minutes returns minute label', () {
      expect(offsetLabel(5), '5 phút');
    });
  });
}
