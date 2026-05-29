import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'match.dart';

/// Key used to gate the first-run seed load.
/// Bump to 'seed_loaded_v2' if seed data needs refreshing in a future sprint.
const _seedKey = 'seed_loaded_v2';

/// Parses the bundled WC 2026 JSON asset and bulk-inserts all matches into
/// Isar on first launch.
///
/// Skips entirely if [SharedPreferences] key [_seedKey] is already set.
/// On parse errors, logs and continues — the app remains usable for manual add.
Future<void> loadSeedIfEmpty(Isar isar, SharedPreferences prefs) async {
  if (prefs.getBool(_seedKey) == true) {
    return; // Already seeded — skip.
  }

  try {
    final jsonString =
        await rootBundle.loadString('assets/data/wc2026_matches.json');
    final Map<String, dynamic> data =
        json.decode(jsonString) as Map<String, dynamic>;
    final List<dynamic> matchList = data['matches'] as List<dynamic>;

    final matches = matchList
        .map((e) => _matchFromJson(e as Map<String, dynamic>))
        .toList();

    await isar.writeTxn(() async {
      await isar.matchs.putAll(matches);
    });

    await prefs.setBool(_seedKey, true);
  } catch (e, stack) {
    // Log and continue — app is still usable for manual add.
    debugPrint('[SeedLoader] Failed to load seed data: $e\n$stack');
  }
}

/// Deserializes a JSON map into a [Match] instance.
Match _matchFromJson(Map<String, dynamic> json) {
  final match = Match()
    ..matchId = json['id'] as String
    ..title = json['title'] as String
    ..teamA = json['teamA'] as String
    ..teamB = json['teamB'] as String
    ..kickoffAtUtc = DateTime.parse(json['kickoffAtUtc'] as String).toUtc()
    ..sourceTimezone = json['sourceTimezone'] as String
    ..userTimezone = json['userTimezone'] as String
    ..reminders = (json['reminders'] as List<dynamic>)
        .map((e) => e as int)
        .toList()
    ..replayPlannerEnabled = json['replayPlannerEnabled'] as bool
    ..replayPlannedAt = json['replayPlannedAt'] != null
        ? DateTime.parse(json['replayPlannedAt'] as String).toUtc()
        : null
    ..sourceText = json['sourceText'] as String?
    ..notes = json['notes'] as String? ?? ''
    ..createdAt = DateTime.parse(json['createdAt'] as String).toUtc()
    ..isSeeded = json['isSeeded'] as bool
    ..tournamentId = json['tournamentId'] as String?
    ..worldCupGroup = json['worldCupGroup'] as String?
    ..worldCupRound = json['worldCupRound'] as String?
    ..matchday = json['matchday'] as int?
    ..venueCity = json['venueCity'] as String?
    ..venueIanaTimezone = json['venueIanaTimezone'] as String?;
  return match;
}
