import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Function press;
  CustomTextButton(this.title, this.press);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        title,
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        shadowColor: Theme.of(context).primaryColor,
        textStyle: TextStyle(
          color: Theme.of(context).primaryTextTheme.button.color,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Anton',
        ),
      ),
    );
  }
}
