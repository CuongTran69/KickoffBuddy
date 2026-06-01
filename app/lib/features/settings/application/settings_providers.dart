import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/prefs_provider.dart';

/// Provider for managing the app's [ThemeMode].
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._ref) : super(ThemeMode.system) {
    _init();
  }

  final Ref _ref;

  void _init() {
    final prefs = _ref.read(sharedPreferencesProvider);
    final value = prefs.getString('theme_mode');
    if (value == 'light') {
      state = ThemeMode.light;
    } else if (value == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = _ref.read(sharedPreferencesProvider);
    await prefs.setString('theme_mode', mode.name);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});

/// Provider for managing the app's [Locale].
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(this._ref) : super(null) {
    _init();
  }

  final Ref _ref;

  void _init() {
    final prefs = _ref.read(sharedPreferencesProvider);
    final value = prefs.getString('locale_code');
    if (value != null) {
      state = Locale(value);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = _ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove('locale_code');
    } else {
      await prefs.setString('locale_code', locale.languageCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier(ref);
});
