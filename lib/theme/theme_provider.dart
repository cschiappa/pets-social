import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/theme/theme.dart';

final themeProvider = ChangeNotifierProvider<ThemeProvider>(
  (ref) {
    return ThemeProvider();
  },
);

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.dark ? lightMode : darkMode;
    notifyListeners();
  }
}
