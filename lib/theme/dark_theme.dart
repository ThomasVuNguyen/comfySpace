import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  textTheme: TextTheme(
    titleMedium: GoogleFonts.poppins(fontSize: 14),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.red,

  ),
  dialogTheme: DialogTheme(
    backgroundColor: Color(0xff2B2930),
    titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xffE6E0E9), fontSize: 22),
    contentTextStyle: GoogleFonts.poppins(fontSize: 18.0),
    iconColor: Colors.red,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.red,
  ),
  listTileTheme: const ListTileThemeData(
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
      secondary: Color(0xff42287B),
      onSecondaryContainer: Color(0xffD0BCFF),
      onSecondary: Colors.green,
      tertiary: Color(0xffCAC4D0),
      secondaryContainer: Color(0xffE8DEF8),
      inversePrimary: Colors.yellow,
      surfaceVariant: Color(0xff211F26),

    ),
    /*textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Color(0xffE6E0E9),
      displayColor: Colors.purple,
    )*/
);