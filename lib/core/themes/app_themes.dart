import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData.light();

  static ThemeData darkTheme = ThemeData.dark();

  static ThemeData getTheme(bool isDark) {
    return isDark ? darkTheme : lightTheme;
  }
}
