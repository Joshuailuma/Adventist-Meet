import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
//To intialize the nitification service
  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings);
  }

// TO create notification channel
  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/
          1000; //To get a unique id all the time, we divided it by 1000 to reduce the value

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("adventistmeet", "adventistmeet",
              importance: Importance.max, priority: Priority.high));

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.title, notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }
}
