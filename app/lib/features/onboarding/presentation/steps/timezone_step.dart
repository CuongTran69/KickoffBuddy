import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../application/onboarding_controller.dart';

/// Step 2 — Detect and confirm device timezone.
class TimezoneStep extends ConsumerStatefulWidget {
  const TimezoneStep({super.key});

  @override
  ConsumerState<TimezoneStep> createState() => _TimezoneStepState();
}

class _TimezoneStepState extends ConsumerState<TimezoneStep> {
  String? _timezone;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _detectTimezone();
  }

  Future<void> _detectTimezone() async {
    try {
      final tz = await FlutterTimezone.getLocalTimezone();
      if (mounted) {
        setState(() {
          _timezone = tz;
          _loading = false;
        });
        ref.read(onboardingControllerProvider.notifier).setTimezone(tz);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _timezone = 'Unknown';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 72,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'Your Timezone',
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (_loading)
            const CircularProgressIndicator()
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _timezone ?? 'Unknown',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            'Match times will be shown in your local timezone.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // "Change" is a no-op for Sprint 1 — Sprint 2 adds manual override
          TextButton(
            onPressed: null, // TODO(Sprint 2): manual timezone override
            child: const Text('Change timezone'),
          ),
        ],
      ),
    );
  }
}
