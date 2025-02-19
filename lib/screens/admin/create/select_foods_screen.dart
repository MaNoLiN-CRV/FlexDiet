import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/widgets/custom_card_scroll.dart';

class SelectFoodsScreen extends StatefulWidget {
  final List<String> selectedDays;
  final int daylyCalories;
  const SelectFoodsScreen({
    super.key,
    required this.selectedDays,
    required this.daylyCalories,
  });

  @override
  State<SelectFoodsScreen> createState() => _SelectFoodsScreenState();
}

class _SelectFoodsScreenState extends State<SelectFoodsScreen> {
  late final List<DayMeals> daysData;
  int selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    daysData = widget.selectedDays
        .map((day) => DayMeals(day: day, meals: []))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificar Comidas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 180,
            child: CardScroll(
              cards: daysData
                  .map((dayData) => CardData(
                        title: dayData.day,
                        description:
                            '${dayData.getTotalCalories()} kcal\n${dayData.getTotalProtein()}g proteína',
                        imageUrl: 'assets/images/day_background.jpg',
                      ))
                  .toList(),
              onCardTap: (index) {
                setState(() => selectedDayIndex = index);
              },
            ),
          ),
          Expanded(
            child: _buildMealsList(theme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMealsList(ThemeData theme) {
    final currentDay = daysData[selectedDayIndex];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: currentDay.meals.length,
      itemBuilder: (context, index) {
        final meal = currentDay.meals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(meal.name),
            subtitle: Text(
              'Calorías: ${meal.calories} kcal\n'
              'Proteínas: ${meal.protein}g • Carbohidratos: ${meal.carbs}g',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                setState(() {
                  currentDay.meals.removeAt(index);
                });
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddMealDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String name = '';
    double calories = 0;
    double protein = 0;
    double carbs = 0;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Añadir Comida'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nombre del plato'),
                onSaved: (value) => name = value ?? '',
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Calorías (kcal)'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    calories = double.tryParse(value ?? '') ?? 0,
                validator: (value) => double.tryParse(value ?? '') == null
                    ? 'Valor inválido'
                    : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Proteínas (g)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => protein = double.tryParse(value ?? '') ?? 0,
                validator: (value) => double.tryParse(value ?? '') == null
                    ? 'Valor inválido'
                    : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Carbohidratos (g)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => carbs = double.tryParse(value ?? '') ?? 0,
                validator: (value) => double.tryParse(value ?? '') == null
                    ? 'Valor inválido'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                setState(() {
                  daysData[selectedDayIndex].meals.add(
                        Meal(
                          name: name,
                          calories: calories,
                          protein: protein,
                          carbs: carbs,
                        ),
                      );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Añadir'),
          ),
        ],
      ),
    );
  }
}

class DayMeals {
  final String day;
  final List<Meal> meals;

  DayMeals({required this.day, required this.meals});

  double getTotalCalories() =>
      meals.fold(0, (sum, meal) => sum + meal.calories);

  double getTotalProtein() => meals.fold(0, (sum, meal) => sum + meal.protein);
}

class Meal {
  final String name;
  final double calories;
  final double protein;
  final double carbs;

  Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
  });
}
