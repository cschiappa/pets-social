import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Colors.white,
    secondary: Color.fromRGBO(242, 102, 139, 1),
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
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Colors.black,
    primary: Colors.white,
    secondary: Color.fromRGBO(242, 102, 139, 1),
    tertiary: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  highlightColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    scrolledUnderElevation: 0.0,
  ),
);
