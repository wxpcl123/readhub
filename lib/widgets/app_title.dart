import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(text: 'Read', children: [
        TextSpan(
          text: 'Hub',
          style: TextStyle(
            // color: Get.theme.accentColor,
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.w500,
          ),
        )
      ]),
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
