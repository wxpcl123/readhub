import 'package:flutter/material.dart';

abstract class MyTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Color(0xFF2B648C),
    primaryColorLight: Colors.black,
    primaryColorDark: Color(0xFF3C4042),
    accentColor: Colors.orange,
    backgroundColor: Color(0xFFF0F0F0),
    scaffoldBackgroundColor: Colors.white,
    secondaryHeaderColor: Colors.grey,
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Color(0xFF101010),
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.white70,
    accentColor: Color(0xFF16B888),
    backgroundColor: Color(0xFF101010),
    scaffoldBackgroundColor: Color(0xFF3C4042),
    secondaryHeaderColor: Colors.grey,
  );
}
