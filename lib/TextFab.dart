import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFab extends StatelessWidget {
  final String text;
  final onPressed;
  final icon;

  TextFab(this.text, this.onPressed, this.icon);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 10,
      color: Colors.deepPurple,
      splashColor: Colors.deepPurpleAccent,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Colors.deepPurpleAccent)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          MaterialButton(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
