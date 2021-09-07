import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/local_notification.dart';
import '../providers/user_mode.dart';
import '../screens/admin_home_screen.dart';
import '../screens/user_home_screen.dart';
import '../screens/requested_vacations_screen.dart';
import '../screens/personal_vacation_screen.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print('background');
  print(message.notification.body);
  print(message.notification.title);
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void chooseUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userMode')) {
      return;
    }
    final extractedUserData = prefs.getString('userMode');
    final user = await Provider.of<UserMode>(context, listen: false);
    user.setMode(extractedUserData);
    if (user.mode == 'admin')
      Navigator.of(context).pushReplacementNamed(AdminHomeScreen.routeName);
    else
      Navigator.of(context).pushReplacementNamed(UserHomeScreen.routeName);
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> setupInteractedMessage() async {
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print(message.notification.body);
    final userMode = Provider.of<UserMode>(context, listen: false);
    if (userMode.mode == 'admin') {
      print('takky');
      print(message.data['case']);
      Navigator.of(context).pushNamed(RequestedVacationsScreen.routeName);
    } else if (userMode.mode == 'user') {
      Navigator.of(context).pushNamed(PersonalVacationsScreen.routeName);
    } else if (userMode.mode == 'hr') {
      if (message.notification.body.contains('from'))
        Navigator.of(context).pushNamed(PersonalVacationsScreen.routeName);
      else
        Navigator.of(context).pushNamed(RequestedVacationsScreen.routeName);
    }
  }

  void notitficationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void initState() {
    super.initState();
    notitficationPermission();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    LocalNotificationService.initialize(context);
    setupInteractedMessage();

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification.body);
        print(message.notification.title);
        print('forground');
      }
      LocalNotificationService.display(message);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chooseUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
