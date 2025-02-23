import 'package:flutter_flexdiet/models/meal.dart';
import 'package:flutter_flexdiet/models/models.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter/material.dart';

void navigationRouter(BuildContext context, int index) {
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
  final List<Client> clients = [
    Client(
      name: 'Snoop Dogg',
      description:
          'Cliente con rutina de ganar peso, entrena dos dias a la semana.',
      imageUrl:
          'https://allhiphop.com/wp-content/uploads/2022/11/Snoop-Dogg.jpg',
    ),
    Client(
      name: 'Eminem',
      description: 'Atleta, y fisicoculturista',
      imageUrl: 'https://cdn.britannica.com/63/136263-050-7FBFFBD1/Eminem.jpg',
    ),
    Client(
      name: 'Ice Cube',
      description: 'Rutina para perder peso',
      imageUrl:
          'https://heavy.com/wp-content/uploads/2017/02/gettyimages-615695594.jpg?quality=65&strip=all',
    ),
    Client(
      name: 'Juice WRLD',
      description: 'Rutina de ciclismo',
      imageUrl:
          'https://www.thefamouspeople.com/profiles/images/juice-wrld-1.jpg',
    ),
  ];
  if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WeekScreen(mealData: _mealData,),
      ),
    );
  } else if (index == 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
        maintainState: true,
      ),
    );
  } else if (index == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  } else if (index == 3) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminScreen( clients: clients,),
      ),
    );
  }
}
