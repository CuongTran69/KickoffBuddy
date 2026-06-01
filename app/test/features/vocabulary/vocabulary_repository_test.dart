import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/vocabulary/data/vocabulary_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VocabularyRepository', () {
    late VocabularyRepository repo;

    setUp(() {
      repo = VocabularyRepository();
    });

    test('loads 17 items from JSON', () async {
      final items = await repo.getAll();
      expect(items.length, 17);
    });

    test('items are sorted alphabetically by termVi', () async {
      final items = await repo.getAll();
      for (int i = 0; i < items.length - 1; i++) {
        expect(
          items[i].termVi.compareTo(items[i + 1].termVi) <= 0,
          isTrue,
          reason:
              '${items[i].termVi} should come before ${items[i + 1].termVi}',
        );
      }
    });

    test('search VN exact: "Việt vị" returns the offside term', () async {
      final results = await repo.search('Việt vị');
      expect(results.length, 1);
      expect(results.first.id, 'offside');
    });

    test('search VN diacritic-insensitive: "viet vi" returns the offside term',
        () async {
      final results = await repo.search('viet vi');
      expect(results.length, 1);
      expect(results.first.id, 'offside');
    });

    test('search EN: "offside" returns the offside term', () async {
      final results = await repo.search('offside');
      expect(results.isNotEmpty, isTrue);
      expect(results.any((i) => i.id == 'offside'), isTrue);
    });

    test('search empty returns all 17', () async {
      final results = await repo.search('');
      expect(results.length, 17);
    });

    test('search null returns all 17', () async {
      final results = await repo.search(null);
      expect(results.length, 17);
    });

    test('search nonsense returns empty list', () async {
      final results = await repo.search('zzzzzzz_no_match');
      expect(results.isEmpty, isTrue);
    });

    test('subsequent getAll calls use cache (same list instance)', () async {
      final first = await repo.getAll();
      final second = await repo.getAll();
      expect(identical(first, second), isTrue);
    });
  });
}
