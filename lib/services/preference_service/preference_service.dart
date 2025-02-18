import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static PreferenceService? _instance; // Nullable static instance
  static SharedPreferences? _preferences; // Nullable SharedPreferences

  final String _themeKey = 'theme';
  final String _fontSizeKey = 'fontSize';

  PreferenceService._(); // Private constructor

  // Asynchronous initialization method
  static Future<PreferenceService> getInstance() async {
    if (_instance == null) {
      _instance = PreferenceService._(); // Create instance
      _preferences =
          await SharedPreferences.getInstance(); // Initialize preferences
    }
    return _instance!; // Return the initialized instance
  }

  Future<void> setTheme(String theme) async {
    await _preferences?.setString(_themeKey, theme); // Use null-aware operator
  }

  String getTheme() {
    return _preferences?.getString(_themeKey) ??
        'Claro'; // Use null-aware operator
  }

  Future<void> setFontSize(String fontSize) async {
    await _preferences?.setString(
        _fontSizeKey, fontSize); // Use null-aware operator
  }

  String getFontSize() {
    return _preferences?.getString(_fontSizeKey) ??
        'Pequeña'; // Use null-aware operator
  }
}
