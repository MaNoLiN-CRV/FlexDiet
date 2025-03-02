import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_flexdiet/models/final_models/day.dart';
import 'package:flutter_flexdiet/models/final_models/meal.dart';
import 'package:flutter_flexdiet/models/final_models/template.dart';
import 'package:flutter_flexdiet/models/final_models/user_diet.dart';
import 'package:intl/intl.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:collection/collection.dart';

class WeekScreen extends StatefulWidget {
  final Map<DateTime, List<Meal>> mealData;

  const WeekScreen({required this.mealData, super.key});

  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  DateTime _selectedDate = DateTime.now();
  Client? _client;
  UserDiet? _userDiet;
  Template? _template;
  List<Day> _days = [];
  List<Meal> _todayMeals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 1. Obtener datos del cliente
        _client = await Client.getClient(user.uid);

        if (_client?.userDietId != null) {
          // 2. Obtener UserDiet actual
          _userDiet = await UserDiet.getUserDiet(_client!.userDietId!);

          // 3. Obtener Template
          _template = await Template.getTemplate(_userDiet!.templateId);

          // 4. Cargar comidas según la fecha seleccionada
          await _loadMealsForDate(_selectedDate);
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading diet data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadMealsForDate(DateTime date) async {
    try {
      // Si la fecha es anterior a hoy, cargar desde el historial
      if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        final historicMeals = await _loadHistoricMeals(date);
        if (mounted) {
          setState(() => _todayMeals = historicMeals);
        }
        return;
      }

      // Si la fecha es hoy o futura, usar el template actual
      final dayName = DateFormat('EEEE', 'es_ES').format(date).toLowerCase();

      // Cargar días del template actual si no están cargados
      if (_days.isEmpty && _template != null) {
        for (String dayId in _template!.dayIds) {
          final day = await Day.getDay(dayId);
          _days.add(day);
        }
      }

      // Encontrar el día correspondiente en el template
      final matchingDay = _days.firstWhereOrNull(
        (day) => day.name?.toLowerCase() == dayName,
      );

      if (matchingDay != null && matchingDay.mealIds != null) {
        final meals = await Future.wait(
            matchingDay.mealIds!.map((mealId) => Meal.getMeal(mealId)));
        if (mounted) {
          setState(() => _todayMeals = meals);
        }
      } else {
        if (mounted) {
          setState(() => _todayMeals = []);
        }
      }
    } catch (e) {
      print('Error loading meals for date: $e');
      if (mounted) {
        setState(() => _todayMeals = []);
      }
    }
  }

  Future<List<Meal>> _loadHistoricMeals(DateTime date) async {
    try {
      final historicMealsRef = FirebaseFirestore.instance
          .collection('historicMeals')
          .doc(_client!.id)
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

  Future<void> _onDateChanged(DateTime newDate) async {
    setState(() {
      _selectedDate = newDate;
      _isLoading = true;
    });
    await _loadMealsForDate(newDate);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateFormat formatter = DateFormat('EEEE, d MMMM yyyy', 'es_ES');
    final String formattedDate = formatter.format(_selectedDate);

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
                  onPressed: () => _onDateChanged(
                      _selectedDate.subtract(const Duration(days: 1))),
                ),
                Text(
                  formattedDate,
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => _onDateChanged(
                      _selectedDate.add(const Duration(days: 1))),
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
                                image: meal.image,
                                carbs: '${meal.carbs?.toString() ?? "0"}g',
                                kcal:
                                    '${meal.calories?.toString() ?? "0"} kcal',
                                proteins: '${meal.protein?.toString() ?? "0"}g',
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
                            subtitle: Text(meal.description ?? ''),
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
  }
}
