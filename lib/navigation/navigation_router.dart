import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter/material.dart';

void navigationRouter(BuildContext context, int index) {
  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WeekScreen(),
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
        builder: (context) => const TemplateScreen(),
      ),
    );
  }
}
