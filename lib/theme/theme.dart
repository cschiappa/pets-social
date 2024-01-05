import 'package:flutter/material.dart';

//LIGHT MODE
ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.white,
    secondary: Colors.pink.shade300,
    tertiary: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.white,
  highlightColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    scrolledUnderElevation: 0.0,
  ),
  dividerColor: Colors.black,
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  ),
);

//DARK MODE
ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.white,
    secondary: Colors.pink.shade300,
    tertiary: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  highlightColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    scrolledUnderElevation: 0.0,
  ),
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating, backgroundColor: Color.fromRGBO(28, 28, 28, 1), contentTextStyle: TextStyle(color: Colors.white)),
);
