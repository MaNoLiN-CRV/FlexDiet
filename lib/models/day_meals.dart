import 'package:flutter_flexdiet/models/models.dart';

class DayMeals {
  final String day;
  final List<Meal> meals;

  DayMeals({required this.day, required this.meals});

  double getTotalCalories() =>
      meals.fold(0, (sum, meal) => sum + (meal.calories ?? 0));

  double getTotalProtein() =>
      meals.fold(0, (sum, meal) => sum + (meal.protein ?? 0));
  double getTotalCarbs() =>
      meals.fold(0, (sum, meal) => sum + (meal.carbs ?? 0));
}
