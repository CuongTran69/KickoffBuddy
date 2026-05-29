import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff_buddy/features/vocabulary/data/vocabulary_item.dart';
import 'package:kickoff_buddy/features/vocabulary/data/vocabulary_repository.dart';
import 'package:kickoff_buddy/features/vocabulary/presentation/vocabulary_screen.dart';
import 'package:kickoff_buddy/l10n/app_localizations.dart';

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

final _fakeItems = [
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

  Widget buildScreen() {
    return ProviderScope(
      overrides: [
        vocabularyRepositoryProvider
            .overrideWithValue(_FakeVocabularyRepository(_fakeItems)),
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
        home: const VocabularyScreen(),
      ),
    );
  }

  group('VocabularyScreen', () {
    testWidgets('renders all items after load', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Việt vị'), findsOneWidget);
      expect(find.text('Phạt đền'), findsOneWidget);
      expect(find.text('Phạm lỗi'), findsOneWidget);
    });

    testWidgets('search bar is present', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('typing in search bar filters list', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Type in search bar.
      await tester.enterText(find.byType(TextField), 'offside');
      // Wait for debounce.
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Only offside should be visible.
      expect(find.text('Offside'), findsOneWidget);
      // Penalty and foul should not be visible.
      expect(find.text('Phạt đền'), findsNothing);
      expect(find.text('Phạm lỗi'), findsNothing);
    });

    testWidgets('tapping a row expands it to show definition', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Tap the "Việt vị" row.
      await tester.tap(find.text('Việt vị'));
      await tester.pumpAndSettle();

      // Expanded content should be visible.
      expect(find.text('Luật việt vị'), findsOneWidget);
      expect(find.text('Offside rule'), findsOneWidget);
    });

    testWidgets('empty search shows empty state with clear button',
        (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Type a query with no matches.
      await tester.enterText(find.byType(TextField), 'zzzzz_no_match');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.text('Không có kết quả'), findsOneWidget);
      expect(find.text('Xóa tìm kiếm'), findsOneWidget);
    });
  });
}
