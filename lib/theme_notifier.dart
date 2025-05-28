import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'ComicSans',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'ComicSans',
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
    ),
  );
}
