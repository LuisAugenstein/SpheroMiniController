import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final Function press;

  MyTextButton({this.text, this.press});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue[300],
      textColor: Colors.white,
      onPressed: press,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text == null ? "" : text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
