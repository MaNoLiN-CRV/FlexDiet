import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/services/preference_service/preference_service.dart';
import 'package:flutter_flexdiet/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  String _currentThemeName = 'Claro';
  String _currentFontSize = 'Pequeña';
  late PreferenceService _preferenceService;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _preferenceService = await PreferenceService.getInstance();
    _currentThemeName = _preferenceService.getTheme();
    _currentFontSize = _preferenceService.getFontSize();
    notifyListeners();
  }

  ThemeData get themeData => _themeData;
  String get currentThemeName => _currentThemeName;
  String get currentFontSize => _currentFontSize;

  void setTheme(String themeName) {
    if (themeName == 'Claro') {
      _themeData = lightTheme;
    } else if (themeName == 'Oscuro') {
      _themeData = darkTheme;
    }
    _currentThemeName = themeName;
    notifyListeners();
  }

  void setFontSize(String fontName) {
    if (fontName == 'Pequeña') {
      _currentFontSize = 'Pequeña';
    } else if (fontName == 'Mediana') {
      _currentFontSize = 'Mediana';
    } else if (fontName == 'Grande') {
      _currentFontSize = 'Grande';
    }
    notifyListeners();
  }
}
