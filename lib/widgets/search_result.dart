import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/search_screen.dart';

const KTextStyle = TextStyle(
  fontSize: 25,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

class SearchResult extends StatelessWidget {
  final String userName;
  final String imageUrl;
  final String email;
  final String phone;
  final int type;
  final bool flag; // to know either active user or suspended

  SearchResult(this.userName, this.imageUrl, this.phone, this.email, this.type,
      this.flag);

  void _delete(BuildContext ctx) async {
    final scaffold = ScaffoldMessenger.of(ctx);
    String mode;
    if (type == 0) {
      mode = 'hr';
    } else {
      mode = 'user';
    }
    try {
      Provider.of<Auth>(ctx, listen: false)
          .deleteUser(email: email, userMode: mode);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Suspended Successfully',
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.of(ctx)
          .pushReplacementNamed(SearchScreen.routeName, arguments: true);
    } catch (error) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Suspension failed!',
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.of(ctx)
          .pushReplacementNamed(SearchScreen.routeName, arguments: true);
    }
  }

  void _restore(BuildContext ctx) async {
    final scaffold = ScaffoldMessenger.of(ctx);
    try {
      Provider.of<Auth>(ctx, listen: false).restoreUser(email: email);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Restored Successfully',
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.of(ctx)
          .pushReplacementNamed(SearchScreen.routeName, arguments: false);
    } catch (error) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Restored failed!',
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.of(ctx)
          .pushReplacementNamed(SearchScreen.routeName, arguments: false);
    }
  }

  showDialogFunc(context, img, userName, email, phone) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              height: 320,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      img == ''
                          ? 'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'
                          : img,
                      width: 200,
                      height: 100,
                    ),
                  ),
                  Text(
                    userName,
                    style: KTextStyle,
                  ),
                  Text(
                    email,
                    style: KTextStyle,
                  ),
                  Text(
                    phone,
                    style: KTextStyle,
                  ),
                  ElevatedButton(
                    child: flag ? Text('Suspend') : Text('Restore'),
                    onPressed: () {
                      flag ? _delete(context) : _restore(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      shadowColor: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryTextTheme.button.color,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Warning'),
        content: Text('Are you sure you want to delete this user'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              _delete(context);
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
    return InkWell(
      onTap: () {
        showDialogFunc(
          context,
          imageUrl,
          userName,
          email,
          phone,
        );
      },
      child: ListTile(
        title: Text(userName),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl == ''
              ? 'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'
              : imageUrl),
        ),
        trailing: Container(
          width: 100,
          // child: IconButton(
          //   icon: Icon(Icons.delete),
          //   onPressed: () {
          //     _showWarningDialog(context);
          //   },
          //   color: Theme.of(context).errorColor,
          // ),
        ),
      ),
    );
  }
}
