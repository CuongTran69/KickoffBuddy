import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:kickoff_buddy/features/matches/application/magic_add_parser.dart';

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  late MagicAddParser parser;

  setUp(() {
    // Use Asia/Ho_Chi_Minh as the default local timezone for tests
    parser = const MagicAddParser('Asia/Ho_Chi_Minh');
  });

  group('MagicAddParser — full success', () {
    test('parses "USA vs Mexico, June 11, 8 PM ET"', () {
      final result = parser.parse('USA vs Mexico, June 11, 8 PM ET');
      expect(result.teamA, 'USA');
      expect(result.teamB, 'Mexico');
      expect(result.date?.month, 6);
      expect(result.date?.day, 11);
      expect(result.time?.hour, 20);
      expect(result.time?.minute, 0);
      expect(result.ianaTimezone, 'America/New_York');
      expect(result.isComplete, isTrue);
    });

    test('parses 24-hour time "Brazil vs Argentina, Jun 12, 20:00 ICT"', () {
      final result = parser.parse('Brazil vs Argentina, Jun 12, 20:00 ICT');
      expect(result.teamA, 'Brazil');
      expect(result.teamB, 'Argentina');
      expect(result.time?.hour, 20);
      expect(result.time?.minute, 0);
      expect(result.ianaTimezone, 'Asia/Ho_Chi_Minh');
      expect(result.isComplete, isTrue);
    });

    test('parses "8:30pm" time format', () {
      final result = parser.parse('France vs Germany, June 15, 8:30pm ET');
      expect(result.time?.hour, 20);
      expect(result.time?.minute, 30);
    });

    test('parses M/D date format', () {
      final result = parser.parse('Spain vs Portugal, 6/11, 8 PM ET');
      expect(result.date?.month, 6);
      expect(result.date?.day, 11);
    });

    test('parses MM/DD date format', () {
      final result = parser.parse('Spain vs Portugal, 06/11, 8 PM ET');
      expect(result.date?.month, 6);
      expect(result.date?.day, 11);
    });

    test('parses M-D date format', () {
      final result = parser.parse('Spain vs Portugal, 6-11, 8 PM ET');
      expect(result.date?.month, 6);
      expect(result.date?.day, 11);
    });

    test('uses PT timezone correctly', () {
      final result = parser.parse('USA vs Mexico, June 11, 8 PM PT');
      expect(result.ianaTimezone, 'America/Los_Angeles');
    });

    test('uses SGT timezone correctly', () {
      final result = parser.parse('Japan vs Korea, June 11, 8 PM SGT');
      expect(result.ianaTimezone, 'Asia/Singapore');
    });

    test('uses AEST timezone correctly', () {
      final result = parser.parse('Australia vs NZ, June 11, 8 PM AEST');
      expect(result.ianaTimezone, 'Australia/Sydney');
    });
  });

  group('MagicAddParser — partial parse', () {
    test('parses teams only — no date/time', () {
      final result = parser.parse('USA vs Mexico');
      expect(result.teamA, 'USA');
      expect(result.teamB, 'Mexico');
      expect(result.date, isNull);
      expect(result.time, isNull);
      expect(result.isComplete, isFalse);
      expect(result.hasTeams, isTrue);
    });

    test('parses teams with @ separator', () {
      final result = parser.parse('USA @ Mexico');
      expect(result.teamA, 'USA');
      expect(result.teamB, 'Mexico');
      expect(result.hasTeams, isTrue);
    });
  });

  group('MagicAddParser — failed parse', () {
    test('returns no teams for "Hello world"', () {
      final result = parser.parse('Hello world');
      expect(result.teamA, isNull);
      expect(result.teamB, isNull);
      expect(result.isComplete, isFalse);
      expect(result.hasTeams, isFalse);
    });

    test('returns no teams for empty string', () {
      final result = parser.parse('');
      expect(result.isComplete, isFalse);
      expect(result.hasTeams, isFalse);
    });
  });

  group('MagicAddParser — year inference', () {
    test('infers current year for future date (June 11 when today is May 28)', () {
      // Today is 2026-05-28, June 11 is in the future → year 2026
      final result = parser.parse('USA vs Mexico, June 11, 8 PM ET');
      final today = DateTime.now();
      final june11 = DateTime(today.year, 6, 11);
      if (june11.isAfter(today) || june11.isAtSameMomentAs(today)) {
        expect(result.date?.year, today.year);
      } else {
        expect(result.date?.year, today.year + 1);
      }
    });

    test('infers next year for past date (January 5 when today is May 28)', () {
      // January 5 is in the past relative to May 28 → year + 1
      final result = parser.parse('USA vs Mexico, January 5, 8 PM ET');
      final today = DateTime.now();
      final jan5 = DateTime(today.year, 1, 5);
      if (jan5.isBefore(DateTime(today.year, today.month, today.day))) {
        expect(result.date?.year, today.year + 1);
      }
    });
  });

  group('MagicAddParser — timezone fallback', () {
    test('defaults to user local timezone when no TZ abbreviation found', () {
      final result = parser.parse('USA vs Mexico, June 11, 8 PM');
      // No TZ abbreviation → defaults to Asia/Ho_Chi_Minh (parser's local TZ)
      expect(result.ianaTimezone, 'Asia/Ho_Chi_Minh');
    });

    test('ICT maps to Asia/Ho_Chi_Minh for Vietnamese users', () {
      final result = parser.parse('USA vs Mexico, June 11, 8 PM ICT');
      expect(result.ianaTimezone, 'Asia/Ho_Chi_Minh');
    });
  });

  group('MagicAddParser — originalText preserved', () {
    test('preserves original text in result', () {
      const input = 'USA vs Mexico, June 11, 8 PM ET';
      final result = parser.parse(input);
      expect(result.originalText, input);
    });
  });

  group('MagicAddParser — date bounds (no silent rollover)', () {
    test('rejects out-of-range day 6/32 (slash path)', () {
      final result = parser.parse('Spain vs Portugal, 6/32, 8 PM ET');
      expect(result.date, isNull);
    });

    test('rejects day 0 in 6/0 (slash path)', () {
      final result = parser.parse('Spain vs Portugal, 6/0, 8 PM ET');
      expect(result.date, isNull);
    });

    test('rejects day 0 in 6-0 (dash path)', () {
      final result = parser.parse('Spain vs Portugal, 6-0, 8 PM ET');
      expect(result.date, isNull);
    });

    test('rejects out-of-range day in named-month path (June 32)', () {
      final result = parser.parse('Spain vs Portugal, June 32, 8 PM ET');
      expect(result.date, isNull);
    });

    test('accepts boundary day 6/30', () {
      final result = parser.parse('Spain vs Portugal, 6/30, 8 PM ET');
      expect(result.date?.month, 6);
      expect(result.date?.day, 30);
    });

    test('accepts boundary day 1/1', () {
      final result = parser.parse('Spain vs Portugal, 1/1, 8 PM ET');
      expect(result.date?.month, 1);
      expect(result.date?.day, 1);
    });

    test('accepts boundary day 1/31', () {
      final result = parser.parse('Spain vs Portugal, 1/31, 8 PM ET');
      expect(result.date?.month, 1);
      expect(result.date?.day, 31);
    });
  });
}
