import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'package:kickoff_buddy/core/notifications/notification_service.dart';

/// Mock for [FlutterLocalNotificationsPlugin] using mocktail.
class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    // Register fallback values for all types used with any() matchers.
    registerFallbackValue(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    registerFallbackValue(
      tz.TZDateTime(tz.getLocation('Asia/Ho_Chi_Minh'), 2026, 6, 11, 20, 0),
    );
    registerFallbackValue(
      const NotificationDetails(
        android: AndroidNotificationDetails('id', 'name'),
      ),
    );
    registerFallbackValue(AndroidScheduleMode.exactAllowWhileIdle);
    registerFallbackValue(
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  });

  group('NotificationService', () {
    test('instance returns the same singleton', () {
      final a = NotificationService.instance;
      final b = NotificationService.instance;
      expect(identical(a, b), isTrue);
    });

    test('initialize is idempotent — plugin.initialize called only once',
        () async {
      final mockPlugin = MockFlutterLocalNotificationsPlugin();

      // Stub initialize to return true (success).
      when(() => mockPlugin.initialize(any())).thenAnswer((_) async => true);
      // Stub resolvePlatformSpecificImplementation to return null (no Android/iOS).
      when(() => mockPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>())
          .thenReturn(null);

      final service = NotificationService(mockPlugin);

      await service.initialize();
      await service.initialize(); // second call — should be a no-op

      // plugin.initialize must have been called exactly once.
      verify(() => mockPlugin.initialize(any())).called(1);
    });

    test('scheduleAt calls plugin.zonedSchedule with correct params', () async {
      final mockPlugin = MockFlutterLocalNotificationsPlugin();

      when(() => mockPlugin.zonedSchedule(
            any(),
            any(),
            any(),
            any(),
            any(),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            uiLocalNotificationDateInterpretation:
                any(named: 'uiLocalNotificationDateInterpretation'),
            payload: any(named: 'payload'),
          )).thenAnswer((_) async {});

      final service = NotificationService(mockPlugin);
      final scheduledAt = tz.TZDateTime(
        tz.getLocation('Asia/Ho_Chi_Minh'),
        2026,
        6,
        11,
        20,
        0,
      );

      await service.scheduleAt(
        42,
        'Match starts',
        'Brazil vs Argentina',
        scheduledAt,
        payload: 'test_payload',
      );

      verify(() => mockPlugin.zonedSchedule(
            42,
            'Match starts',
            'Brazil vs Argentina',
            scheduledAt,
            any(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: 'test_payload',
          )).called(1);
    });

    test('cancel calls plugin.cancel with the correct id', () async {
      final mockPlugin = MockFlutterLocalNotificationsPlugin();

      // Use a concrete value (not any()) for cancel since it takes a simple int.
      when(() => mockPlugin.cancel(99)).thenAnswer((_) async {});

      final service = NotificationService(mockPlugin);
      await service.cancel(99);

      verify(() => mockPlugin.cancel(99)).called(1);
    });
  });
}
