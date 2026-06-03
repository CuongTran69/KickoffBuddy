/// Typed representation of the match status API string.
///
/// Maps the API's `matchStatus` string values to a strongly-typed enum.
/// Unrecognised or null values map to [futureScheduled] (safe default).
///
/// Design decision D7: the Isar [Match.matchStatus] field stays [String?];
/// mapping to this enum happens exclusively at the presentation boundary.
enum MatchStatus {
  /// Match has not yet kicked off (default / unknown).
  futureScheduled,

  /// Match is currently in progress (API value: `"in_progress"`).
  inProgress,

  /// Match has concluded (API value: `"completed"`).
  completed;

  /// Parses an API status string into a [MatchStatus].
  ///
  /// Returns [futureScheduled] for null, empty, or unrecognized values so that
  /// unknown statuses always degrade gracefully to the scheduled state.
  static MatchStatus fromApi(String? value) {
    switch (value) {
      case 'in_progress':
        return MatchStatus.inProgress;
      case 'completed':
        return MatchStatus.completed;
      default:
        return MatchStatus.futureScheduled;
    }
  }

  /// Whether this status represents a live, in-progress match.
  bool get isLive => this == MatchStatus.inProgress;

  /// Whether this status represents a finished match.
  bool get isCompleted => this == MatchStatus.completed;

  /// Whether this status represents a match that has not yet kicked off.
  bool get isScheduled => this == MatchStatus.futureScheduled;
}
