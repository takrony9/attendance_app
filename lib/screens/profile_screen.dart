import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/side_drawer.dart';
import '../widgets/profile_pic.dart';
import '../widgets/information.dart';
import '../providers/auth.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProfileScreen.routeName, arguments: {
                "username": user.user.userName,
                "phone": user.user.phone,
                "email": user.user.email,
                "image": user.user.image,
              });
            },
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfilePic(false, user.user.image),
            SizedBox(height: 50),
            Information('Name:', user.user.userName),
            SizedBox(height: 20),
            Information('Email:', user.user.email),
            SizedBox(height: 20),
            Information('phone No:', user.user.phone),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
