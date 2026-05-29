import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_events.dart';

/// Thin wrapper around [FirebaseAnalytics] with privacy-enforcing allowlist.
///
/// Design decisions (D5, D6):
/// - Accepts a nullable [FirebaseAnalytics] so the app boots even when
///   google-services.json / GoogleService-Info.plist are absent.
/// - [logEvent] silently no-ops when analytics is unavailable.
/// - Params are filtered through [AnalyticsEvents.allowedParams] before
///   forwarding to Firebase — disallowed keys are stripped without error.
class AnalyticsService {
  AnalyticsService(FirebaseAnalytics? analytics)
      : _analytics = analytics,
        _isAvailable = analytics != null;

  final FirebaseAnalytics? _analytics;
  final bool _isAvailable;

  /// Logs an analytics event with optional parameters.
  ///
  /// If analytics is unavailable, returns immediately without throwing.
  /// Parameters are filtered to only include keys in the allowlist for [name].
  Future<void> logEvent(String name, [Map<String, Object?>? params]) async {
    if (!_isAvailable) return;

    final allowed = AnalyticsEvents.allowedParams[name];
    Map<String, Object?>? filtered;

    if (params != null && allowed != null) {
      filtered = {
        for (final entry in params.entries)
          if (allowed.contains(entry.key)) entry.key: entry.value,
      };
    } else if (params != null && allowed == null) {
      // Unknown event — strip all params as a safety measure.
      filtered = {};
    }

    await _analytics?.logEvent(
      name: name,
      parameters: filtered?.map((k, v) => MapEntry(k, v ?? '')),
    );
  }
}
