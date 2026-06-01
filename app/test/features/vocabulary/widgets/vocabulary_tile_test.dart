import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/vocabulary/data/vocabulary_item.dart';
import 'package:kickoff_buddy/features/vocabulary/presentation/widgets/vocabulary_tile.dart';

const _kTestItem = VocabularyItem(
  id: 'offside',
  termEn: 'Offside',
  termVi: 'Việt vị',
  termViNoDiacritics: 'viet vi',
  definitionEn: 'Offside rule definition.',
  definitionVi: 'Định nghĩa việt vị.',
  exampleEn: 'He was offside.',
  exampleVi: 'Anh ta bị việt vị.',
  related: ['penalty'],
);

void main() {
  group('VocabularyTile', () {
    testWidgets('collapsed shows VN term and EN term', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyTile(
              item: _kTestItem,
              expanded: false,
              onToggle: () {},
            ),
          ),
        ),
      );

      expect(find.text('Việt vị'), findsOneWidget);
      expect(find.text('Offside'), findsOneWidget);
      // Definitions should NOT be visible when collapsed.
      expect(find.text('Định nghĩa việt vị.'), findsNothing);
      expect(find.text('Offside rule definition.'), findsNothing);
    });

    testWidgets('expanded shows VN+EN definition and examples', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyTile(
              item: _kTestItem,
              expanded: true,
              onToggle: () {},
            ),
          ),
        ),
      );

      expect(find.text('Việt vị'), findsOneWidget);
      expect(find.text('Offside'), findsOneWidget);
      expect(find.text('Định nghĩa việt vị.'), findsOneWidget);
      expect(find.text('Offside rule definition.'), findsOneWidget);
      // Examples are shown in quotes.
      expect(find.textContaining('Anh ta bị việt vị.'), findsOneWidget);
      expect(find.textContaining('He was offside.'), findsOneWidget);
    });

    testWidgets('tapping collapsed tile calls onToggle', (tester) async {
      bool toggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyTile(
              item: _kTestItem,
              expanded: false,
              onToggle: () => toggled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Việt vị'));
      await tester.pump();

      expect(toggled, isTrue);
    });

    testWidgets('tapping expanded tile calls onToggle', (tester) async {
      bool toggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyTile(
              item: _kTestItem,
              expanded: true,
              onToggle: () => toggled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Việt vị'));
      await tester.pump();

      expect(toggled, isTrue);
    });

    testWidgets('related chips are shown when expanded', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyTile(
              item: _kTestItem,
              expanded: true,
              onToggle: () {},
              onRelatedTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('penalty'), findsOneWidget);
    });

    testWidgets('no related chips section when related is empty',
        (tester) async {
      const itemNoRelated = VocabularyItem(
        id: 'foul',
        termEn: 'Foul',
        termVi: 'Phạm lỗi',
        termViNoDiacritics: 'pham loi',
        definitionEn: 'A foul',
        definitionVi: 'Phạm lỗi',
        exampleEn: '',
        exampleVi: '',
        related: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VocabularyTile(
              item: itemNoRelated,
              expanded: true,
              onToggle: () {},
            ),
          ),
        ),
      );

      // No ActionChip should be present.
      expect(find.byType(ActionChip), findsNothing);
    });
  });
}
