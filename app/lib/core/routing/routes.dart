/// Route path constants for Kickoff Buddy.
abstract final class Routes {
  static const String onboarding = '/onboarding';
  static const String home = '/';

  // Sprint 2 routes
  static const String matches = '/matches';
  static const String matchesAdd = '/matches/add';
  static const String matchesMagicAdd = '/matches/magic-add';

  /// Returns the manual-add route with optional prefill query params.
  ///
  /// All values are URL-encoded via [Uri] so team names / source text with
  /// special characters navigate safely.
  static String matchesAddWith({
    String? home,
    String? away,
    String? sourceText,
    String? editMatchId,
  }) {
    final params = <String, String>{
      if (home != null) 'home': home,
      if (away != null) 'away': away,
      if (sourceText != null) 'sourceText': sourceText,
      if (editMatchId != null) 'edit': editMatchId,
    };
    if (params.isEmpty) return matchesAdd;
    return Uri(path: matchesAdd, queryParameters: params).toString();
  }

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
