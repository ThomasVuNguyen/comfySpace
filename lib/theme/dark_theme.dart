import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.red,
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Color(0xff36343B),
    textColor: Color(0xffE6E0E9),
  ),
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    color: Color(0xff141218),
    titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xffCAC4D0)),

  ),

    colorScheme: const ColorScheme.dark(
      background: Color(0xff141218),
      primary: Color(0xff4F378B),
      onPrimary: Color(0xffEADDFF),
      primaryContainer: Color(0xff4F378B),
      secondary: Colors.purple,
      onSecondary: Colors.green,
      tertiary: Color(0xffCAC4D0),
      secondaryContainer: Colors.cyan,
      inversePrimary: Colors.yellow,

    ),
    /*textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Color(0xffE6E0E9),
      displayColor: Colors.purple,
    )*/
);