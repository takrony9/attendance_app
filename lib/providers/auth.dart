import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../models/user.dart';
import '../models/vacations.dart';
import '../models/personal_vacations.dart';
import '../models/requested_vacations.dart';

class Auth with ChangeNotifier {
  User user = User();
  List<User> _users = [];
  List<User> _suspendedUsers = [];
  List<Vacations> _vacations = [];
  List<PersonalVacations> _personalVacations = [];
  List<RequestedVacations> _requestedVacations = [];
  File image;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  List<User> get users {
    return [..._users];
  }

  List<User> get suspendedUsers {
    return [..._suspendedUsers];
  }

  List<Vacations> get vacations {
    return [..._vacations];
  }

  List<PersonalVacations> get personalVacations {
    return [..._personalVacations];
  }

  List<RequestedVacations> get requestedVacations {
    return [..._requestedVacations];
  }

  bool get isAuth {
    return user.token != null;
  }

  Future<void> fetchUsers(String userMode) async {
    if (userMode == 'user') {
      return;
    }
    final url = Uri.parse('https://attendance.rmztech.net/api/$userMode/get');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      final response = await http.get(url, headers: userHeader);
      final Map<String, dynamic> extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      final List<User> loadedUsers = [];
      extractedData.forEach((type, value) {
        for (int i = 0; i < extractedData[type].length; i++) {
          loadedUsers.add(User(
            userId: value[i]['id'],
            email: value[i]['email'],
            userName: value[i]['username'],
            image: value[i]['image'],
            phone: value[i]['phone'],
            type: value[i]['type'],
          ));
        }
      });
      _users = loadedUsers;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deviceToken() async {
    String dToken;
    await _firebaseMessaging.getToken().then((token) {
      print('dah al token = $token');
      dToken = token;
    });
    print(dToken + 'kkkk');
    final url = Uri.parse('https://attendance.rmztech.net/api/device/token');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      await http.post(url,
          headers: userHeader,
          body: json.encode({
            'device_token': dToken,
          }));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updatePic(File img) {
    image = img;
    notifyListeners();
  }

  Future<void> updateUser(String userName, String email, String phone,
      String password, String userMode) async {
    final url =
        Uri.parse('https://attendance.rmztech.net/api/$userMode/update');
    String fileName;
    if (image != null) {
      fileName = image.path.split('/').last;
    }
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };

    try {
      FormData formData = FormData.fromMap({
        'username': userName,
        'email': email,
        'phone': phone,
        'password': password,
        if (image != null)
          "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });

      Response response = await Dio().post(url.toString(),
          options: Options(headers: userHeader), data: formData);
      // if (responseData['message'] == 'The given data was invalid.') {
      //   throw HttpException(responseData['message']);
      // }
      user.userName = userName;
      user.email = email;
      user.phone = phone;
      notifyListeners();
      print("File upload response: $response");
    } catch (error) {
      print("error:$error");
      image = null;
      throw (error);
    }
  }

  Future<void> createUser(
      {String userName,
      String email,
      String phone,
      String password,
      String userMode}) async {
    final url =
        Uri.parse('https://attendance.rmztech.net/api/$userMode/register');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      final response = await http.post(url,
          headers: userHeader,
          body: json.encode({
            'username': userName,
            'email': email,
            'phone': phone,
            'password': password,
          }));
      final responseData = json.decode(response.body);

      print(responseData['message'] == 'The given data was invalid.');
      if (responseData['message'] == 'The given data was invalid.') {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      print(error);
      throw (error);
      // throw (error);
    }
  }

  Future<void> deleteUser({String email, String userMode}) async {
    _users.removeWhere((element) => element.email == email);
    notifyListeners();
    final url =
        Uri.parse('https://attendance.rmztech.net/api/$userMode/delete');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      await http.post(url,
          headers: userHeader,
          body: json.encode({
            'email': email,
          }));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> _authenticate(
      String email, String password, String userMode) async {
    deviceToken();
    final url = Uri.parse('https://attendance.rmztech.net/api/$userMode/login');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    try {
      //print('000' + deviceToken + '000');
      final response = await http.post(
        url,
        headers: userHeader,
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      print('status ${response.statusCode}');
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['message'] == 'incorrect') {
        throw HttpException(responseData['message']);
      }
      user.token = responseData[userMode]['token'];
      user.userId = responseData[userMode]['id'];
      user.userName = responseData[userMode]['username'];
      user.email = responseData[userMode]['email'];
      user.phone = responseData[userMode]['phone'];
      user.image = responseData[userMode]['image'];
      notifyListeners();
      fetchUsers(userMode);
      fetchSuspendedUsers(userMode);
      fetchVacations();
      if (userMode != 'admin') {
        fetchPersonalVacations();
      }
      fetchRequestedVacations(userMode);
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': user.token,
          'userId': user.userId,
          'userName': user.userName,
          'userEmail': user.email,
          'userPhone': user.phone,
          'userImage': user.image,
        },
      );
      prefs.setString('userData', userData);
      prefs.setString('userMode', userMode);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password, String userMode) async {
    return _authenticate(email, password, userMode);
  }

  Future<bool> tryAutoLogin() async {
    deviceToken();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    user.token = extractedUserData['token'];
    user.userId = extractedUserData['userId'];
    user.userName = extractedUserData['userName'];
    user.email = extractedUserData['userEmail'];
    user.phone = extractedUserData['userPhone'];
    user.image = extractedUserData['userImage'];
    notifyListeners();
    fetchUsers(prefs.getString('userMode'));
    fetchSuspendedUsers(prefs.getString('userMode'));
    fetchVacations();
    if (prefs.getString('userMode') != 'admin') {
      fetchPersonalVacations();
    }
    fetchRequestedVacations(prefs.getString('userMode'));
    return true;
  }

  void logout(String userMode) async {
    final url =
        Uri.parse('https://attendance.rmztech.net/api/$userMode/logout');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    user.token = null;
    user.userId = '';
    user.userName = '';
    user.email = '';
    user.phone = '';
    user.image = '';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // // prefs.remove('userData');
    prefs.clear();
    final response = await http.post(url, headers: userHeader);
    final responseData = json.decode(response.body);
    print(responseData);
  }

  Future<void> fetchVacations() async {
    final url = Uri.parse('https://attendance.rmztech.net/api/vacation/get');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    try {
      final response = await http.get(url, headers: userHeader);
      final extractedData = json.decode(response.body);
      // print(extractedData);
      if (extractedData == null) {
        return;
      }
      final List<Vacations> loadedVacations = [];
      for (int i = 0; i < extractedData['vacation'].length; i++) {
        loadedVacations.add(Vacations(
          vacation: extractedData['vacation'][i]['date'],
          id: extractedData['vacation'][i]['id'],
          label: extractedData['vacation'][i]['label'],
        ));
      }
      _vacations = loadedVacations;
      _vacations = _vacations.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteVacation({int id}) async {
    _vacations.removeWhere((element) => element.id == id);
    notifyListeners();
    final url = Uri.parse('https://attendance.rmztech.net/api/vacation/delete');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      await http.post(url,
          headers: userHeader,
          body: json.encode({
            'id': id,
          }));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addVacation({dynamic date, String label}) async {
    final url = Uri.parse('https://attendance.rmztech.net/api/vacation/add');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      final response = await http.post(url,
          headers: userHeader,
          body: json.encode({
            "dates": date,
            "label": label,
          }));
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'The given data was invalid.') {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      print(error);
      throw (error);
      // throw (error);
    }
  }

  Future<void> fetchSuspendedUsers(String userMode) async {
    if (userMode == 'user') {
      return;
    }
    final url =
        Uri.parse('https://attendance.rmztech.net/api/$userMode/deleted');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      final response = await http.post(url, headers: userHeader);
      final Map<String, dynamic> extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      // print(extractedData);
      final List<User> loadedUsers = [];
      extractedData.forEach((type, value) {
        for (int i = 0; i < extractedData[type].length; i++) {
          loadedUsers.add(User(
            userId: value[i]['id'],
            email: value[i]['email'],
            userName: value[i]['username'],
            image: value[i]['image'],
            phone: value[i]['phone'],
            type: value[i]['type'],
          ));
        }
      });
      _suspendedUsers = loadedUsers;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> restoreUser({String email}) async {
    User userTemp = User();
    String userMode;
    userTemp = _suspendedUsers.firstWhere((element) => element.email == email);
    _suspendedUsers.removeWhere((element) => element.email == email);
    _users.add(userTemp);
    notifyListeners();
    if (userTemp.type == 0) {
      userMode = 'hr';
    } else {
      userMode = 'user';
    }
    final url =
        Uri.parse('https://attendance.rmztech.net/api/$userMode/restore');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      await http.post(url,
          headers: userHeader,
          body: json.encode({
            'email': email,
          }));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addPersonalVacation(
      {dynamic startDate, dynamic endDate, String label}) async {
    final url = Uri.parse('https://attendance.rmztech.net/api/permission/add');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      final response = await http.post(url,
          headers: userHeader,
          body: json.encode({
            "start_date": startDate,
            "end_date": endDate,
            "label": label,
          }));
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'The given data was invalid.') {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      print(error);
      throw (error);
      // throw (error);
    }
  }

  Future<void> fetchPersonalVacations() async {
    final url = Uri.parse('https://attendance.rmztech.net/api/permission/get');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      final response = await http.post(url, headers: userHeader);
      final extractedData = json.decode(response.body);
      //print(extractedData);
      if (extractedData == null) {
        return;
      }
      final List<PersonalVacations> loadedVacations = [];
      for (int i = 0; i < extractedData['user']['permissions'].length; i++) {
        loadedVacations.add(PersonalVacations(
          startDate: extractedData['user']['permissions'][i]['start_date'],
          endDate: extractedData['user']['permissions'][i]['end_date'],
          id: extractedData['user']['permissions'][i]['id'],
          label: extractedData['user']['permissions'][i]['label'],
          status: extractedData['user']['permissions'][i]['status'],
          userId: extractedData['user']['permissions'][i]['user_id'],
        ));
      }
      _personalVacations = loadedVacations;
      _personalVacations = _personalVacations.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchRequestedVacations(String userMode) async {
    if (userMode == 'user') {
      return;
    }
    final url =
        Uri.parse('https://attendance.rmztech.net/api/permission/get/all');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      final response = await http.get(url, headers: userHeader);
      final extractedData = json.decode(response.body);
      //print(extractedData);
      if (extractedData == null) {
        return;
      }
      final List<RequestedVacations> loadedVacations = [];
      if (userMode == 'admin') {
        print('gwa');
        String type = 'hr';
        for (int i = 0; i < extractedData['permissions'].length; i++) {
          if (extractedData['permissions'][i]['hr'] == null) {
            type = 'user';
          } else {
            type = 'hr';
          }
          loadedVacations.add(RequestedVacations(
            startDate: extractedData['permissions'][i]['start_date'],
            endDate: extractedData['permissions'][i]['end_date'],
            id: extractedData['permissions'][i]['id'],
            label: extractedData['permissions'][i]['label'],
            status: extractedData['permissions'][i]['status'],
            userId: extractedData['permissions'][i]['user_id'],
            userName: extractedData['permissions'][i][type]['username'],
            email: extractedData['permissions'][i][type]['email'],
            phone: extractedData['permissions'][i][type]['phone'],
            image: extractedData['permissions'][i][type]['image'],
          ));
        }
      } else {
        for (int i = 0; i < extractedData['permissions'].length; i++) {
          loadedVacations.add(RequestedVacations(
            startDate: extractedData['permissions'][i]['start_date'],
            endDate: extractedData['permissions'][i]['end_date'],
            id: extractedData['permissions'][i]['id'],
            label: extractedData['permissions'][i]['label'],
            status: extractedData['permissions'][i]['status'],
            userId: extractedData['permissions'][i]['user_id'],
            userName: extractedData['permissions'][i]['user']['username'],
            email: extractedData['permissions'][i]['user']['email'],
            phone: extractedData['permissions'][i]['user']['phone'],
            image: extractedData['permissions'][i]['user']['image'],
          ));
        }
      }
      _requestedVacations = loadedVacations;
      _requestedVacations = _requestedVacations.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> response({int id, String replay}) async {
    final url =
        Uri.parse('https://attendance.rmztech.net/api/permission/replay');
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ${user.token}',
    };
    try {
      await http.post(url,
          headers: userHeader,
          body: json.encode({
            'id': id,
            'replay': replay,
          }));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
