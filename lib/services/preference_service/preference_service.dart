import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {

  String _themeKey = 'theme';
  String _fontSizeKey = 'fontSize';

  static PreferenceService _instance = PreferenceService();
  late final SharedPreferences _preferences;

  constructor() async {
    _preferences = await SharedPreferences.getInstance();
  }

  factory PreferenceService() {
    return _instance;
  }

  Future<void> setTheme(String theme) async {
    await _preferences.setString(_themeKey, theme);
  }

  String getTheme() {
    return _preferences.getString(_themeKey) ?? 'Claro';
  }

  Future<void> setFontSize(String fontSize) async {
    await _preferences.setString(_fontSizeKey, fontSize);
  }

  String getFontSize() {
    return _preferences.getString(_fontSizeKey) ?? 'Pequeña';
  }
}