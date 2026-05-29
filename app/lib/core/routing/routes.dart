/// Route path constants for Kickoff Buddy.
abstract final class Routes {
  static const String onboarding = '/onboarding';
  static const String home = '/';

  // Sprint 2 routes
  static const String matches = '/matches';
  static const String matchesAdd = '/matches/add';
  static const String matchesMagicAdd = '/matches/magic-add';

  /// Returns the path for a match detail screen.
  static String matchDetail(String matchId) => '/matches/$matchId';

  // Sprint 4 routes
  static const String rules = '/rules';
  static const String vocabulary = '/vocabulary';
  static const String settings = '/settings';
  static const String standings = '/standings';

  /// Returns the path for a rule card detail screen.
  static String ruleDetail(String id) => '/rules/$id';
}
