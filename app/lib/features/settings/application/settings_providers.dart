import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/prefs_provider.dart';

/// SharedPreferences key for the persisted theme mode.
const _kThemeModeKey = 'theme_mode';

/// SharedPreferences key for the persisted locale code.
const _kLocaleCodeKey = 'locale_code';

/// Provider for managing the app's [ThemeMode].
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._ref) : super(ThemeMode.system) {
    _init();
  }

  final Ref _ref;

  void _init() {
    final prefs = _ref.read(sharedPreferencesProvider);
    final value = prefs.getString(_kThemeModeKey);
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
    await prefs.setString(_kThemeModeKey, mode.name);
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
    final value = prefs.getString(_kLocaleCodeKey);
    if (value != null) {
      state = Locale(value);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = _ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(_kLocaleCodeKey);
    } else {
      await prefs.setString(_kLocaleCodeKey, locale.languageCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier(ref);
});
