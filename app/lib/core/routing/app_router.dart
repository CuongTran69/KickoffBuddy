import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../storage/prefs_provider.dart';
import 'routes.dart';

/// GoRouter instance exposed as a Riverpod provider.
/// Initial route is determined by the `onboarding_completed` SharedPreferences flag.
final appRouterProvider = Provider<GoRouter>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);

  // Determine initial location synchronously from cached prefs if available.
  final String initialLocation = prefsAsync.when(
    data: (prefs) {
      final completed = prefs.getBool('onboarding_completed') ?? false;
      return completed ? Routes.home : Routes.onboarding;
    },
    loading: () => Routes.onboarding,
    error: (_, __) => Routes.onboarding,
  );

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
    ],
  );
});
