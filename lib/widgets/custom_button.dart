import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  DateTime _firstDate = DateTime.now()
      .subtract(const Duration(days: 365)); // One year ago from today
  DateTime _lastDate = DateTime.now()
      .add(const Duration(days: 365)); // One year ahead from today

  // Sample meal data (replace with your actual data source)
  final Map<DateTime, List<Meal>> _mealData = {
    DateTime(2024, 1, 15): [
      Meal(name: 'Breakfast', description: 'Oatmeal with berries'),
      Meal(name: 'Lunch', description: 'Chicken salad sandwich'),
    ],
    DateTime(2024, 1, 20): [
      Meal(name: 'Dinner', description: 'Salmon with roasted vegetables'),
    ],
    DateTime(2024, 1, 25): [
      Meal(name: 'Breakfast', description: 'Scrambled eggs with toast'),
    ],
    DateTime(2024, 2, 5): [
      Meal(name: 'Lunch', description: 'Lentil soup with bread'),
    ],
    DateTime(2024, 2, 10): [
      Meal(name: 'Dinner', description: 'Steak with mashed potatoes'),
    ],
  };

  @override
  void initState() {
    super.initState();
    // Adjust the firstDate and lastDate based on the selectedDate (now)
    _firstDate = _selectedDate.subtract(const Duration(days: 365));
    _lastDate = _selectedDate.add(const Duration(days: 365));
    Intl.defaultLocale = 'es'; // Set the default locale to Spanish
  }

  @override
  Widget build(BuildContext context) {
    final mealsForSelectedDate = _mealData[_selectedDate] ?? [];

    return MaterialApp(
      // Wrap the Scaffold with MaterialApp
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Spanish, Spain
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Meal Calendar'),
        ),
        body: Column(
          children: [
            CalendarTimeline(
              initialDate: _selectedDate,
              firstDate: _firstDate,
              lastDate: _lastDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
              leftMargin: 20,
              monthColor: Colors.blueGrey,
              dayColor: Colors.blueGrey,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent,
              locale: 'es', // Set the locale for the calendar timeline
              selectableDayPredicate: (date) =>
                  true, // Allow all dates to be selected
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
                        return Card(
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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
