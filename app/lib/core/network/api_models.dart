// DTO classes for World Cup JSON API responses.
//
// These are intentionally separate from the Isar [Match] model.
// API responses are parsed into these DTOs, then mapped/synced to Isar.

/// A match from the worldcupjson.net API.
class ApiMatch {
  const ApiMatch({
    required this.id,
    required this.venue,
    required this.location,
    required this.status,
    required this.stageName,
    required this.homeTeamCountry,
    required this.awayTeamCountry,
    required this.datetime,
    required this.homeTeam,
    required this.awayTeam,
    this.attendance,
    this.winner,
    this.winnerCode,
  });

  final int id;
  final String venue;
  final String location;

  /// One of: 'completed', 'in_progress', 'future_scheduled'.
  final String status;
  final String stageName;
  final String homeTeamCountry;
  final String awayTeamCountry;
  final DateTime datetime;
  final ApiTeamResult homeTeam;
  final ApiTeamResult awayTeam;
  final String? attendance;
  final String? winner;
  final String? winnerCode;

  factory ApiMatch.fromJson(Map<String, dynamic> json) {
    return ApiMatch(
      id: json['id'] as int,
      venue: json['venue'] as String? ?? '',
      location: json['location'] as String? ?? '',
      status: json['status'] as String? ?? 'future_scheduled',
      stageName: json['stage_name'] as String? ?? '',
      homeTeamCountry: json['home_team_country'] as String? ?? '',
      awayTeamCountry: json['away_team_country'] as String? ?? '',
      datetime: DateTime.parse(json['datetime'] as String),
      homeTeam: ApiTeamResult.fromJson(
          json['home_team'] as Map<String, dynamic>? ?? {}),
      awayTeam: ApiTeamResult.fromJson(
          json['away_team'] as Map<String, dynamic>? ?? {}),
      attendance: json['attendance']?.toString(),
      winner: json['winner'] as String?,
      winnerCode: json['winner_code'] as String?,
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isFuture => status == 'future_scheduled';
}

/// Team result within an [ApiMatch].
class ApiTeamResult {
  const ApiTeamResult({
    required this.country,
    required this.name,
    required this.goals,
    required this.penalties,
  });

  final String country;
  final String name;
  final int goals;
  final int penalties;

  factory ApiTeamResult.fromJson(Map<String, dynamic> json) {
    return ApiTeamResult(
      country: json['country'] as String? ?? '',
      name: json['name'] as String? ?? '',
      goals: json['goals'] as int? ?? 0,
      penalties: json['penalties'] as int? ?? 0,
    );
  }
}

/// A team standing within a group.
class ApiTeamStanding {
  const ApiTeamStanding({
    required this.country,
    required this.name,
    required this.groupLetter,
    required this.groupPoints,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.gamesPlayed,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifferential,
  });

  final String country;
  final String name;
  final String groupLetter;
  final int groupPoints;
  final int wins;
  final int draws;
  final int losses;
  final int gamesPlayed;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifferential;

  factory ApiTeamStanding.fromJson(Map<String, dynamic> json) {
    return ApiTeamStanding(
      country: json['country'] as String? ?? '',
      name: json['name'] as String? ?? '',
      groupLetter: json['group_letter'] as String? ?? '',
      groupPoints: json['group_points'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      gamesPlayed: json['games_played'] as int? ?? 0,
      goalsFor: json['goals_for'] as int? ?? 0,
      goalsAgainst: json['goals_against'] as int? ?? 0,
      goalDifferential: json['goal_differential'] as int? ?? 0,
    );
  }
}

/// A group with its standings.
class ApiGroup {
  const ApiGroup({
    required this.letter,
    required this.teams,
  });

  final String letter;
  final List<ApiTeamStanding> teams;

  factory ApiGroup.fromJson(Map<String, dynamic> json) {
    final teamsList = (json['teams'] as List<dynamic>? ?? [])
        .map((t) => ApiTeamStanding.fromJson(t as Map<String, dynamic>))
        .toList();
    // Sort by points descending, then goal differential.
    teamsList.sort((a, b) {
      final ptsDiff = b.groupPoints.compareTo(a.groupPoints);
      if (ptsDiff != 0) return ptsDiff;
      return b.goalDifferential.compareTo(a.goalDifferential);
    });
    return ApiGroup(
      letter: json['letter'] as String? ?? '',
      teams: teamsList,
    );
  }
}

/// Response from GET /teams.
class ApiTeamsResponse {
  const ApiTeamsResponse({required this.groups});

  final List<ApiGroup> groups;

  factory ApiTeamsResponse.fromJson(Map<String, dynamic> json) {
    final groupsList = (json['groups'] as List<dynamic>? ?? [])
        .map((g) => ApiGroup.fromJson(g as Map<String, dynamic>))
        .toList();
    groupsList.sort((a, b) => a.letter.compareTo(b.letter));
    return ApiTeamsResponse(groups: groupsList);
  }
}
