import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/rule_cards/data/rule_card_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RuleCardRepository', () {
    late RuleCardRepository repo;

    setUp(() {
      repo = RuleCardRepository();
    });

    test('loads 21 cards from JSON', () async {
      final cards = await repo.getAll();
      expect(cards.length, 21);
    });

    test('getByTopic("offside") returns 3 cards', () async {
      final cards = await repo.getByTopic('offside');
      expect(cards.length, 3);
      expect(cards.every((c) => c.topic == 'offside'), isTrue);
    });

    test('getByTopicAndLevel("offside", "newbie") returns 1 card', () async {
      final cards = await repo.getByTopicAndLevel('offside', 'newbie');
      expect(cards.length, 1);
      expect(cards.first.id, 'offside_newbie');
      expect(cards.first.level, 'newbie');
    });

    test('getById hit returns the card', () async {
      final card = await repo.getById('offside_newbie');
      expect(card, isNotNull);
      expect(card!.id, 'offside_newbie');
      expect(card.topic, 'offside');
    });

    test('getById miss returns null', () async {
      final card = await repo.getById('nonexistent_id');
      expect(card, isNull);
    });

    test('subsequent getAll calls use cache (same list instance)', () async {
      final first = await repo.getAll();
      final second = await repo.getAll();
      expect(identical(first, second), isTrue);
    });

    test('all 7 topics are present', () async {
      final cards = await repo.getAll();
      final topics = cards.map((c) => c.topic).toSet();
      expect(topics, containsAll([
        'offside',
        'penalty',
        'VAR',
        'cards',
        'stoppage_time',
        'extra_time',
        'penalty_shootout',
      ]));
    });
  });
}
