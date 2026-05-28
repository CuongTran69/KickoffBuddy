import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/storage/prefs_provider.dart';
import '../../application/onboarding_controller.dart';

/// Step 4 — "All set" confirmation. Marks onboarding complete and navigates home.
class ReadyStep extends ConsumerWidget {
  const ReadyStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 96,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            "You're all set!",
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Kickoff Buddy is ready.\nMatch times in your timezone, no spoilers.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                final prefsAsync = ref.read(sharedPreferencesProvider);
                await prefsAsync.when(
                  data: (prefs) async {
                    await ref
                        .read(onboardingControllerProvider.notifier)
                        .complete(prefs);
                    if (context.mounted) {
                      context.go(Routes.home);
                    }
                  },
                  loading: () async {},
                  error: (_, __) async {},
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text("Let's go"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
