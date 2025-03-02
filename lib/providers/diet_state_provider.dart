import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_flexdiet/models/final_models/day.dart';
import 'package:flutter_flexdiet/models/final_models/meal.dart';
import 'package:flutter_flexdiet/models/final_models/template.dart';
import 'package:flutter_flexdiet/models/final_models/user_diet.dart';
import 'package:intl/intl.dart';

class DietStateProvider with ChangeNotifier {
  Client? _client;
  UserDiet? _userDiet;
  Template? _template;
  List<Day> _days = [];
  List<Meal> _todayMeals = [];
  bool _isLoading = true;
  double _totalCalories = 0;
  double _totalProtein = 0;
  double _totalCarbs = 0;
  bool _isInitialized = false;

  // Getters
  Client? get client => _client;
  UserDiet? get userDiet => _userDiet;
  Template? get template => _template;
  List<Day> get days => _days;
  List<Meal> get todayMeals => _todayMeals;
  bool get isLoading => _isLoading;
  double get totalCalories => _totalCalories;
  double get totalProtein => _totalProtein;
  double get totalCarbs => _totalCarbs;

  Future<void> initializeData() async {
    if (_isInitialized) return;

    try {
      _isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _client = await Client.getClient(user.uid);
        if (_client?.userDietId != null) {
          _userDiet = await UserDiet.getUserDiet(_client!.userDietId!);
          _template = await Template.getTemplate(_userDiet!.templateId);

          _days.clear();
          for (String dayId in _template!.dayIds) {
            final day = await Day.getDay(dayId);
            _days.add(day);
          }

          await _loadTodayMeals();
        }
      }

      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _loadTodayMeals() async {
    final dayName =
        DateFormat('EEEE', 'es_ES').format(DateTime.now()).toLowerCase();
    final todayDay = _days.firstWhere(
      (day) => day.name?.toLowerCase() == dayName,
      orElse: () => _days.first,
    );

    if (todayDay.mealIds != null) {
      _todayMeals.clear();
      for (String mealId in todayDay.mealIds!) {
        final meal = await Meal.getMeal(mealId);
        _todayMeals.add(meal);
      }
      _calculateTotals();
    }
  }

  void _calculateTotals() {
    _totalCalories =
        _todayMeals.fold(0, (sum, meal) => sum + (meal.calories ?? 0));
    _totalProtein =
        _todayMeals.fold(0, (sum, meal) => sum + (meal.protein ?? 0));
    _totalCarbs = _todayMeals.fold(0, (sum, meal) => sum + (meal.carbs ?? 0));
  }

  Future<void> saveHistoricMeals(
      DateTime date, List<String> completedMealIds) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final historicRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('historic_meals')
        .doc(DateFormat('yyyy-MM-dd').format(date));

    await historicRef.set({
      'date': date,
      'completedMealIds': completedMealIds,
    });
  }
}
