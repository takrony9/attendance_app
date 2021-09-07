import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/user_mode.dart';
import '../screens/admin_home_screen.dart';
import '../screens/user_home_screen.dart';
import '../screens/profile_screen.dart';

class SideDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, Function onTapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Anton',
          fontSize: 24,
        ),
      ),
      onTap: onTapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserMode>(context, listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Hello Friend!',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
            'Home',
            Icons.home,
            () {
              print(userMode.mode);
              if (userMode.mode == 'admin')
                Navigator.of(context)
                    .pushReplacementNamed(AdminHomeScreen.routeName);
              else
                Navigator.of(context)
                    .pushReplacementNamed(UserHomeScreen.routeName);
            },
          ),
          buildListTile(
            'Profile',
            Icons.account_circle,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          buildListTile(
            'Logout',
            Icons.logout,
            () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout(userMode.mode);
            },
          ),
        ],
      ),
    );
  }
}
