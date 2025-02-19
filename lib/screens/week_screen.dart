import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';

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
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime.now();

  final Map<DateTime, List<Meal>> _mealData = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _firstDate = _selectedDate.subtract(const Duration(days: 365));
    _lastDate = _selectedDate.add(const Duration(days: 365));
  }

  @override
  Widget build(BuildContext context) {
    final mealsForSelectedDate = _mealData[_selectedDate] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Comidas'),
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: 0,
        onItemTapped: (index) => navigationRouter(context, index),
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
            locale: 'es',
            selectableDayPredicate: (date) => true,
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
    );
  }
}
