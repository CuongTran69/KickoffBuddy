import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/time/timezone_service.dart';

/// Result of parsing a Magic Add text snippet.
class MagicAddResult {
  const MagicAddResult({
    required this.originalText,
    this.teamA,
    this.teamB,
    this.date,
    this.time,
    this.ianaTimezone,
  });

  final String originalText;
  final String? teamA;
  final String? teamB;

  /// Parsed date (year/month/day only, time is in [time]).
  final DateTime? date;

  /// Parsed time as hour + minute.
  final ({int hour, int minute})? time;

  /// IANA timezone resolved from abbreviation, or user's local TZ.
  final String? ianaTimezone;

  /// True if teams, date, and time were all successfully parsed.
  bool get isComplete =>
      teamA != null && teamB != null && date != null && time != null;

  /// True if at least teams were parsed.
  bool get hasTeams => teamA != null && teamB != null;
}

/// Timezone abbreviation → IANA name lookup table.
const _tzAbbrevToIana = {
  'ET': 'America/New_York',
  'EST': 'America/New_York',
  'EDT': 'America/New_York',
  'PT': 'America/Los_Angeles',
  'PST': 'America/Los_Angeles',
  'PDT': 'America/Los_Angeles',
  'CT': 'America/Chicago',
  'CST': 'America/Chicago',
  'CDT': 'America/Chicago',
  'MT': 'America/Denver',
  'MST': 'America/Denver',
  'MDT': 'America/Denver',
  'GMT': 'Etc/GMT',
  'UTC': 'Etc/UTC',
  'BST': 'Europe/London',
  'CET': 'Europe/Paris',
  'CEST': 'Europe/Paris',
  'JST': 'Asia/Tokyo',
  'ICT': 'Asia/Ho_Chi_Minh',
  'SGT': 'Asia/Singapore',
  'AEST': 'Australia/Sydney',
  'AEDT': 'Australia/Sydney',
  'IST': 'Asia/Kolkata',
  'KST': 'Asia/Seoul',
  'CST_CN': 'Asia/Shanghai',
};

/// Month name → month number lookup.
const _monthNames = {
  'january': 1, 'jan': 1,
  'february': 2, 'feb': 2,
  'march': 3, 'mar': 3,
  'april': 4, 'apr': 4,
  'may': 5,
  'june': 6, 'jun': 6,
  'july': 7, 'jul': 7,
  'august': 8, 'aug': 8,
  'september': 9, 'sep': 9, 'sept': 9,
  'october': 10, 'oct': 10,
  'november': 11, 'nov': 11,
  'december': 12, 'dec': 12,
};

/// Regex-based parser for Magic Add text snippets.
///
/// Grammar (D4 from design.md):
/// - Teams: `^(\S.+?)\s+(?:vs|VS|Vs|@)\s+(.+?)(?:[,]|\s+\d|$)`
/// - Date: Month DD, M/D, MM/DD, M-D
/// - Time: `\d{1,2}:?\d{0,2}\s*(?:am|pm|AM|PM)?`
/// - Timezone: 3-letter abbreviation → IANA lookup
class MagicAddParser {
  const MagicAddParser(this._localTimezoneName);

  final String _localTimezoneName;

  /// Parses [text] and returns a [MagicAddResult].
  MagicAddResult parse(String text) {
    final trimmed = text.trim();

    final teams = _parseTeams(trimmed);
    final date = _parseDate(trimmed);
    final time = _parseTime(trimmed);
    final tz = _parseTimezone(trimmed);

    return MagicAddResult(
      originalText: trimmed,
      teamA: teams?.$1,
      teamB: teams?.$2,
      date: date,
      time: time,
      ianaTimezone: tz ?? _localTimezoneName,
    );
  }

  /// Extracts team names from the text.
  /// Pattern: `TeamA vs TeamB` or `TeamA @ TeamB`
  (String, String)? _parseTeams(String text) {
    // Match "Team A vs/VS/Vs/@ Team B" — teams end at comma, digit, or end
    final re = RegExp(
      r'^(\S.+?)\s+(?:vs\.?|VS\.?|Vs\.?|@)\s+(.+?)(?:[,]|\s+\d|\s*$)',
      multiLine: false,
    );
    final m = re.firstMatch(text);
    if (m == null) return null;
    final a = m.group(1)?.trim();
    final b = m.group(2)?.trim();
    if (a == null || a.isEmpty || b == null || b.isEmpty) return null;
    return (a, b);
  }

  /// Parses a date from the text. Tries multiple formats in order.
  /// If no year present, assumes current year; if that date is past, uses next year.
  DateTime? _parseDate(String text) {
    final now = DateTime.now();

    // 1. "Month DD" or "Month D" — e.g. "June 11", "Jun 5"
    final monthDayRe = RegExp(
      r'\b(january|february|march|april|may|june|july|august|september|october|november|december|jan|feb|mar|apr|jun|jul|aug|sep|sept|oct|nov|dec)\s+(\d{1,2})\b',
      caseSensitive: false,
    );
    final mdMatch = monthDayRe.firstMatch(text);
    if (mdMatch != null) {
      final month = _monthNames[mdMatch.group(1)!.toLowerCase()];
      final day = int.tryParse(mdMatch.group(2)!);
      if (month != null && day != null && day >= 1 && day <= 31) {
        return _inferYear(now, month, day);
      }
    }

    // 2. "M/D" or "MM/DD" — e.g. "6/11", "06/11"
    final slashRe = RegExp(r'\b(\d{1,2})/(\d{1,2})\b');
    final slashMatch = slashRe.firstMatch(text);
    if (slashMatch != null) {
      final month = int.tryParse(slashMatch.group(1)!);
      final day = int.tryParse(slashMatch.group(2)!);
      if (month != null &&
          day != null &&
          month >= 1 &&
          month <= 12 &&
          day >= 1 &&
          day <= 31) {
        return _inferYear(now, month, day);
      }
    }

    // 3. "M-D" or "MM-DD" — e.g. "6-11"
    final dashRe = RegExp(r'\b(\d{1,2})-(\d{1,2})\b');
    final dashMatch = dashRe.firstMatch(text);
    if (dashMatch != null) {
      final month = int.tryParse(dashMatch.group(1)!);
      final day = int.tryParse(dashMatch.group(2)!);
      if (month != null &&
          day != null &&
          month >= 1 &&
          month <= 12 &&
          day >= 1 &&
          day <= 31) {
        return _inferYear(now, month, day);
      }
    }

    return null;
  }

  /// Infers the year for a month/day: current year if in the future, else next year.
  DateTime _inferYear(DateTime now, int month, int day) {
    final candidate = DateTime(now.year, month, day);
    if (candidate.isBefore(DateTime(now.year, now.month, now.day))) {
      return DateTime(now.year + 1, month, day);
    }
    return candidate;
  }

  /// Parses a time from the text.
  /// Handles: "8 PM", "20:00", "8:30pm", "8PM", "20:30"
  ///
  /// Strategy:
  /// 1. First pass: look for a number followed by am/pm (most reliable signal)
  /// 2. Second pass: look for HH:MM 24-hour format (colon required)
  ({int hour, int minute})? _parseTime(String text) {
    // Pass 1: number + am/pm (e.g. "8 PM", "8:30pm", "8PM")
    final ampmRe = RegExp(
      r'\b(\d{1,2})(?::(\d{2}))?\s*(am|pm|AM|PM)\b',
    );
    final ampmMatch = ampmRe.firstMatch(text);
    if (ampmMatch != null) {
      final hourRaw = int.tryParse(ampmMatch.group(1)!);
      if (hourRaw != null) {
        final minute = int.tryParse(ampmMatch.group(2) ?? '0') ?? 0;
        final ampm = ampmMatch.group(3)!.toLowerCase();
        int hour = hourRaw;
        if (ampm == 'pm' && hour < 12) hour += 12;
        if (ampm == 'am' && hour == 12) hour = 0;
        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          return (hour: hour, minute: minute);
        }
      }
    }

    // Pass 2: HH:MM 24-hour format (colon required to distinguish from day numbers)
    final colonRe = RegExp(r'\b(\d{1,2}):(\d{2})\b');
    for (final m in colonRe.allMatches(text)) {
      final hour = int.tryParse(m.group(1)!);
      final minute = int.tryParse(m.group(2)!);
      if (hour != null && minute != null &&
          hour >= 0 && hour <= 23 &&
          minute >= 0 && minute <= 59) {
        return (hour: hour, minute: minute);
      }
    }

    return null;
  }

  /// Parses a timezone abbreviation and maps to IANA name.
  String? _parseTimezone(String text) {
    // Look for known abbreviations (word boundary)
    for (final abbrev in _tzAbbrevToIana.keys) {
      final re = RegExp(r'\b' + RegExp.escape(abbrev) + r'\b');
      if (re.hasMatch(text)) {
        return _tzAbbrevToIana[abbrev];
      }
    }
    return null;
  }
}

/// Riverpod provider for [MagicAddParser].
final magicAddParserProvider = Provider<MagicAddParser>((ref) {
  final tzService = ref.watch(timezoneServiceProvider);
  return MagicAddParser(tzService.localTimezoneName);
});
