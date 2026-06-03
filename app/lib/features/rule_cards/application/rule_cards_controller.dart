import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/rule_card.dart';
import '../data/rule_card_repository.dart';

/// The three knowledge levels for rule cards.
enum RuleLevel {
  newbie,
  casual,
  advanced;

  /// Returns the JSON value string for this level.
  String get jsonValue => name; // "newbie", "casual", "advanced"
}

/// Notifier that manages the active rule level filter.
class RuleLevelFilterNotifier extends Notifier<RuleLevel> {
  @override
  RuleLevel build() => RuleLevel.newbie; // default: Newbie

  /// Update the active level filter.
  void setLevel(RuleLevel level) => state = level;
}

/// Provider for the active rule level filter.
final ruleLevelFilterProvider =
    NotifierProvider<RuleLevelFilterNotifier, RuleLevel>(
  RuleLevelFilterNotifier.new,
);

/// Computed provider: returns one card per topic matching the active level.
///
/// The 7 topics in fixed display order.
const kRuleTopicOrder = [
  'offside',
  'penalty',
  'VAR',
  'cards',
  'stoppage_time',
  'extra_time',
  'penalty_shootout',
];

final filteredRuleCardsProvider = FutureProvider<List<RuleCard>>((ref) async {
  final repo = ref.watch(ruleCardRepositoryProvider);
  final level = ref.watch(ruleLevelFilterProvider);

  final allCards = await repo.getAll();
  final levelStr = level.jsonValue;

  // Return one card per topic in fixed order.
  final result = <RuleCard>[];
  for (final topic in kRuleTopicOrder) {
    try {
      final card = allCards.firstWhere(
        (c) => c.topic == topic && c.level == levelStr,
      );
      result.add(card);
    } catch (_) {
      // No card for this topic/level combination — skip defensively.
    }
  }
  return result;
});
