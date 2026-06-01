import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/rule_cards/data/rule_card.dart';
import 'package:kickoff_buddy/features/rule_cards/data/rule_card_repository.dart';
import 'package:kickoff_buddy/features/rule_cards/presentation/rule_card_detail_screen.dart';
import 'package:kickoff_buddy/l10n/app_localizations.dart';

/// Fake repository returning a single known card.
class _FakeRuleCardRepository extends RuleCardRepository {
  final RuleCard _card;

  _FakeRuleCardRepository(this._card);

  @override
  Future<List<RuleCard>> getAll() async => [_card];

  @override
  Future<RuleCard?> getById(String id) async =>
      id == _card.id ? _card : null;
}

const _kTestCard = RuleCard(
  id: 'offside_newbie',
  topic: 'offside',
  level: 'newbie',
  titleEn: 'Offside EN Title',
  titleVi: 'Việt vị VN Title',
  summaryEn: 'Summary EN',
  summaryVi: 'Summary VN',
  bodyEn: 'This is the English body text.',
  bodyVi: 'Đây là nội dung tiếng Việt.',
  tags: ['offside', 'goal'],
  lastReviewed: '2026-05-28',
  estimatedReadSeconds: 30,
  relatedIds: [],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildScreen(String ruleId) {
    return ProviderScope(
      overrides: [
        ruleCardRepositoryProvider
            .overrideWithValue(_FakeRuleCardRepository(_kTestCard)),
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
        home: RuleCardDetailScreen(ruleId: ruleId),
      ),
    );
  }

  group('RuleCardDetailScreen', () {
    testWidgets('shows VN title and body by default', (tester) async {
      await tester.pumpWidget(buildScreen('offside_newbie'));
      await tester.pumpAndSettle();

      expect(find.text('Việt vị VN Title'), findsOneWidget);
      expect(find.text('Đây là nội dung tiếng Việt.'), findsOneWidget);
      // EN body should not be visible.
      expect(find.text('This is the English body text.'), findsNothing);
    });

    testWidgets('toggle to English shows EN title and body', (tester) async {
      await tester.pumpWidget(buildScreen('offside_newbie'));
      await tester.pumpAndSettle();

      // Tap the English toggle switch.
      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(find.text('Offside EN Title'), findsOneWidget);
      expect(find.text('This is the English body text.'), findsOneWidget);
      // VN body should not be visible.
      expect(find.text('Đây là nội dung tiếng Việt.'), findsNothing);
    });

    testWidgets('tags are rendered as chips', (tester) async {
      await tester.pumpWidget(buildScreen('offside_newbie'));
      await tester.pumpAndSettle();

      expect(find.text('#offside'), findsOneWidget);
      expect(find.text('#goal'), findsOneWidget);
    });

    testWidgets('read time is shown when estimatedReadSeconds is present',
        (tester) async {
      await tester.pumpWidget(buildScreen('offside_newbie'));
      await tester.pumpAndSettle();

      expect(find.text('Đọc trong: 30 giây'), findsOneWidget);
    });

    testWidgets('shows 404 state for non-existent card', (tester) async {
      await tester.pumpWidget(buildScreen('nonexistent_id'));
      await tester.pumpAndSettle();

      expect(find.text('Không tìm thấy luật'), findsOneWidget);
      expect(find.text('Quay lại'), findsOneWidget);
    });
  });
}
