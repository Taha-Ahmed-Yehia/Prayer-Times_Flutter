
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationAPI{
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    _notifications.show(id, title, body, await _notificationDetail(), payload: payLoad);
  }

  static Future scheduleNotification(int id, String title,
      String body, DateTime scheduledDate,{ String? payLoad}
  ) async {
    var tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);
    _notifications.zonedSchedule(
        id,
        title,
        body,
        payload: payLoad,
        tzDateTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            id.toString(),
            "Prayer Time",
            importance: Importance.max,
            priority: Priority.max,
            icon: "app_icon",
            sound: RawResourceAndroidNotificationSound('adhan'),
            playSound: true,
            enableLights: true
          ),
          iOS: DarwinNotificationDetails()
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }
  static _notificationDetail() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.max),
      iOS: DarwinNotificationDetails()
    );
  }

  static Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings("app_icon");

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payLoad) async {  }
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await _notifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {}
    );
  }
}