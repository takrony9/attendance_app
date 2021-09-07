import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_mode.dart';
import '../providers/auth.dart';

class VacationCard extends StatelessWidget {
  final String date;
  final String label;
  final int id;
  VacationCard({this.date, this.label, this.id});

  void _delete(BuildContext ctx) async {
    final scaffold = ScaffoldMessenger.of(ctx);

    try {
      Provider.of<Auth>(ctx, listen: false).deleteVacation(id: id);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Deleted Successfully',
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.of(ctx).pop();
    } catch (error) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Deleting failed!',
            textAlign: TextAlign.center,
          ),
        ),
      );
      Navigator.of(ctx).pop();
    }
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
    final userMode = Provider.of<UserMode>(context, listen: false);
    return Card(
      child: Row(
        children: [
          Text(date),
          Spacer(),
          Text(label == null ? '' : label),
          Spacer(),
          if (userMode.mode != 'user')
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showWarningDialog(context);
              },
              color: Theme.of(context).errorColor,
            )
        ],
      ),
    );
  }
}
