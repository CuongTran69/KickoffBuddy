import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:kickoff_buddy/features/replay_planner/presentation/widgets/spoiler_badge.dart';
import 'package:kickoff_buddy/features/replay_planner/presentation/widgets/spoiler_banner.dart';
import 'package:kickoff_buddy/l10n/app_localizations.dart';

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  });

  group('SpoilerBanner', () {
    Widget buildWithL10n(Widget child) => MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('vi'), Locale('en')],
          home: Scaffold(body: child),
        );

    testWidgets('renders shield icon and text', (tester) async {
      final plannedAt = DateTime(2026, 6, 15, 20, 0, 0);

      await tester.pumpWidget(
        buildWithL10n(SpoilerBanner(plannedAtLocal: plannedAt)),
      );

      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      // Text should contain "Bảo vệ spoiler đến"
      expect(
        find.textContaining('Bảo vệ spoiler đến'),
        findsOneWidget,
      );
    });

    testWidgets('banner is visible when rendered', (tester) async {
      final plannedAt = DateTime(2026, 6, 15, 20, 0, 0);

      await tester.pumpWidget(
        buildWithL10n(
          Column(
            children: [
              SpoilerBanner(plannedAtLocal: plannedAt),
              const Text('Other content'),
            ],
          ),
        ),
      );

      expect(find.byType(SpoilerBanner), findsOneWidget);
    });

    testWidgets('banner not rendered when not in widget tree', (tester) async {
      await tester.pumpWidget(
        buildWithL10n(const Text('No banner here')),
      );

      expect(find.byType(SpoilerBanner), findsNothing);
    });
  });

  group('SpoilerBadge', () {
    testWidgets('renders shield icon and Protected label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SpoilerBadge(),
          ),
        ),
      );

      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
      expect(find.text('Bảo vệ'), findsOneWidget);
    });

    testWidgets('badge not rendered when not in widget tree', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('No badge here'),
          ),
        ),
      );

      expect(find.byType(SpoilerBadge), findsNothing);
    });
  });
}
