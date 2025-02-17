import 'package:flutter/material.dart';

const Color backgroundColorBlack = Color(0xFF121B2B);
const Color backgroundColorDarkBlue = Color(0xFF1F2A47);
const Color containersDarkBlue = Color(0xFF3A4D75);
const Color textLightBlue = Color(0xFFD1D9E6);

ThemeData darkTheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(seedColor: backgroundColorDarkBlue).copyWith(
    surface: backgroundColorBlack,
    primary: backgroundColorDarkBlue,
    secondary: containersDarkBlue,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textLightBlue,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: backgroundColorBlack,
  appBarTheme: AppBarTheme(
    backgroundColor: backgroundColorDarkBlue,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    elevation: 2,
    centerTitle: true,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 72.0,
        fontWeight: FontWeight.bold,
        color: backgroundColorBlack),
    displayMedium: TextStyle(
        fontSize: 56.0,
        fontWeight: FontWeight.bold,
        color: backgroundColorBlack),
    displaySmall: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: backgroundColorBlack),
    headlineLarge: TextStyle(
        fontSize: 36.0,
        fontWeight: FontWeight.bold,
        color: backgroundColorBlack),
    headlineMedium: TextStyle(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: textLightBlue),
    headlineSmall: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: backgroundColorBlack),
    titleLarge: TextStyle(
        fontSize: 22.0, fontWeight: FontWeight.w600, color: textLightBlue),
    titleMedium: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w500, color: textLightBlue),
    titleSmall: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w400, color: textLightBlue),
    bodyLarge: TextStyle(fontSize: 16.0, color: textLightBlue),
    bodyMedium: TextStyle(fontSize: 14.0, color: textLightBlue),
    bodySmall: TextStyle(fontSize: 12.0, color: textLightBlue),
    labelLarge: TextStyle(
        fontSize: 14.0, fontWeight: FontWeight.bold, color: textLightBlue),
    labelMedium: TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.bold, color: textLightBlue),
    labelSmall: TextStyle(
        fontSize: 10.0, fontWeight: FontWeight.bold, color: textLightBlue),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: textLightBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 3,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: containersDarkBlue,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      side: const BorderSide(color: containersDarkBlue),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: containersDarkBlue,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: backgroundColorBlack,
    hintStyle: TextStyle(color: textLightBlue.withAlpha(128)),
    labelStyle:
        const TextStyle(color: textLightBlue, fontWeight: FontWeight.w500),
    floatingLabelStyle: const TextStyle(color: textLightBlue),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: textLightBlue.withAlpha(76)),
      borderRadius: BorderRadius.circular(12.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: textLightBlue.withAlpha(76)),
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: textLightBlue), // Color del cursor
      borderRadius: BorderRadius.circular(12.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(12.0),
    ),
    prefixIconColor: textLightBlue,
    suffixIconColor: textLightBlue,
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: backgroundColorDarkBlue,
  ),
  iconTheme: const IconThemeData(
    color: textLightBlue,
    size: 24,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: textLightBlue,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,
);
