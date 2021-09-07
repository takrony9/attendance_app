import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan/barcode_scan.dart';

import '../providers/user_mode.dart';
import '../providers/auth.dart';
import '../providers/timer_logic.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/side_drawer.dart';
import '../widgets/profile_pic.dart';
import '../widgets/timer.dart';
import 'create_account_user.dart';
import 'show_report_screen.dart';
import 'search_screen.dart';
import 'vacations_screen.dart';
import 'personal_vacation_screen.dart';
import 'requested_vacations_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/users-home';

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String qrCodeResult;
  bool _isChecked = false;

  void _scanQrCode() async {
    String codeScanner = await BarcodeScanner.scan();
    print(codeScanner);
    setState(() {
      qrCodeResult = codeScanner;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false);
    final userMode = Provider.of<UserMode>(context, listen: true);
    final timer = Provider.of<TimerLogic>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        centerTitle: true,
      ),
      drawer: SideDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePic(false, user.user.image),
            SizedBox(
              height: 10,
            ),
            CustomTextButton(
              _isChecked ? 'CheckOut' : 'CheckIn',
              () async {
                await _scanQrCode();
                // print('qrCodeResult=======$qrCodeResult');
                if (qrCodeResult == 'http://l.ead.me/Dynamic-URL') {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                  timer.start = !timer.start;
                  timer.timerCount();
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            _isChecked ? Timer() : SizedBox(),
            userMode.mode == 'hr'
                ? CustomTextButton(
                    'Show Daily Reports',
                    () {
                      Navigator.of(context)
                          .pushNamed(ShowReportScreen.routeName);
                    },
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            userMode.mode == 'hr'
                ? CustomTextButton(
                    'Create Employee Account',
                    () {
                      Navigator.of(context)
                          .pushNamed(CreateAccountUser.routeName);
                    },
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            userMode.mode == 'hr'
                ? CustomTextButton(
                    'Search for Employee',
                    () {
                      Navigator.of(context)
                          .pushNamed(SearchScreen.routeName, arguments: true);
                    },
                  )
                : SizedBox(),
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
            userMode.mode == 'hr'
                ? CustomTextButton(
                    'Suspended users',
                    () {
                      Navigator.of(context)
                          .pushNamed(SearchScreen.routeName, arguments: false);
                    },
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            CustomTextButton(
              'Personal Vacations',
              () {
                Navigator.of(context)
                    .pushNamed(PersonalVacationsScreen.routeName);
              },
            ),
            SizedBox(
              height: 10,
            ),
            if (userMode.mode == 'hr')
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
