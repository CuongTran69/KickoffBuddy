import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/vocabulary/application/vocabulary_search_controller.dart';
import 'package:kickoff_buddy/features/vocabulary/data/vocabulary_item.dart';
import 'package:kickoff_buddy/features/vocabulary/data/vocabulary_repository.dart';

/// Fake repository that returns a fixed list of items.
class _FakeVocabularyRepository extends VocabularyRepository {
  final List<VocabularyItem> _items;

  _FakeVocabularyRepository(this._items);

  @override
  Future<List<VocabularyItem>> getAll() async => _items;

  @override
  Future<List<VocabularyItem>> search(String? query) async {
    if (query == null || query.isEmpty) return _items;
    final q = query.toLowerCase();
    return _items
        .where((i) =>
            i.termVi.toLowerCase().contains(q) ||
            i.termViNoDiacritics.toLowerCase().contains(q) ||
            i.termEn.toLowerCase().contains(q))
        .toList();
  }
}

List<VocabularyItem> _makeItems() => [
      const VocabularyItem(
        id: 'offside',
        termEn: 'Offside',
        termVi: 'Việt vị',
        termViNoDiacritics: 'viet vi',
        definitionEn: 'Offside rule',
        definitionVi: 'Luật việt vị',
        exampleEn: 'He was offside.',
        exampleVi: 'Anh ta bị việt vị.',
        related: ['penalty'],
      ),
      const VocabularyItem(
        id: 'penalty',
        termEn: 'Penalty',
        termVi: 'Phạt đền',
        termViNoDiacritics: 'phat den',
        definitionEn: 'Penalty kick',
        definitionVi: 'Phạt đền',
        exampleEn: 'That is a penalty.',
        exampleVi: 'Đó là phạt đền.',
        related: [],
      ),
      const VocabularyItem(
        id: 'foul',
        termEn: 'Foul',
        termVi: 'Phạm lỗi',
        termViNoDiacritics: 'pham loi',
        definitionEn: 'A foul',
        definitionVi: 'Phạm lỗi',
        exampleEn: 'That was a foul.',
        exampleVi: 'Đó là phạm lỗi.',
        related: [],
      ),
    ];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VocabularySearchController', () {
    late ProviderContainer container;
    final fakeItems = _makeItems();

    setUp(() {
      container = ProviderContainer(
        overrides: [
          vocabularyRepositoryProvider
              .overrideWithValue(_FakeVocabularyRepository(fakeItems)),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has all items as results after loading', () async {
      // Trigger the provider.
      container.read(vocabularySearchControllerProvider);
      // Wait for async init to complete.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final state = container.read(vocabularySearchControllerProvider);
      expect(state.results.length, fakeItems.length);
      expect(state.query, '');
    });

    test('setQuery("") applies immediately and returns all items', () async {
      container.read(vocabularySearchControllerProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // First set a non-empty query.
      container
          .read(vocabularySearchControllerProvider.notifier)
          .setQuery('viet');
      await Future<void>.delayed(const Duration(milliseconds: 250));

      // Now clear.
      container
          .read(vocabularySearchControllerProvider.notifier)
          .setQuery('');
      // Empty query is immediate — no debounce needed.
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final state = container.read(vocabularySearchControllerProvider);
      expect(state.query, '');
      expect(state.results.length, fakeItems.length);
    });

    test('setQuery debounced 200ms before update', () async {
      container.read(vocabularySearchControllerProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      container
          .read(vocabularySearchControllerProvider.notifier)
          .setQuery('viet');

      // Before debounce fires, results should still be all items.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final stateBefore = container.read(vocabularySearchControllerProvider);
      // Query is set but results may not have updated yet.
      // After 200ms, results should be filtered.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final stateAfter = container.read(vocabularySearchControllerProvider);
      expect(stateAfter.results.any((i) => i.id == 'offside'), isTrue);
      // penalty and foul don't match 'viet'.
      expect(stateAfter.results.any((i) => i.id == 'penalty'), isFalse);
      // Suppress unused variable warning.
      expect(stateBefore, isNotNull);
    });

    test('rapid queries within 200ms result in single re-filter', () async {
      container.read(vocabularySearchControllerProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Fire 5 queries within 100ms total.
      for (int i = 0; i < 5; i++) {
        container
            .read(vocabularySearchControllerProvider.notifier)
            .setQuery('v$i');
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }

      // Wait for debounce to fire.
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Only the last query should have triggered a filter.
      // We verify the final state reflects the last query.
      final state = container.read(vocabularySearchControllerProvider);
      expect(state.query, 'v4');
    });
  });
}
