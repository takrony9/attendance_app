import 'package:flutter/material.dart';

class Information extends StatelessWidget {
  Information(
    this.text,
    this.data,
  );

  final String text, data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Anton',
            ),
          )),
          SizedBox(width: 10),
          Expanded(
              child: Text(
            data,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Anton',
            ),
          )),
        ],
      ),
    );
  }
}
