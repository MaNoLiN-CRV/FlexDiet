import 'package:flutter/material.dart';

const Color backgroundColorWhite = Color(0xFFE3EDF7);
const Color backgroundColorBlue = Color(0xFF4530B3);
const Color containersBlue = Color(0xFF5451D6);
const Color textBlue = Color(0xFF30436E);
const Color buttonTextWhite = Color(0xFFD1D9E6);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: backgroundColorBlue).copyWith(
    surface: backgroundColorWhite,
    primary: backgroundColorBlue,
    secondary: containersBlue,
    error: Colors.red,
    onPrimary: buttonTextWhite,
    onSecondary: buttonTextWhite,
    onSurface: textBlue,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: backgroundColorWhite,
  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundColorBlue,
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
  textTheme: const TextTheme(
    displayLarge:
        TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: textBlue),
    displayMedium:
        TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold, color: textBlue),
    displaySmall:
        TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: textBlue),
    headlineLarge:
        TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: textBlue),
    headlineMedium:
        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: textBlue),
    headlineSmall:
        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textBlue),
    titleLarge:
        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: textBlue),
    titleMedium:
        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textBlue),
    titleSmall:
        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textBlue),
    bodyLarge:
        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textBlue),
    bodyMedium:
        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: textBlue),
    bodySmall:
        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: textBlue),
    labelLarge:
        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: textBlue),
    labelMedium:
        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: textBlue),
    labelSmall:
        TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: textBlue),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: textBlue,
      foregroundColor: buttonTextWhite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 3,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: buttonTextWhite,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: containersBlue,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      side: const BorderSide(color: containersBlue),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: backgroundColorWhite,
    hintStyle: TextStyle(color: textBlue.withAlpha(128)),
    labelStyle: const TextStyle(color: textBlue, fontWeight: FontWeight.bold),
    floatingLabelStyle: const TextStyle(color: textBlue),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: textBlue.withAlpha(76)),
      borderRadius: BorderRadius.circular(12.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: textBlue.withAlpha(76)),
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: textBlue),
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
    prefixIconColor: textBlue,
    suffixIconColor: textBlue,
  ),
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: buttonTextWhite,
  ),
  iconTheme: const IconThemeData(
    color: textBlue,
    size: 24,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: textBlue,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
);
