import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Tests for timezone conversion logic used by TimezoneService.
///
/// Since TimezoneService has a private constructor, we test the underlying
/// tz.TZDateTime.from conversion directly — this is the same logic used
/// by TimezoneService.toLocal().
void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  group('UTC to local timezone conversion', () {
    test('converts UTC to Asia/Ho_Chi_Minh correctly', () {
      final location = tz.getLocation('Asia/Ho_Chi_Minh');
      // 2026-06-12T01:00:00Z → 2026-06-12T08:00:00+07:00
      final utc = DateTime.utc(2026, 6, 12, 1, 0, 0);
      final local = tz.TZDateTime.from(utc, location);
      expect(local.hour, 8);
      expect(local.minute, 0);
      expect(local.day, 12);
      expect(local.month, 6);
    });

    test('converts UTC to America/Los_Angeles correctly (PDT = UTC-7)', () {
      final location = tz.getLocation('America/Los_Angeles');
      // 2026-06-12T01:00:00Z → 2026-06-11T18:00:00-07:00 (PDT)
      final utc = DateTime.utc(2026, 6, 12, 1, 0, 0);
      final local = tz.TZDateTime.from(utc, location);
      expect(local.hour, 18);
      expect(local.day, 11);
    });

    test('handles midnight crossing — UTC midnight is previous day in LA', () {
      final location = tz.getLocation('America/Los_Angeles');
      // 2026-06-12T00:00:00Z → 2026-06-11T17:00:00-07:00 (PDT)
      final utc = DateTime.utc(2026, 6, 12, 0, 0, 0);
      final local = tz.TZDateTime.from(utc, location);
      expect(local.day, 11);
      expect(local.hour, 17);
    });

    test('handles DST — America/New_York in summer is UTC-4 (EDT)', () {
      final location = tz.getLocation('America/New_York');
      // 2026-06-11T20:00:00Z → 2026-06-11T16:00:00-04:00 (EDT)
      final utc = DateTime.utc(2026, 6, 11, 20, 0, 0);
      final local = tz.TZDateTime.from(utc, location);
      expect(local.hour, 16);
      expect(local.day, 11);
    });

    test('America/New_York in winter is UTC-5 (EST)', () {
      final location = tz.getLocation('America/New_York');
      // 2026-01-15T20:00:00Z → 2026-01-15T15:00:00-05:00 (EST)
      final utc = DateTime.utc(2026, 1, 15, 20, 0, 0);
      final local = tz.TZDateTime.from(utc, location);
      expect(local.hour, 15);
      expect(local.day, 15);
    });

    test('formatKickoffLocal produces correct EEE, MMM d • HH:mm format', () {
      final location = tz.getLocation('Asia/Ho_Chi_Minh');
      final utc = DateTime.utc(2026, 6, 12, 1, 0, 0);
      final local = tz.TZDateTime.from(utc, location);
      final formatted = DateFormat('EEE, MMM d • HH:mm').format(local);
      // Should contain "08:00" and "12"
      expect(formatted, contains('08:00'));
      expect(formatted, contains('12'));
    });

    test('Mexico City (CDT = UTC-6) converts correctly', () {
      final location = tz.getLocation('America/Mexico_City');
      // 2026-06-11T19:00:00Z → 2026-06-11T13:00:00-06:00 (CDT)
      final utc = DateTime.utc(2026, 6, 11, 19, 0, 0);
      final local = tz.TZDateTime.from(utc, location);
      expect(local.hour, 13);
      expect(local.day, 11);
    });
  });
}
