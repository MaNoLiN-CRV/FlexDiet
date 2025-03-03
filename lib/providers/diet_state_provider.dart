import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/client.dart';
import 'package:flutter_flexdiet/models/day.dart';
import 'package:flutter_flexdiet/models/meal.dart';
import 'package:flutter_flexdiet/models/template.dart';
import 'package:flutter_flexdiet/models/user_diet.dart';
import 'package:flutter_flexdiet/services/cache_service.dart';
import 'package:intl/intl.dart';

class DietStateProvider with ChangeNotifier {
  Client? _client;
  UserDiet? _userDiet;
  Template? _template;
  final List<Day> _days = [];
  final List<Meal> _todayMeals = [];
  bool _isLoading = true;
  double _totalCalories = 0;
  double _totalProtein = 0;
  double _totalCarbs = 0;
  bool _isInitialized = false;

  final _cacheService = CacheService();

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

  bool get isInitialized => _isInitialized;

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
      _isInitialized = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Loads meals for today's day in the template, and calculates totals.
  ///
  /// If the day is not found in the template, it clears the list of today's meals.
  ///
  /// If an error occurs when loading the meals, it also clears the list of today's
  /// meals and prints the error to the console.
  ///
  /// It uses the [CacheService] to cache the meals.
  Future<void> _loadTodayMeals() async {
    try {
      final dayName =
          DateFormat('EEEE', 'es_ES').format(DateTime.now()).toLowerCase();
      final matchingDay = _days.firstWhereOrNull(
        (day) => day.name?.toLowerCase() == dayName,
      );

      if (matchingDay?.mealIds == null) {
        _todayMeals.clear();
        _calculateTotals();
        return;
      }

      _todayMeals.clear();
      for (String mealId in matchingDay!.mealIds!) {
        final meal = await _cacheService.getCachedMeal(
          mealId,
          () => Meal.getMeal(mealId),
        );
        if (meal != null) {
          _todayMeals.add(meal);
        }
      }

      _calculateTotals();
    } catch (e) {
      print('Error loading today meals: $e');
      _todayMeals.clear();
      _calculateTotals();
    }
  }

  /// Calculates the total calories, protein, and carbohydrates in the meals for today.
  ///
  /// It does this by folding the list of meals, adding the calories, protein, and carbohydrates
  /// of each meal to the total. If a meal does not have a value for one of the nutrients,
  /// it is ignored.
  void _calculateTotals() {
    _totalCalories =
        _todayMeals.fold(0, (sum, meal) => sum + (meal.calories ?? 0));
    _totalProtein =
        _todayMeals.fold(0, (sum, meal) => sum + (meal.protein ?? 0));
    _totalCarbs = _todayMeals.fold(0, (sum, meal) => sum + (meal.carbs ?? 0));
  }

  /// Saves the meals for a specific date as historic data in Firestore.
  ///
  /// This function stores the IDs of all meals for the given date, along with
  /// the IDs of completed meals and the associated template ID. The data is
  /// saved under the 'historicMeals' collection, organized by client ID and date.
  ///
  /// If the current user is not authenticated, the function will return without
  /// performing any operation.
  ///
  /// The data includes:
  /// - 'date': Timestamp of the given date.
  /// - 'mealIds': List of all meal IDs for the day.
  /// - 'completedMealIds': List of meal IDs that were completed.
  /// - 'templateId': ID of the associated meal template.
  /// - 'updatedAt': Server timestamp indicating the last update.
  ///
  /// If an error occurs during the saving process, it logs the error message
  /// to the console.

  Future<void> saveHistoricMeals(
      DateTime date, List<String> completedMealIds) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Changed path to match the loading path in WeekScreen
      final historicRef = FirebaseFirestore.instance
          .collection('historicMeals')
          .doc(_client!.id)
          .collection('dates')
          .doc(DateFormat('yyyy-MM-dd').format(date));

      // Add all necessary data
      await historicRef.set({
        'date': Timestamp.fromDate(date),
        'mealIds': _todayMeals
            .map((meal) => meal.id)
            .toList(), // All meals for the day
        'completedMealIds': completedMealIds, // Only completed meals
        'templateId': _template?.id,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('Historic meals saved successfully for date: ${date.toString()}');
    } catch (e) {
      print('Error saving historic meals: $e');
    }
  }
}
