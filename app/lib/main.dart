import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/notifications/notification_service.dart';
import 'core/storage/prefs_provider.dart';
import 'core/time/timezone_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization — graceful fallback when config files are absent.
  // Analytics will silently no-op via AnalyticsService(null) in that case.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (kDebugMode) {
      debugPrint('[Analytics] Firebase init skipped: $e');
    }
  }

  await TimezoneService.initialize();
  // TeamLookupService is loaded lazily via teamLookupServiceProvider (D6).
  await NotificationService.instance.initialize();
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: const KickoffBuddyApp(),
  ));
}
