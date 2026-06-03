import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/bundled_json_repository.dart';
import 'rule_card.dart';

/// Repository for rule cards loaded from the bundled JSON asset.
///
/// Design decisions:
/// - D1: No Isar — content is read-only and small (~21 cards).
/// - Lazy load on first [getAll] call; subsequent calls use in-memory cache.
class RuleCardRepository extends BundledJsonRepository<RuleCard> {
  RuleCardRepository()
      : super(
          assetPath: 'assets/data/rule_cards.json',
          rootKey: 'cards',
          fromJson: RuleCard.fromJson,
          idOf: (card) => card.id,
        );

  /// Returns all cards for the given [topic] (3 cards: newbie, casual, advanced).
  Future<List<RuleCard>> getByTopic(String topic) async {
    final cards = await getAll();
    return cards.where((c) => c.topic == topic).toList();
  }

  /// Returns cards matching both [topic] and [level] (typically 1 card).
  Future<List<RuleCard>> getByTopicAndLevel(String topic, String level) async {
    final cards = await getAll();
    return cards
        .where((c) => c.topic == topic && c.level == level)
        .toList();
  }
}

/// Provider for [RuleCardRepository].
///
/// Uses a simple [Provider] since the repository itself is synchronous to
/// construct — the async work happens inside [getAll].
final ruleCardRepositoryProvider = Provider<RuleCardRepository>(
  (_) => RuleCardRepository(),
);

/// Provider that loads all rule cards.
///
/// Consumers watch this to get the full list; filtering is done in the
/// application layer via [filteredRuleCardsProvider].
final ruleCardsListProvider = FutureProvider<List<RuleCard>>((ref) async {
  final repo = ref.watch(ruleCardRepositoryProvider);
  return repo.getAll();
});
