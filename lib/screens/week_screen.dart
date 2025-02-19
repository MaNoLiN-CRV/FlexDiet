import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/screens/screens.dart';

class Meal {
  final String name;
  final String description;

  Meal({required this.name, required this.description});
}

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  _WeekScreenState createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  DateTime _selectedDate = DateTime.now();

  final Map<DateTime, List<Meal>> _mealData = {
    DateTime(2025, 2, 18): [
      Meal(name: 'Desayuno', description: 'Cereales con leche de almendras'),
      Meal(name: 'Almuerzo', description: 'Crema de calabaza'),
      Meal(name: 'Cena', description: 'Ensalada de garbanzos'),
    ],
    DateTime(2025, 2, 19): [
      Meal(name: 'Desayuno', description: 'Tortilla con espinacas'),
      Meal(name: 'Almuerzo', description: 'Pasta con tomate y atún'),
      Meal(name: 'Cena', description: 'Pizza con verduras'),
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
    final DateFormat formatter =
        DateFormat('EEEE, d MMMM yyyy', 'es_ES'); // Added yyyy for the year
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
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate =
                          _selectedDate.subtract(const Duration(days: 1));
                    });
                  },
                ),
                Text(
                  formattedDate,
                  style: theme.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate =
                          _selectedDate.add(const Duration(days: 1));
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: mealsForSelectedDate.isEmpty
                ? const Center(
                    child: Text('No hay comidas asociadas a esta fecha'),
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
                                  macros:
                                      'Información nutricional detallada: \n\n- Calorías: 350 kcal \n- Proteínas: 20g \nCarbohidratos: 40g \nGrasas: 15g \n\nRecuerda que estos valores son aproximados y pueden variar según los ingredientes y las porciones.'),
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
