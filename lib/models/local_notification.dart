import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../providers/user_mode.dart';
import '../screens/requested_vacations_screen.dart';
import '../screens/personal_vacation_screen.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final userMode = Provider.of<UserMode>(context, listen: false);
    print('hnnnnnaa');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String route) async {
      print(userMode.mode);
      if (userMode.mode == 'admin') {
        print('ferass');
        Navigator.of(context).pushNamed(RequestedVacationsScreen.routeName);
      } else if (userMode.mode == 'user') {
        Navigator.of(context).pushNamed(PersonalVacationsScreen.routeName);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
        priority: Priority.high,
      ));

      await _notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        payload: 'Default_Sound',
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
