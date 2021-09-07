import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_mode.dart';
import '../providers/auth.dart';
import 'admin_home_screen.dart';
import 'user_home_screen.dart';
import '../models/http_exception.dart';

class CreateAccountUser extends StatefulWidget {
  static const routeName = '/create/delete-account';

  @override
  _CreateAccountUserState createState() => _CreateAccountUserState();
}

class _CreateAccountUserState extends State<CreateAccountUser> {
  final _form = GlobalKey<FormState>();
  String userName;
  String email;
  String phone;
  String password;
  var _isLoading = false;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _saveForm(BuildContext context, String userMode) async {
    final scaffold = ScaffoldMessenger.of(context);
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).createUser(
          userMode: userMode,
          userName: userName,
          email: email,
          phone: phone,
          password: password);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Created Successfully',
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showWarningDialog(BuildContext context, String userMode) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Warning'),
        content: Text('you didn\'t create Account yet'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              if (userMode == 'admin')
                Navigator.of(context)
                    .pushReplacementNamed(AdminHomeScreen.routeName);
              else
                Navigator.of(context)
                    .pushReplacementNamed(UserHomeScreen.routeName);
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserMode>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _showWarningDialog(context, userMode.mode),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(labelText: 'User Name'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a user name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userName = value;
                        },
                      ),
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(labelText: 'Email'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(labelText: 'Password'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                      TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(labelText: 'Phone No'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a phone no.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phone = value;
                        },
                      ),
                      TextButton(
                        child: Text('Create'),
                        onPressed: () {
                          if (userMode.mode == 'admin')
                            _saveForm(context, 'hr');
                          else
                            _saveForm(context, 'user');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          shadowColor: Theme.of(context).primaryColor,
                          textStyle: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .button
                                  .color,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
