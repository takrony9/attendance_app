import 'package:flutter/foundation.dart';

enum userMode { Admin, HR, Employee }

class UserMode with ChangeNotifier {
  bool adminValue = false;
  bool hrValue = false;
  bool userValue = false;
  String mode;

  void setMode(String setMode) {
    mode = setMode;
    notifyListeners();
  }

  void chooseUserLogic(String type) {
    switch (type) {
      case "admin":
        {
          if (adminValue) {
            hrValue = false;
            userValue = false;
            mode = type;
            notifyListeners();
          }
        }
        break;

      case "hr":
        {
          if (hrValue) {
            adminValue = false;
            userValue = false;
            mode = type;
            notifyListeners();
          }
        }
        break;

      case "user":
        {
          if (userValue) {
            adminValue = false;
            hrValue = false;
            mode = type;
            notifyListeners();
          }
        }
        break;
    }
  }
}
