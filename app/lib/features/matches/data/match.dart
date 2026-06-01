import 'package:isar/isar.dart';

part 'match.g.dart';

/// Isar collection for a football match.
///
/// Schema version: Isar 3.x (D1 fallback — Isar 4.x not yet published on pub.dev
/// as of Sprint 2. Chose Isar 3.x + downgraded riverpod_generator ^2.4.0 to
/// resolve the analyzer version conflict. riverpod_lint omitted per D1 fallback.)
///
/// All kickoff times are stored in UTC. Use [TimezoneService.toLocal] to
/// convert for display — never use raw DateTime for scheduling or display.
@collection
class Match {
  /// Auto-incremented Isar ID (internal). Not the same as [matchId].
  Id id = Isar.autoIncrement;

  /// Application-level string ID (e.g. "match_001", UUID for user-created).
  @Index(unique: true, replace: true)
  late String matchId;

  /// Human-readable title, e.g. "Mexico vs South Africa".
  late String title;

  /// Home team name (English, as in openfootball source).
  late String teamA;

  /// Away team name (English, as in openfootball source).
  late String teamB;

  /// Kickoff time stored as UTC milliseconds since epoch.
  /// Always store UTC — convert to local via TimezoneService for display.
  @Index()
  late DateTime kickoffAtUtc;

  /// IANA timezone of the data source (e.g. "America/New_York").
  late String sourceTimezone;

  /// IANA timezone for display (user's local timezone at time of creation).
  late String userTimezone;

  /// Reminder offsets in minutes before kickoff (e.g. [1440, 180, 30, 5]).
  late List<int> reminders;

  /// Whether the replay planner is enabled for this match.
  late bool replayPlannerEnabled;

  /// Planned replay time (UTC), nullable.
  DateTime? replayPlannedAt;

  /// Original text from Magic Add, nullable.
  String? sourceText;

  /// User notes, empty string if none.
  late String notes;

  /// Creation timestamp (UTC).
  late DateTime createdAt;

  /// True if this match came from the WC 2026 seed catalog.
  @Index()
  late bool isSeeded;

  /// Tournament identifier, e.g. "wc2026".
  @Index()
  String? tournamentId;

  /// Group letter for group-stage matches (A-L), null for knockouts.
  String? worldCupGroup;

  /// Round identifier. One of: group_stage, round_of_32, round_of_16,
  /// quarter_final, semi_final, third_place, final.
  String? worldCupRound;

  /// Matchday number (1-3) for group-stage matches, null for knockouts.
  int? matchday;

  /// Venue city display name (e.g. "Los Angeles").
  String? venueCity;

  /// IANA timezone of the venue (e.g. "America/Los_Angeles").
  String? venueIanaTimezone;

  // ---------------------------------------------------------------------------
  // Live data from World Cup API (synced via MatchSyncService)
  // ---------------------------------------------------------------------------

  /// Home team score (null = match not yet played or no data).
  int? scoreA;

  /// Away team score (null = match not yet played or no data).
  int? scoreB;

  /// Match status from API: 'future_scheduled', 'in_progress', 'completed'.
  String? matchStatus;

  /// Winner name from API (e.g. "Argentina", "Draw"), null if not yet played.
  String? winner;

  /// Full venue name from API (e.g. "Lusail Stadium").
  String? venueName;

  /// Attendance count as string from API.
  String? attendance;

  /// Home team penalty-shootout score (null = no shootout or not yet synced).
  int? penaltyA;

  /// Away team penalty-shootout score (null = no shootout or not yet synced).
  int? penaltyB;
}
