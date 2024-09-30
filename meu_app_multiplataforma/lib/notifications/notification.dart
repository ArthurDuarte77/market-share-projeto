import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService{

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {}

  static Future<void> init() async{
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_laucher");

    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,);


      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

static Future<void> showInstantNotification(String title, String, body) async{
  const NotificationDetails plataforChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails("", "channelName", importance:  Importance.high, priority: Priority.high),
    iOS: DarwinNotificationDetails()
  );
  await flutterLocalNotificationsPlugin.show(0, title, body, plataforChannelSpecifics);
}

static Future<void> scheduleNotification(String title, String, body, DateTime scheduleTime) async{
  const NotificationDetails plataforChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails("", "channelName", importance:  Importance.high, priority: Priority.high),
    iOS: DarwinNotificationDetails()
  );
  await flutterLocalNotificationsPlugin.zonedSchedule(0, title, body, tz.TZDateTime.from(scheduleTime, tz.local), plataforChannelSpecifics,uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, matchDateTimeComponents: DateTimeComponents.dateAndTime);
}


}