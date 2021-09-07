import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/search_screen.dart';
import './providers/auth.dart';
import './providers/user_mode.dart';
import './providers/timer_logic.dart';
import './screens/admin_home_screen.dart';
import './screens/auth_screen.dart';
import './screens/profile_screen.dart';
import './screens/personal_vacation_screen.dart';
import './screens/splash_screen.dart';
import './screens/edit_profile_screen.dart';
import './screens/create_account_user.dart';
import './screens/show_report_screen.dart';
import './screens/user_home_screen.dart';
import './screens/loading_screen.dart';
import './screens/vacations_screen.dart';
import './screens/requested_vacations_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UserMode(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: TimerLogic(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'RMZ Attendance',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.black,
          ),
          home: auth.isAuth
              ? LoadingScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            AdminHomeScreen.routeName: (ctx) => AdminHomeScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
            CreateAccountUser.routeName: (ctx) => CreateAccountUser(),
            ShowReportScreen.routeName: (ctx) => ShowReportScreen(),
            UserHomeScreen.routeName: (ctx) => UserHomeScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            VacationsScreen.routeName: (ctx) => VacationsScreen(),
            PersonalVacationsScreen.routeName: (ctx) =>
                PersonalVacationsScreen(),
            RequestedVacationsScreen.routeName: (ctx) =>
                RequestedVacationsScreen(),
          },
        ),
      ),
    );
  }
}
