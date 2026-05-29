import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/matches/presentation/magic_add_screen.dart';
import '../../features/matches/presentation/manual_add_screen.dart';
import '../../features/matches/presentation/match_detail_screen.dart';
import '../../features/matches/presentation/match_list_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/rule_cards/presentation/rule_card_detail_screen.dart';
import '../../features/rule_cards/presentation/rule_cards_screen.dart';
import '../../features/vocabulary/presentation/vocabulary_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/standings/presentation/standings_screen.dart';
import '../storage/prefs_provider.dart';
import 'app_shell.dart';
import 'routes.dart';

/// GoRouter instance exposed as a Riverpod provider.
/// Initial route is determined by the `onboarding_completed` SharedPreferences flag.
/// SharedPreferences is preloaded in main.dart before runApp, so this provider
/// is always synchronous — no async/loading state needed.
final appRouterProvider = Provider<GoRouter>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final completed = prefs.getBool('onboarding_completed') ?? false;
  final initial = completed ? Routes.home : Routes.onboarding;

  return GoRouter(
    initialLocation: initial,
    routes: [
      // Onboarding — outside the shell, no nav bar.
      GoRoute(
        path: Routes.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),

      // Detail / add routes — outside the shell, push over nav bar.
      GoRoute(
        path: Routes.matchesAdd,
        builder: (BuildContext context, GoRouterState state) {
          final home = state.uri.queryParameters['home'];
          final away = state.uri.queryParameters['away'];
          final sourceText = state.uri.queryParameters['sourceText'];
          final editMatchId = state.uri.queryParameters['edit'];
          return ManualAddScreen(
            prefillHome: home,
            prefillAway: away,
            prefillSourceText: sourceText,
            editMatchId: editMatchId,
          );
        },
      ),
      GoRoute(
        path: Routes.matchesMagicAdd,
        builder: (BuildContext context, GoRouterState state) =>
            const MagicAddScreen(),
      ),
      GoRoute(
        path: '/matches/:id',
        builder: (BuildContext context, GoRouterState state) {
          final matchId = state.pathParameters['id']!;
          return MatchDetailScreen(matchId: matchId);
        },
      ),
      GoRoute(
        path: '/rules/:id',
        builder: (BuildContext context, GoRouterState state) {
          final ruleId = state.pathParameters['id']!;
          return RuleCardDetailScreen(ruleId: ruleId);
        },
      ),
      GoRoute(
        path: Routes.vocabulary,
        builder: (BuildContext context, GoRouterState state) =>
            const VocabularyScreen(),
      ),

      // Shell — wraps the four primary tab destinations.
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.matches,
                builder: (BuildContext context, GoRouterState state) =>
                    const MatchListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.standings,
                builder: (BuildContext context, GoRouterState state) =>
                    const StandingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.rules,
                builder: (BuildContext context, GoRouterState state) =>
                    const RuleCardsScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (BuildContext context, GoRouterState state) =>
                    const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

