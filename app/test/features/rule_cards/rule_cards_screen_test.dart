import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/rule_cards/data/rule_card.dart';
import 'package:kickoff_buddy/features/rule_cards/data/rule_card_repository.dart';
import 'package:kickoff_buddy/features/rule_cards/presentation/rule_cards_screen.dart';
import 'package:kickoff_buddy/features/rule_cards/presentation/widgets/level_filter_chips.dart';
import 'package:kickoff_buddy/l10n/app_localizations.dart';

/// Fake repository returning a minimal set of known cards.
class _FakeRuleCardRepository extends RuleCardRepository {
  final List<RuleCard> _cards;

  _FakeRuleCardRepository(this._cards);

  @override
  Future<List<RuleCard>> getAll() async => _cards;
}

List<RuleCard> _makeCards() {
  final topics = [
    'offside',
    'penalty',
    'VAR',
    'cards',
    'stoppage_time',
    'extra_time',
    'penalty_shootout',
  ];
  final levels = ['newbie', 'casual', 'advanced'];
  final cards = <RuleCard>[];
  for (final topic in topics) {
    for (final level in levels) {
      cards.add(RuleCard(
        id: '${topic}_$level',
        topic: topic,
        level: level,
        titleEn: '$topic $level EN',
        titleVi: '$topic $level VI',
        summaryEn: 'Summary EN',
        summaryVi: 'Summary VI',
        bodyEn: 'Body EN',
        bodyVi: 'Body VI',
        tags: const [],
        lastReviewed: '2026-05-28',
      ));
    }
  }
  return cards;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fakeCards = _makeCards();

  Widget buildScreen() {
    return ProviderScope(
      overrides: [
        ruleCardRepositoryProvider
            .overrideWithValue(_FakeRuleCardRepository(fakeCards)),
      ],
      child: MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('vi'), Locale('en')],
        home: const RuleCardsScreen(),
      ),
    );
  }

  group('RuleCardsScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(buildScreen());
      // Before async data loads, show loading.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders 7 topic section headers after load', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Verify all 7 Vietnamese topic labels are present.
      // Use findsAtLeastNWidgets since some may appear in both header and card title.
      expect(find.text('Việt vị'), findsAtLeastNWidgets(1));
      expect(find.text('Phạt đền'), findsAtLeastNWidgets(1));
      expect(find.text('VAR'), findsAtLeastNWidgets(1));

      // Scroll down to find the remaining sections.
      await tester.scrollUntilVisible(
        find.text('Thẻ'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Thẻ'), findsAtLeastNWidgets(1));

      await tester.scrollUntilVisible(
        find.text('Bù giờ'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Bù giờ'), findsAtLeastNWidgets(1));

      await tester.scrollUntilVisible(
        find.text('Hiệp phụ'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Hiệp phụ'), findsAtLeastNWidgets(1));

      await tester.scrollUntilVisible(
        find.text('Sút luân lưu'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Sút luân lưu'), findsAtLeastNWidgets(1));
    });

    testWidgets('default Newbie chip is selected', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Find the LevelFilterChip with "Người mới" label.
      final newbieChip = find.widgetWithText(LevelFilterChip, 'Người mới');
      expect(newbieChip, findsOneWidget);

      final chip = tester.widget<LevelFilterChip>(newbieChip);
      expect(chip.selected, isTrue);
    });

    testWidgets('switching to Casual changes visible cards', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Initially shows newbie cards (e.g., "offside newbie VI").
      expect(find.text('offside newbie VI'), findsOneWidget);

      // Tap Casual chip.
      await tester.tap(find.widgetWithText(LevelFilterChip, 'Thỉnh thoảng'));
      await tester.pumpAndSettle();

      // Now shows casual cards.
      expect(find.text('offside casual VI'), findsOneWidget);
      expect(find.text('offside newbie VI'), findsNothing);
    });

    testWidgets('level filter chips are all present', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(LevelFilterChip, 'Người mới'), findsOneWidget);
      expect(find.widgetWithText(LevelFilterChip, 'Thỉnh thoảng'), findsOneWidget);
      expect(find.widgetWithText(LevelFilterChip, 'Nâng cao'), findsOneWidget);
    });
  });
}
