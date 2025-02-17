import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  String _currentThemeName = 'Claro';

  ThemeData get themeData => _themeData;
  String get currentThemeName => _currentThemeName;

  void setTheme(String themeName) {
    if (themeName == 'Claro') {
      _themeData = lightTheme;
    } else if (themeName == 'Oscuro') {
      _themeData = darkTheme;
    }
    _currentThemeName = themeName;
    notifyListeners();
  }
}
