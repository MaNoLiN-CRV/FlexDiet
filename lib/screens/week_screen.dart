import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/meal.dart';
import 'package:flutter_flexdiet/providers/diet_state_provider.dart';
import 'package:flutter_flexdiet/services/cache_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Meal> _todayMeals = [];
  final _cacheService = CacheService();

  // Add date range limits
  late final DateTime _minDate;
  late final DateTime _maxDate;

  @override
  void initState() {
    super.initState();
    // Set date range to today + 2 weeks
    _minDate = DateTime.now();
    _maxDate = _minDate.add(const Duration(days: 14));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DietStateProvider>().initializeData().then((_) {
        _loadMealsForDate(_selectedDate, context.read<DietStateProvider>());
      });
    });
  }

  Future<void> _onDateChanged(
      DateTime newDate, DietStateProvider dietState) async {
    setState(() => _selectedDate = newDate);
    await _loadMealsForDate(newDate, dietState);
  }

  Future<void> _loadMealsForDate(
      DateTime date, DietStateProvider dietState) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      final meals = await _cacheService.getCachedMealsForDate(
        dateStr,
        () => _fetchMealsForDate(date, dietState),
      );

      if (mounted) {
        setState(() => _todayMeals = meals);
      }
    } catch (e) {
      print('Error loading meals for date: $e');
      if (mounted) {
        setState(() => _todayMeals = []);
      }
    }
  }

  Future<List<Meal>> _fetchMealsForDate(
      DateTime date, DietStateProvider dietState) async {
    // Si la fecha es anterior a hoy o después de 2 semanas, retornar vacío
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      return [];
    }

    // Si la fecha es anterior a hoy, cargar desde el historial
    if (date.isBefore(DateTime.now())) {
      return _loadHistoricMeals(date, dietState.client!.id);
    }

    // Si la fecha es hoy o futura, usar el template actual
    final dayName = DateFormat('EEEE', 'es_ES').format(date).toLowerCase();
    final matchingDay = dietState.days.firstWhereOrNull(
      (day) => day.name?.toLowerCase() == dayName,
    );

    if (matchingDay?.mealIds == null) return [];

    return Future.wait(
      matchingDay!.mealIds!.map((mealId) async {
        return await _cacheService.getCachedMeal(
              mealId,
              () => Meal.getMeal(mealId),
            ) ??
            Meal(id: mealId);
      }),
    );
  }

  Future<List<Meal>> _loadHistoricMeals(DateTime date, String clientId) async {
    try {
      final historicMealsRef = FirebaseFirestore.instance
          .collection('historicMeals')
          .doc(clientId)
          .collection('dates')
          .doc(DateFormat('yyyy-MM-dd').format(date));

      final snapshot = await historicMealsRef.get();
      if (!snapshot.exists) return [];

      final data = snapshot.data() as Map<String, dynamic>;
      final mealIds = List<String>.from(data['mealIds'] ?? []);

      return await Future.wait(mealIds.map((mealId) => Meal.getMeal(mealId)));
    } catch (e) {
      print('Error loading historic meals: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DietStateProvider>(
      builder: (context, dietState, _) {
        if (!dietState.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = Theme.of(context);
        final formatter = DateFormat('EEEE, d MMMM yyyy', 'es_ES');
        final formattedDate = formatter.format(_selectedDate);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Calendario de Comidas'),
            backgroundColor: theme.colorScheme.primary,
          ),
          bottomNavigationBar: BottomNav(
            selectedIndex: 0,
            onItemTapped: (index) => navigationRouter(context, index),
          ),
          body: Column(
            children: [
              // Date Selector
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: _selectedDate.isBefore(_minDate)
                          ? null
                          : () => _onDateChanged(
                              _selectedDate.subtract(const Duration(days: 1)),
                              dietState),
                    ),
                    Text(
                      formattedDate,
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: _selectedDate.isAfter(_maxDate)
                          ? null
                          : () => _onDateChanged(
                              _selectedDate.add(const Duration(days: 1)),
                              dietState),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _todayMeals.isEmpty
                    ? const Center(
                        child: Text('No hay comidas asociadas a esta fecha'),
                      )
                    : ListView.builder(
                        itemCount: _todayMeals.length,
                        itemBuilder: (context, index) {
                          final meal = _todayMeals[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    title: meal.name ?? 'Comida',
                                    subtitle: 'Comida del día',
                                    description: meal.description ?? '',
                                    image: meal.image ?? '',
                                    carbs: '${meal.carbs?.toString() ?? "0"}g',
                                    kcal:
                                        '${meal.calories?.toString() ?? "0"} kcal',
                                    proteins:
                                        '${meal.protein?.toString() ?? "0"}g',
                                    ingredients: meal.ingredients ?? '',
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: ListTile(
                                title: Text(
                                  meal.name ?? 'Comida',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (meal.timeOfDay != null)
                                      Text(
                                        meal.timeOfDay!,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    Text(meal.description ?? ''),
                                  ],
                                ),
                                trailing: Text(
                                  '${meal.calories?.toString() ?? "0"} kcal',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
