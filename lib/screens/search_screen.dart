import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_home_screen.dart';
import 'user_home_screen.dart';
import '../models/user.dart';
import '../providers/user_mode.dart';
import '../providers/auth.dart';
import '../widgets/search_result.dart';
import '../widgets/search_widget.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-account';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _isLoading = false;
  String query = '';
  List<User> users = [];
  List<User> suspendedUsers = [];

  Future<void> _refresh(BuildContext context, String mode, bool type) async {
    print(type);
    if (type) {
      await Provider.of<Auth>(context, listen: false).fetchUsers(mode);
      final user = Provider.of<Auth>(context, listen: false);
      setState(() {
        users = user.users;
      });
    } else {
      await Provider.of<Auth>(context, listen: false).fetchSuspendedUsers(mode);
      final user = Provider.of<Auth>(context, listen: false);
      setState(() {
        suspendedUsers = user.suspendedUsers;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final user = Provider.of<Auth>(context, listen: false);
    users = user.users;
    suspendedUsers = user.suspendedUsers;
  }

  @override
  Widget build(BuildContext context) {
    final userMode = Provider.of<UserMode>(context, listen: false);
    final user = Provider.of<Auth>(context, listen: true);
    final height = MediaQuery.of(context).size.height;
    final type = ModalRoute.of(context).settings.arguments as bool;

    void searchUser(String query) {
      if (type) {
        final selecteduser = user.users.where((user) {
          final userLower = user.userName.toLowerCase();
          final searchLower = query.toLowerCase();
          return userLower.contains(searchLower);
        }).toList();

        setState(() {
          this.query = query;
          this.users = selecteduser;
        });
      } else {
        final selecteduser = user.suspendedUsers.where((user) {
          final userLower = user.userName.toLowerCase();
          final searchLower = query.toLowerCase();
          return userLower.contains(searchLower);
        }).toList();

        setState(() {
          this.query = query;
          this.suspendedUsers = selecteduser;
        });
      }
    }

    Widget buildSearch() => SearchWidget(
          text: query,
          hintText: 'Employee Name',
          onChanged: searchUser,
        );

    return Scaffold(
      appBar: AppBar(
        title: type ? Text('Search Account') : Text('Suspended Employees'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print(userMode.mode);
            if (userMode.mode == 'admin')
              Navigator.of(context)
                  .pushReplacementNamed(AdminHomeScreen.routeName);
            else
              Navigator.of(context)
                  .pushReplacementNamed(UserHomeScreen.routeName);
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refresh(context, userMode.mode, type),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  buildSearch(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: type ? users.length : suspendedUsers.length,
                      itemBuilder: (_, index) => Column(
                        children: [
                          type
                              ? SearchResult(
                                  users[index].userName,
                                  users[index].image,
                                  users[index].phone,
                                  users[index].email,
                                  users[index].type,
                                  true,
                                )
                              : SearchResult(
                                  suspendedUsers[index].userName,
                                  suspendedUsers[index].image,
                                  suspendedUsers[index].phone,
                                  suspendedUsers[index].email,
                                  suspendedUsers[index].type,
                                  false,
                                ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
