import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

/// Real implementation of the notification service wrapping
/// [FlutterLocalNotificationsPlugin].
///
/// Design decisions:
/// - D1: Permission requested on first "Set reminder" tap, NOT at boot.
/// - D3: Notification IDs are deterministic (computed by caller via
///   reminder_scheduler.dart).
/// - D4: All schedule calls use [tz.TZDateTime], never raw [DateTime].
/// - D7 (Sprint 4): Constructor accepts an optional [FlutterLocalNotificationsPlugin]
///   for testability. Production code uses the singleton which defaults to the
///   real plugin. Tests can pass a mock plugin directly.
class NotificationService {
  /// Creates a [NotificationService] with an optional [plugin] override.
  ///
  /// If [plugin] is null, the production [FlutterLocalNotificationsPlugin] is used.
  /// Pass a mock plugin in tests to avoid real OS calls.
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService();

  /// Singleton accessor.
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _plugin;

  static const String _channelId = 'match_reminders';
  static const String _channelName = 'Match reminders';
  static const String _channelDescription =
      'Notifications before match kickoff and replay time';

  bool _initialized = false;

  /// Initialize the notification plugin and create the Android channel.
  ///
  /// Must be called before [runApp] in main.dart.
  /// iOS permissions are NOT requested here (deferred to first "Set reminder"
  /// tap per D1).
  /// Idempotent — calling twice is safe (second call is a no-op).
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS: do NOT request permissions at init time (D1 — deferred prompting).
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    // Create Android notification channel.
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request notification permissions from the OS.
  ///
  /// Returns true if permission was granted, false otherwise.
  /// On Android < 13, always returns true (auto-granted).
  Future<bool> requestPermissions() async {
    // iOS permission request.
    final iosResult = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    if (iosResult != null) {
      return iosResult;
    }

    // Android 13+ runtime permission.
    final androidResult = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // androidResult is null on Android < 13 (auto-granted).
    return androidResult ?? true;
  }

  /// Schedule a notification at [when] (must be a [tz.TZDateTime]).
  ///
  /// NEVER pass a raw [DateTime] — always use [tz.TZDateTime] per D4.
  Future<void> scheduleAt(
    int id,
    String title,
    String body,
    tz.TZDateTime when, {
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      when,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Cancel a single notification by [id].
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Returns true if the app can schedule exact alarms.
  ///
  /// Always returns true on iOS and Android < 12.
  /// On Android 12+ (API 31+), queries the OS via
  /// [AndroidFlutterLocalNotificationsPlugin.canScheduleExactNotifications].
  /// Returns true if the result is null (older Android, auto-granted).
  Future<bool> canScheduleExactAlarms() async {
    // iOS never requires this permission.
    if (defaultTargetPlatform == TargetPlatform.iOS) return true;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return true;

    final result = await androidPlugin.canScheduleExactNotifications();
    // null means Android < 12 — exact alarms are auto-granted.
    return result ?? true;
  }
}

/// Riverpod provider exposing the [NotificationService] singleton.
final notificationServiceProvider = Provider<NotificationService>(
  (_) => NotificationService.instance,
);
