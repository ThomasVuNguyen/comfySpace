import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    appBarTheme: AppBarTheme(
    ),
    primaryColor: Colors.black,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800,
  ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Colors.grey[800],
      displayColor: Colors.black,
)
);