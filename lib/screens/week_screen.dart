import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/Meal.dart';
import 'package:intl/intl.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/screens/screens.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  DateTime _selectedDate = DateTime.now();

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

  @override
  void initState() {
    super.initState();
    // Initialize _selectedDate with the current date
    _selectedDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateFormat formatter = DateFormat('EEEE, d MMMM yyyy', 'es_ES');
    final String formattedDate = formatter.format(_selectedDate);

    final mealsForSelectedDate = _mealData[_selectedDate] ?? [];

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
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        setState(() {
                          _selectedDate =
                              _selectedDate.subtract(const Duration(days: 1));
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  formattedDate,
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        setState(() {
                          _selectedDate =
                              _selectedDate.add(const Duration(days: 1));
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: mealsForSelectedDate.isEmpty
                ? const Center(
                    child: Center(
                        child: Text('No hay comidas asociadas a esta fecha')),
                  )
                : ListView.builder(
                    itemCount: mealsForSelectedDate.length,
                    itemBuilder: (context, index) {
                      final meal = mealsForSelectedDate[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                title: meal.name,
                                subtitle: 'Comida del día',
                                description: meal.description,
                                image:
                                    'https://s2.abcstatics.com/abc/sevilla/media/gurmesevilla/2012/01/comida-rapida-casera.jpg',
                                carbs: '40g',
                                kcal: '350 kcal',
                                proteins: '20g',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(meal.description),
                              ],
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
