import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'rule_card.dart';

/// Repository for rule cards loaded from the bundled JSON asset.
///
/// Design decisions:
/// - D1: No Isar — content is read-only and small (~21 cards).
/// - Lazy load on first [getAll] call; subsequent calls use in-memory cache.
class RuleCardRepository {
  List<RuleCard>? _cache;

  /// Load all 21 rule cards from the bundled JSON asset.
  ///
  /// First call reads `assets/data/rule_cards.json` via [rootBundle].
  /// Subsequent calls return the cached list.
  Future<List<RuleCard>> getAll() async {
    if (_cache != null) return _cache!;

    try {
      final jsonString =
          await rootBundle.loadString('assets/data/rule_cards.json');
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final cardsJson = jsonMap['cards'] as List<dynamic>;
      _cache = cardsJson
          .map((e) => RuleCard.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cache!;
    } catch (e) {
      // Surface error to caller — AsyncValue.error will handle UI state.
      rethrow;
    }
  }

  /// Returns the card with the given [id], or null if not found.
  Future<RuleCard?> getById(String id) async {
    final cards = await getAll();
    try {
      return cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

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
