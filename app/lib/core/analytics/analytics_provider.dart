import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_service.dart';

/// Provides a singleton [AnalyticsService].
///
/// Wraps [FirebaseAnalytics.instance] in a try/catch so the app boots
/// gracefully when Firebase is not configured (no google-services.json /
/// GoogleService-Info.plist). In that case, analytics silently no-ops.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  try {
    return AnalyticsService(FirebaseAnalytics.instance);
  } catch (_) {
    return AnalyticsService(null);
  }
});
