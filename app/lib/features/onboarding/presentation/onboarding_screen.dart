import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../application/onboarding_controller.dart';
import 'steps/language_step.dart';
import 'steps/ready_step.dart';
import 'steps/timezone_step.dart';
import 'steps/welcome_step.dart';
import 'widgets/step_indicator.dart';

/// Onboarding flow — 4-step PageView with step indicator and navigation buttons.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  static const List<Widget> _steps = [
    WelcomeStep(),
    TimezoneStep(),
    LanguageStep(),
    ReadyStep(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext(int currentStep) {
    if (currentStep < OnboardingState.totalSteps - 1) {
      ref.read(onboardingControllerProvider.notifier).nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final currentStep = state.currentStep;
    final isLastStep = currentStep == OnboardingState.totalSteps - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            StepIndicator(
              totalSteps: OnboardingState.totalSteps,
              currentStep: currentStep,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _steps.length,
                itemBuilder: (context, index) => _steps[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: isLastStep
                  ? const SizedBox.shrink() // ReadyStep has its own button
                  : SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _onNext(currentStep),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(AppLocalizations.of(context).onboarding_btn_next),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
