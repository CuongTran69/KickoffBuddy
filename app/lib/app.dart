import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/matches/application/match_polling_controller.dart';
import 'features/matches/data/match_providers.dart';
import 'features/settings/application/settings_providers.dart';
import 'l10n/app_localizations.dart';

/// Root widget for Kickoff Buddy.
class KickoffBuddyApp extends ConsumerWidget {
  const KickoffBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    // Trigger seed loader on app start. The provider handles the async
    // lifecycle — errors are logged and the app remains usable.
    ref.watch(seedLoaderProvider);

    return _PollingLifecycleWrapper(
      child: MaterialApp.router(
        title: 'Kickoff Buddy',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        locale: locale,
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi'),
          Locale('en'),
        ],
      ),
    );
  }
}

/// Wraps the app with a [WidgetsBindingObserver] that drives the
/// [MatchPollingController] based on app lifecycle state.
///
/// - resumed  → immediate sync + reschedule timer
/// - paused / inactive / detached → cancel timer
class _PollingLifecycleWrapper extends ConsumerStatefulWidget {
  const _PollingLifecycleWrapper({required this.child});

  final Widget child;

  @override
  ConsumerState<_PollingLifecycleWrapper> createState() =>
      _PollingLifecycleWrapperState();
}

class _PollingLifecycleWrapperState
    extends ConsumerState<_PollingLifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Kick off an initial poll when the app first starts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchPollingControllerProvider).onResumed();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(matchPollingControllerProvider);
    switch (state) {
      case AppLifecycleState.resumed:
        controller.onResumed();
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        controller.onBackground();
      case AppLifecycleState.hidden:
        controller.onBackground();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
