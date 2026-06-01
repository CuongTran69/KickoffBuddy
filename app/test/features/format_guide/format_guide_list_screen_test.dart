import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:kickoff_buddy/features/format_guide/data/format_guide_repository.dart';
import 'package:kickoff_buddy/features/format_guide/data/format_guide_section.dart';
import 'package:kickoff_buddy/features/format_guide/presentation/format_guide_list_screen.dart';
import 'package:kickoff_buddy/l10n/app_localizations.dart';

/// Fake repository returning a minimal set of known sections.
class _FakeFormatGuideRepository extends FormatGuideRepository {
  final List<FormatGuideSection> _sections;

  _FakeFormatGuideRepository(this._sections);

  @override
  Future<List<FormatGuideSection>> getAll() async => _sections;
}

final _fakeSections = [
  const FormatGuideSection(
    id: 'overview',
    titleVi: 'Tổng quan giải đấu',
    bodyVi: 'Nội dung tổng quan.',
    icon: 'public',
  ),
  const FormatGuideSection(
    id: 'groups',
    titleVi: 'Vòng bảng',
    bodyVi: 'Nội dung vòng bảng.',
    icon: 'groups',
  ),
  const FormatGuideSection(
    id: 'tiebreakers',
    titleVi: 'Tiêu chí phân hạng',
    bodyVi: 'Nội dung tiêu chí.',
    icon: 'compare_arrows',
    bullets: ['Hiệu số bàn thắng', 'Số bàn thắng'],
  ),
];

Widget buildScreen() {
  final router = GoRouter(
    initialLocation: '/format-guide',
    routes: [
      GoRoute(
        path: '/format-guide',
        builder: (context, state) => const FormatGuideListScreen(),
      ),
      GoRoute(
        path: '/format-guide/:id',
        builder: (context, state) => Scaffold(
          body: Text('Detail: ${state.pathParameters['id']}'),
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      formatGuideRepositoryProvider
          .overrideWithValue(_FakeFormatGuideRepository(_fakeSections)),
    ],
    child: MaterialApp.router(
      locale: const Locale('vi'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi'), Locale('en')],
      routerConfig: router,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FormatGuideListScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(buildScreen());
      // Before async data loads, show loading.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders section tiles after load', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Tổng quan giải đấu'), findsOneWidget);
      expect(find.text('Vòng bảng'), findsOneWidget);
      expect(find.text('Tiêu chí phân hạng'), findsOneWidget);
    });

    testWidgets('app bar shows correct title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Vietnamese locale: "Thể thức giải đấu"
      expect(find.text('Thể thức giải đấu'), findsOneWidget);
    });

    testWidgets('each tile has a chevron icon', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsNWidgets(3));
    });

    testWidgets('tapping a tile navigates to detail screen', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Tap the first tile.
      await tester.tap(find.text('Tổng quan giải đấu'));
      await tester.pumpAndSettle();

      // Should navigate to detail screen showing the section id.
      expect(find.text('Detail: overview'), findsOneWidget);
      // List screen should no longer be visible.
      expect(find.text('Tổng quan giải đấu'), findsNothing);
    });
  });
}

