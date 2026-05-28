import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/onboarding_controller.dart';

/// Step 3 — Language selection: Tiếng Việt or English.
class LanguageStep extends ConsumerWidget {
  const LanguageStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final selectedLanguage =
        ref.watch(onboardingControllerProvider).selectedLanguage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.language,
            size: 72,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            'Choose your language',
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Chọn ngôn ngữ của bạn',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _LanguageButton(
            label: 'Tiếng Việt',
            languageCode: 'vi',
            isSelected: selectedLanguage == 'vi',
            onTap: () => ref
                .read(onboardingControllerProvider.notifier)
                .setLanguage('vi'),
          ),
          const SizedBox(height: 16),
          _LanguageButton(
            label: 'English',
            languageCode: 'en',
            isSelected: selectedLanguage == 'en',
            onTap: () => ref
                .read(onboardingControllerProvider.notifier)
                .setLanguage('en'),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.label,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          backgroundColor: isSelected
              ? colorScheme.primary.withValues(alpha: 0.08)
              : null,
        ),
        child: Text(
          label,
          style: textTheme.titleMedium?.copyWith(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
