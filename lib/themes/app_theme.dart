import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgColor = Color(0xffece8e1);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
    ),
    textTheme: const TextTheme(
      displayMedium: TextStyle(color: Colors.black),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueGrey,
    ),
    textTheme: const TextTheme(
      displayMedium: TextStyle(color: Colors.white),
    ),
  );
}

class AppCardTheme {
  // Predefined Colors
  static const Color green = Colors.green;
  static const Color blue = Colors.blue;
  static const Color orange = Colors.orange;
  static const Color purple = Colors.purple;
  static const Color grey = Colors.grey;

  // Custom Colors
  static const Color lightGreen = Color(0xffabc0a1);
  static const Color lightPurple = Color(0xffc8a2e5);
  static const Color lightBlue = Color(0xffbad7e9);
  static const Color lightOrange = Color(0xfff5d0c5);
  static const Color lightRed = Color.fromARGB(255, 247, 112, 112);
}
