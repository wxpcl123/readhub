import 'package:flutter/material.dart';

class MyDot extends StatelessWidget {
  final Color color;
  final EdgeInsetsGeometry margin;

  const MyDot({Key key, this.margin, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? Theme.of(context).secondaryHeaderColor,
          width: 2.0,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
