import 'package:flutter_flexdiet/models/models.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter/material.dart';

void navigationRouter(BuildContext context, int index) {
  final Map<DateTime, List<Meal>> _mealData = {
    DateTime(2025, 2, 18): [
      Meal(
          name: 'Desayuno',
          description: 'Cereales con leche de almendras',
          calories: 2,
          protein: 2,
          carbs: 2),
      Meal(
          name: 'Almuerzo',
          description: 'Crema de calabaza',
          calories: 2,
          protein: 2,
          carbs: 2),
      Meal(
          name: 'Cena',
          description: 'Ensalada de garbanzos',
          calories: 2,
          protein: 2,
          carbs: 2),
    ],
    DateTime(2025, 2, 19): [
      Meal(
          name: 'Desayuno',
          description: 'Tortilla con espinacas',
          calories: 2,
          protein: 2,
          carbs: 2),
      Meal(
          name: 'Almuerzo',
          description: 'Pasta con tomate y atún',
          calories: 2,
          protein: 2,
          carbs: 2),
      Meal(
          name: 'Cena',
          description: 'Pizza con verduras',
          calories: 2,
          protein: 2,
          carbs: 2),
    ],
  };
  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WeekScreen(
          mealData: _mealData,
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
        builder: (context) => AdminScreen(),
      ),
    );
  }
}
