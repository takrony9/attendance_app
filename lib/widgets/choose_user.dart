import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_mode.dart';

class ChooseUser extends StatefulWidget {
  @override
  _ChooseUserState createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserMode>(context, listen: false);
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.all(Colors.blue),
          value: userMode.adminValue,
          onChanged: (value) {
            setState(() {
              userMode.adminValue = value;
              userMode.chooseUserLogic('admin');
            });
          },
        ),
        SizedBox(
          width: 2.5,
        ),
        Text("Admin"),
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.all(Colors.blue),
          value: userMode.hrValue,
          onChanged: (value) {
            setState(() {
              userMode.hrValue = value;
              userMode.chooseUserLogic("hr");
            });
          },
        ),
        SizedBox(
          width: 2.5,
        ),
        Text("HR"),
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.all(Colors.blue),
          value: userMode.userValue,
          onChanged: (value) {
            setState(() {
              userMode.userValue = value;
              userMode.chooseUserLogic("user");
            });
          },
        ),
        SizedBox(
          width: 2.5,
        ),
        Text("Employee"),
      ],
    );
  }
}
