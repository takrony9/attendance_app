import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_pic.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../providers/user_mode.dart';
import 'profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _passwordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneNoFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  String userName;
  String email;
  String phone;
  String image;
  String password;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _phoneNoFocusNode.dispose();
    super.dispose();
  }

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

  void _saveForm(String userMode) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .updateUser(userName, email, phone, password, userMode);
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

  void _showWarningDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Warning'),
        content: Text('The changes you have done doesn\'t saved yet'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pushNamed(ProfileScreen.routeName);
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
    //final user = Provider.of<Auth>(context, listen: false);
    final userMode = Provider.of<UserMode>(context, listen: false);
    final user =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _showWarningDialog,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(userMode.mode),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    ProfilePic(true, user['image']),
                    TextFormField(
                      initialValue: user['username'],
                      decoration: InputDecoration(labelText: 'User Name'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
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
                      initialValue: user['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
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
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneNoFocusNode);
                      },
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
                      initialValue: user['phone'],
                      decoration: InputDecoration(labelText: 'Phone No'),
                      keyboardType: TextInputType.number,
                      focusNode: _phoneNoFocusNode,
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
                  ],
                ),
              ),
            ),
    );
  }
}
