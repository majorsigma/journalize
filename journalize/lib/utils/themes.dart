import 'package:flutter/material.dart';

class JournalTheme {
  ThemeData lightTheme = ThemeData(
    fontFamily: "Exo",
    primaryColor: Colors.white,
    accentColor: Color(0xFFF6C791),
    canvasColor: Colors.white,
    textSelectionColor: Color(0xFFF6C791),
    cursorColor: Color(0xFFF6C791),
    indicatorColor: Color(0xFFF6C791),
    textSelectionHandleColor: Color(0xFFF6C791),
    colorScheme: ColorScheme.light(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFF6C791),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
    ),
    buttonTheme: ButtonThemeData(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFF6C791),
    ),
  );

  ThemeData darkTheme = ThemeData(
    fontFamily: "Dosis",
    primaryColor: Color(0xFF272822),
    accentColor: Color(0xFFFFCF38),
    canvasColor: Color(0xFF272822),
    textSelectionColor: Color(0xFFFFCF38),
    cursorColor: Color(0xFFFFCF38),
    indicatorColor: Color(0xFFFFCF38),
    textSelectionHandleColor: Color(0xFFFFCF38),
    colorScheme: ColorScheme.dark(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFCF38),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Color(0xFF272822),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF272822),
      selectedItemColor: Color(0xFFFFCF38),
    ),
  );
}
