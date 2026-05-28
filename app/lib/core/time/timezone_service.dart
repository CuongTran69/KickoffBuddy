import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for timezone-aware date/time operations.
/// Sprint 2 fills in full usage; this skeleton handles initialization and
/// basic UTC↔local conversion.
class TimezoneService {
  TimezoneService._();

  static String? _localTimezoneName;

  /// Initialize timezone data and detect the device's local timezone.
  /// Must be called before [runApp] in main().
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    _localTimezoneName = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(_localTimezoneName!);
    tz.setLocalLocation(location);
  }

  /// The IANA timezone name of the device (e.g. "Asia/Ho_Chi_Minh").
  String get localTimezoneName =>
      _localTimezoneName ?? tz.local.name;

  /// Convert a UTC [DateTime] to a [tz.TZDateTime] in the device's local timezone.
  tz.TZDateTime toLocal(DateTime utc) {
    return tz.TZDateTime.from(utc.toUtc(), tz.local);
  }

  /// Format a UTC kickoff time as a human-readable local string.
  ///
  /// Default pattern: "EEE, MMM d • HH:mm" → e.g. "Thu, Jun 12 • 21:00"
  String formatKickoffLocal(
    DateTime utcKickoff, {
    String pattern = 'EEE, MMM d • HH:mm',
  }) {
    final local = toLocal(utcKickoff);
    return DateFormat(pattern).format(local);
  }
}

/// Riverpod provider for [TimezoneService].
final timezoneServiceProvider = Provider<TimezoneService>(
  (ref) => TimezoneService._(),
);
