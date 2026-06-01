import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/format_guide/data/format_guide_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FormatGuideRepository', () {
    late FormatGuideRepository repo;

    setUp(() {
      repo = FormatGuideRepository();
    });

    test('loads 6 sections from JSON', () async {
      final sections = await repo.getAll();
      expect(sections.length, 6);
    });

    test('sections have expected ids in order', () async {
      final sections = await repo.getAll();
      final ids = sections.map((s) => s.id).toList();
      expect(ids, [
        'overview',
        'groups',
        'advancement',
        'tiebreakers',
        'best_thirds',
        'knockout',
      ]);
    });

    test('getById hit returns the section', () async {
      final section = await repo.getById('tiebreakers');
      expect(section, isNotNull);
      expect(section!.id, 'tiebreakers');
    });

    test('getById miss returns null', () async {
      final section = await repo.getById('nonexistent_id');
      expect(section, isNull);
    });

    test('subsequent getAll calls use cache (same list instance)', () async {
      final first = await repo.getAll();
      final second = await repo.getAll();
      expect(identical(first, second), isTrue);
    });

    test('tiebreakers section has 5 bullets', () async {
      final section = await repo.getById('tiebreakers');
      expect(section, isNotNull);
      expect(section!.bullets.length, 5);
    });

    test('knockout section has 6 bullets', () async {
      final section = await repo.getById('knockout');
      expect(section, isNotNull);
      expect(section!.bullets.length, 6);
    });

    test('overview section has empty bullets', () async {
      final section = await repo.getById('overview');
      expect(section, isNotNull);
      expect(section!.bullets, isEmpty);
    });

    test('sections have non-empty titleVi and bodyVi', () async {
      final sections = await repo.getAll();
      for (final section in sections) {
        expect(section.titleVi, isNotEmpty,
            reason: 'titleVi should not be empty for ${section.id}');
        expect(section.bodyVi, isNotEmpty,
            reason: 'bodyVi should not be empty for ${section.id}');
      }
    });

    test('value equality is based on id', () async {
      final sections = await repo.getAll();
      final first = sections.first;
      final duplicate = sections.firstWhere((s) => s.id == first.id);
      expect(first, equals(duplicate));
    });
  });
}
