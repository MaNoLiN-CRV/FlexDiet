import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/services/preference_service/preference_service.dart';
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  String _currentThemeName = 'Claro';
  late PreferenceService _preferenceService;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _preferenceService = await PreferenceService.getInstance();
    _currentThemeName = _preferenceService.getTheme();
    _themeData = _currentThemeName == 'Claro' ? lightTheme : darkTheme;
    notifyListeners();
  }

  ThemeData get themeData => _themeData;
  String get currentThemeName => _currentThemeName;

  void setTheme(String themeName) async {
    _themeData = themeName == 'Claro' ? lightTheme : darkTheme;
    _currentThemeName = themeName;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', themeName);
  }
}
