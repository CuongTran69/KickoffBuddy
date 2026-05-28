import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/prefs_provider.dart';

/// State for the onboarding flow.
class OnboardingState {
  const OnboardingState({
    this.currentStep = 0,
    this.isCompleted = false,
    this.selectedLanguage,
    this.detectedTimezone,
  });

  final int currentStep;
  final bool isCompleted;
  final String? selectedLanguage; // 'vi' or 'en'
  final String? detectedTimezone; // IANA timezone name

  static const int totalSteps = 4;

  OnboardingState copyWith({
    int? currentStep,
    bool? isCompleted,
    String? selectedLanguage,
    String? detectedTimezone,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isCompleted: isCompleted ?? this.isCompleted,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      detectedTimezone: detectedTimezone ?? this.detectedTimezone,
    );
  }
}

/// Riverpod controller for the onboarding flow.
class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void nextStep() {
    if (state.currentStep < OnboardingState.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setLanguage(String languageCode) {
    state = state.copyWith(selectedLanguage: languageCode);
  }

  void setTimezone(String timezone) {
    state = state.copyWith(detectedTimezone: timezone);
  }

  /// Mark onboarding complete and persist the flag to SharedPreferences.
  Future<void> complete(SharedPreferences prefs) async {
    if (state.selectedLanguage != null) {
      await prefs.setString('app_language', state.selectedLanguage!);
    }
    await prefs.setBool('onboarding_completed', true);
    state = state.copyWith(isCompleted: true);
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

/// Convenience provider to access SharedPreferences synchronously within
/// onboarding (falls back gracefully if not yet loaded).
final onboardingPrefsProvider = Provider<AsyncValue<SharedPreferences>>((ref) {
  return ref.watch(sharedPreferencesProvider);
});
