import 'package:flutter/material.dart';

import 'vacations_screen.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/side_drawer.dart';
import 'create_account_user.dart';
import 'show_report_screen.dart';
import 'search_screen.dart';
import 'requested_vacations_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  static const routeName = '/admin-home';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        centerTitle: true,
      ),
      drawer: SideDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.3,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextButton(
              'Show Daily Reports',
              () {
                Navigator.of(context).pushNamed(ShowReportScreen.routeName);
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextButton(
              'Create HR Account',
              () {
                Navigator.of(context).pushNamed(CreateAccountUser.routeName);
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextButton(
              'Search for user',
              () {
                Navigator.of(context)
                    .pushNamed(SearchScreen.routeName, arguments: true);
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextButton(
              'Vacations',
              () {
                Navigator.of(context).pushNamed(VacationsScreen.routeName);
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextButton(
              'Suspended users',
              () {
                Navigator.of(context)
                    .pushNamed(SearchScreen.routeName, arguments: false);
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextButton(
              'Requested Vacations',
              () {
                Navigator.of(context)
                    .pushNamed(RequestedVacationsScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
