import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Synchronous provider for [SharedPreferences].
///
/// This provider must be overridden in `main.dart` with the preloaded instance
/// before `runApp` is called:
///
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// runApp(ProviderScope(
///   overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
///   child: const KickoffBuddyApp(),
/// ));
/// ```
///
/// Accessing this provider without an override will throw [UnimplementedError].
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main.dart with the preloaded instance',
  ),
);
