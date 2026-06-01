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

  // Fan Etiquette Guide routes
  static const String etiquette = '/etiquette';

  /// Returns the path for an etiquette tip detail screen.
  static String etiquetteDetail(String id) => '/etiquette/$id';

  // Tournament Format Guide routes
  static const String formatGuide = '/format-guide';

  /// Returns the path for a format guide section detail screen.
  static String formatGuideDetail(String id) => '/format-guide/$id';
}
