import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final Function press;
  final Color color;
  final double size;
  final String tooltip;
  MyIconButton({this.icon, this.press, this.color, this.size = 40, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: color,
        shape: CircleBorder(),
      ),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon),
        iconSize: size,
        color: Colors.white,
        onPressed: press,
      ),
    );
  }
}
