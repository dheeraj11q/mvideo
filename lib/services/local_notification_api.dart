import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// [for loacal notification]
class LocalNotificationApi {
  static final _flutterLocalNotifications = FlutterLocalNotificationsPlugin();

  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel id,",
          "channel name",
          channelDescription: "channel description",
          importance: Importance.max,
          playSound: false,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: IOSNotificationDetails());
  }

  // [for onSelect notification initialize]
  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    tz.initializeTimeZones();
    await _flutterLocalNotifications.initialize(settings,
        onSelectNotification: (payload) {
      // onNotification.add(payload);
    });
  }

  // [for show notification loacal]
  static Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    _flutterLocalNotifications.show(0, title, body, _notificationDetails(),
        payload: payload);
  }

  static Future<void> showScheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {
    _flutterLocalNotifications.zonedSchedule(0, title, body,
        tz.TZDateTime.from(scheduledDate, tz.local), _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
