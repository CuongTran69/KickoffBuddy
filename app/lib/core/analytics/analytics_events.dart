/// Defines all analytics event names and their allowed parameter keys.
///
/// Privacy design (D6): each event has an explicit allowlist of parameter keys.
/// The [AnalyticsService] strips any key not in the allowlist before sending.
/// This prevents accidental PII leakage.
class AnalyticsEvents {
  AnalyticsEvents._();

  // Event names
  static const String onboardingCompleted = 'onboarding_completed';
  static const String matchViewed = 'match_viewed';
  static const String matchAddedToMyMatches = 'match_added_to_my_matches';
  static const String reminderSet = 'reminder_set';
  static const String replayPlannerSet = 'replay_planner_set';
  static const String ruleCardViewed = 'rule_card_viewed';
  static const String vocabularySearched = 'vocabulary_searched';
  static const String languageChanged = 'language_changed';

  /// Allowlist of permitted parameter keys per event.
  ///
  /// Keys not in this map (or not in the set for a given event) are stripped
  /// before the event is forwarded to Firebase Analytics.
  static const Map<String, Set<String>> allowedParams = {
    onboardingCompleted: {},
    matchViewed: {'match_id', 'source'},
    matchAddedToMyMatches: {'match_id'},
    reminderSet: {'count_total', 'offsets_csv'},
    replayPlannerSet: {'match_id'},
    ruleCardViewed: {'topic', 'level'},
    vocabularySearched: {'query_length', 'has_results'},
    languageChanged: {'locale'},
  };
}
