import 'package:flutter/material.dart';

class SelectFoodsScreen extends StatefulWidget {
  final List<String> selectedDays;
  final int dailyCalories;

  const SelectFoodsScreen({
    super.key,
    required this.selectedDays,
    required this.dailyCalories,
  });

  @override
  State<SelectFoodsScreen> createState() => _SelectFoodsScreenState();
}

class _SelectFoodsScreenState extends State<SelectFoodsScreen> {
  late final PageController _pageController;
  late final List<DayMeals> daysData;
  int selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    daysData = widget.selectedDays
        .map((day) => DayMeals(day: day, meals: []))
        .toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Planificar Comidas',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDaySelector(theme),
          _buildNutritionSummary(theme),
          Expanded(child: _buildMealsList(theme)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMealDialog(context),
        label: const Text('Añadir Comida'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDaySelector(ThemeData theme) {
    return SizedBox(
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => selectedDayIndex = index),
            itemCount: daysData.length,
            itemBuilder: (context, index) {
              final isSelected = selectedDayIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    daysData[index].day,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 7,
            child: Icon(Icons.arrow_back_ios, color: theme.hintColor),
          ),
          Positioned(
            right: 2,
            child: Icon(Icons.arrow_forward_ios, color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary(ThemeData theme) {
    final currentDay = daysData[selectedDayIndex];
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionCard(
            theme,
            'Calorías',
            '${currentDay.getTotalCalories().toStringAsFixed(0)} kcal',
            Icons.local_fire_department,
          ),
          SizedBox(width: 10),
          _buildNutritionCard(
            theme,
            'Proteínas',
            '${currentDay.getTotalProtein().toStringAsFixed(1)} g',
            Icons.fitness_center,
          ),
          SizedBox(width: 10),
          _buildNutritionCard(
            theme,
            'Carbohidratos',
            '${currentDay.getTotalCarbs().toStringAsFixed(1)} g',
            Icons.grain,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(
    ThemeData theme,
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildMealsList(ThemeData theme) {
    final currentDay = daysData[selectedDayIndex];

    if (currentDay.meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay comidas añadidas',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: currentDay.meals.length,
      itemBuilder: (context, index) {
        final meal = currentDay.meals[index];
        return Dismissible(
          key: ValueKey(meal),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.delete,
              color: theme.colorScheme.onError,
            ),
          ),
          onDismissed: (_) {
            setState(() => currentDay.meals.removeAt(index));
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                meal.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    _buildMealNutrient(
                      theme,
                      'Calorías',
                      '${meal.calories.toStringAsFixed(0)} kcal',
                      Icons.local_fire_department,
                    ),
                    const SizedBox(width: 16),
                    _buildMealNutrient(
                      theme,
                      'Proteínas',
                      '${meal.protein.toStringAsFixed(1)} g',
                      Icons.fitness_center,
                    ),
                    const SizedBox(width: 16),
                    _buildMealNutrient(
                      theme,
                      'Carbohidratos',
                      '${meal.carbs.toStringAsFixed(1)} g',
                      Icons.grain,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMealNutrient(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Future<void> _showAddMealDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    String name = '';
    double calories = 0;
    double protein = 0;
    double carbs = 0;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: Text(
          'Añadir Comida',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: inputDecoration.copyWith(
                    labelText: 'Nombre del plato',
                    prefixIcon: const Icon(Icons.restaurant_menu),
                  ),
                  onSaved: (value) => name = value ?? '',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: inputDecoration.copyWith(
                    labelText: 'Calorías (kcal)',
                    prefixIcon: const Icon(Icons.local_fire_department),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) =>
                      calories = double.tryParse(value ?? '') ?? 0,
                  validator: (value) => double.tryParse(value ?? '') == null
                      ? 'Valor inválido'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: inputDecoration.copyWith(
                    labelText: 'Proteínas (g)',
                    prefixIcon: const Icon(Icons.fitness_center),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) =>
                      protein = double.tryParse(value ?? '') ?? 0,
                  validator: (value) => double.tryParse(value ?? '') == null
                      ? 'Valor inválido'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: inputDecoration.copyWith(
                    labelText: 'Carbohidratos (g)',
                    prefixIcon: const Icon(Icons.grain),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) => carbs = double.tryParse(value ?? '') ?? 0,
                  validator: (value) => double.tryParse(value ?? '') == null
                      ? 'Valor inválido'
                      : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
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
            child: const Text('AÑADIR'),
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
  double getTotalCarbs() => meals.fold(0, (sum, meal) => sum + meal.carbs);
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
