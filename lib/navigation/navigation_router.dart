import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/screens.dart';

void navigationRouter(BuildContext context, int index) async {
  if (index == 0) {
    // Week Screen with empty initial data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WeekScreen(
          mealData: {}, // Empty initial data, will be loaded in the screen
        ),
      ),
    );
  } else if (index == 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
        maintainState: true,
      ),
    );
  } else if (index == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  } else if (index == 3) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminScreen(),
      ),
    );
  }
}
