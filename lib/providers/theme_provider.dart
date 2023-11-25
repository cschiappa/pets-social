import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/themes/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  // set themeData(ThemeData themeData) {
  //   _themeData = themeData;
  //   notifyListeners();
  // }

  void toggleTheme() {
    _themeData =
        _themeData.brightness == Brightness.dark ? lightMode : darkMode;
    notifyListeners();
  }
}
