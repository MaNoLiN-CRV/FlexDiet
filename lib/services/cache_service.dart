import 'package:flutter_flexdiet/models/final_models/meal.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  final Map<String, _CachedData<List<Meal>>> _dateCache = {};
  final Map<String, _CachedData<Meal>> _mealCache = {};

  Future<List<Meal>> getCachedMealsForDate(
      String dateStr, Future<List<Meal>> Function() fetchData) async {
    final cached = _dateCache[dateStr];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final meals = await fetchData();
    _dateCache[dateStr] = _CachedData(meals);
    return meals;
  }

  Future<Meal?> getCachedMeal(
      String mealId, Future<Meal> Function() fetchData) async {
    final cached = _mealCache[mealId];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final meal = await fetchData();
    _mealCache[mealId] = _CachedData(meal);
    return meal;
  }

  void clearCache() {
    _dateCache.clear();
    _mealCache.clear();
  }

  void cleanExpiredCache() {
    _dateCache.removeWhere((_, cached) => cached.isExpired);
    _mealCache.removeWhere((_, cached) => cached.isExpired);
  }
}

class _CachedData<T> {
  final T data;
  final DateTime timestamp;
  static const Duration _cacheDuration = Duration(minutes: 30);

  _CachedData(this.data) : timestamp = DateTime.now();

  bool get isExpired => DateTime.now().difference(timestamp) > _cacheDuration;
}
