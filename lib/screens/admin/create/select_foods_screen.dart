import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_flexdiet/models/final_models/meal.dart';
import 'package:flutter_flexdiet/models/final_models/day.dart';
import 'package:flutter_flexdiet/models/day_meals.dart';
import 'package:flutter_flexdiet/models/final_models/template.dart';
import 'package:flutter_flexdiet/models/final_models/user_diet.dart';
import 'package:flutter_flexdiet/services/image_service/image_service.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class SelectFoodsScreen extends StatefulWidget {
  final List<String> selectedDays;
  final int dailyCalories;
  final Client client;

  const SelectFoodsScreen({
    super.key,
    required this.selectedDays,
    required this.dailyCalories,
    required this.client,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Planificar Comidas',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildDaySelector(theme, isDarkMode),
          _buildNutritionSummary(theme, isDarkMode),
          Expanded(child: _buildMealsList(theme, isDarkMode)),
          _buildFinishButton(theme, isDarkMode),
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 65),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddMealDialog(context, isDarkMode),
          label: const Text('Añadir Comida'),
          icon: const Icon(Icons.add),
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildFinishButton(ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveTemplate,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'FINALIZAR',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector(ThemeData theme, bool isDarkMode) {
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

              final containerColor = isSelected
                  ? theme.colorScheme.primary
                  : isDarkMode
                      ? theme.colorScheme.surfaceContainer
                          .withValues(alpha: 0.8)
                      : theme.colorScheme.surfaceContainerHighest;
              final textColor = isSelected
                  ? theme.colorScheme.onPrimary
                  : isDarkMode
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: containerColor,
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
                      color: textColor,
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

  Widget _buildNutritionSummary(ThemeData theme, bool isDarkMode) {
    final currentDay = daysData[selectedDayIndex];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
              isDarkMode),
          SizedBox(width: 10),
          _buildNutritionCard(
              theme,
              'Proteínas',
              '${currentDay.getTotalProtein().toStringAsFixed(1)} g',
              Icons.fitness_center,
              isDarkMode),
          SizedBox(width: 10),
          _buildNutritionCard(
              theme,
              'Carbohidratos',
              '${currentDay.getTotalCarbs().toStringAsFixed(1)} g',
              Icons.grain,
              isDarkMode),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(ThemeData theme, String title, String value,
      IconData icon, bool isDarkMode) {
    final textColor =
        isDarkMode ? Colors.white : theme.colorScheme.onPrimaryContainer;
    final captionColor = isDarkMode
        ? Colors.white70
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    final noMealsTextColor =
        isDarkMode ? Colors.white70 : theme.colorScheme.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: noMealsTextColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: textColor),
        ),
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(color: captionColor),
        ),
      ],
    );
  }

  Widget _buildMealsList(ThemeData theme, bool isDarkMode) {
    final currentDay = daysData[selectedDayIndex];
    final noMealsTextColor =
        isDarkMode ? Colors.white70 : theme.colorScheme.outline;

    if (currentDay.meals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: noMealsTextColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay comidas añadidas',
              style: theme.textTheme.titleMedium?.copyWith(
                color: noMealsTextColor,
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
                meal.name ?? 'Unnamed Meal',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : null),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    _buildMealNutrient(
                        theme,
                        'Calorías',
                        '${meal.calories?.toStringAsFixed(0)} kcal',
                        Icons.local_fire_department,
                        isDarkMode),
                    const SizedBox(width: 16),
                    _buildMealNutrient(
                        theme,
                        'Proteínas',
                        '${meal.protein?.toStringAsFixed(1)} g',
                        Icons.fitness_center,
                        isDarkMode),
                    const SizedBox(width: 16),
                    _buildMealNutrient(
                        theme,
                        'Carbohidratos',
                        '${meal.carbs?.toStringAsFixed(1)} g',
                        Icons.grain,
                        isDarkMode),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMealNutrient(ThemeData theme, String label, String value,
      IconData icon, bool isDarkMode) {
    final onSurfaceVariantColor =
        isDarkMode ? Colors.white70 : theme.colorScheme.onSurfaceVariant;
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
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: onSurfaceVariantColor),
        ),
      ],
    );
  }

  Future<void> _showAddMealDialog(BuildContext context, bool isDarkMode) async {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    final ImagePickerService imagePickerService = ImagePickerService();

    String uid = UniqueKey().toString();
    String name = '';
    String description = '';
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    String timeOfDay = '';

    String? currentImage;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: theme.colorScheme.surfaceTint,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text(
            'Añadir Comida',
            style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : null),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: TextStyle(color: isDarkMode ? Colors.white : null),
                    decoration: InputDecoration(
                      hintText: 'Nombre del plato',
                      prefixIcon: const Icon(Icons.restaurant_menu),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      labelStyle:
                          TextStyle(color: isDarkMode ? Colors.white70 : null),
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey.shade500 : null),
                      prefixIconColor: isDarkMode ? Colors.white70 : null,
                    ),
                    onSaved: (value) => name = value ?? '',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: isDarkMode ? Colors.white : null),
                    decoration: InputDecoration(
                      hintText: 'Descripción',
                      prefixIcon: const Icon(Icons.description),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      labelStyle:
                          TextStyle(color: isDarkMode ? Colors.white70 : null),
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey.shade500 : null),
                      prefixIconColor: isDarkMode ? Colors.white70 : null,
                    ),
                    onSaved: (value) => description = value ?? '',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: isDarkMode ? Colors.white : null),
                    decoration: InputDecoration(
                      hintText: 'Calorías (kcal)',
                      prefixIcon: const Icon(Icons.local_fire_department),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      labelStyle:
                          TextStyle(color: isDarkMode ? Colors.white70 : null),
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey.shade500 : null),
                      prefixIconColor: isDarkMode ? Colors.white70 : null,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => calories =
                        double.tryParse(value ?? '0') ?? 0, // Default to 0
                    validator: (value) => double.tryParse(value ?? '') == null
                        ? 'Valor inválido'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: isDarkMode ? Colors.white : null),
                    decoration: InputDecoration(
                      hintText: 'Proteínas (g)',
                      prefixIcon: const Icon(Icons.fitness_center),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      labelStyle:
                          TextStyle(color: isDarkMode ? Colors.white70 : null),
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey.shade500 : null),
                      prefixIconColor: isDarkMode ? Colors.white70 : null,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => protein =
                        double.tryParse(value ?? '0') ?? 0, // Default to 0
                    validator: (value) => double.tryParse(value ?? '') == null
                        ? 'Valor inválido'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: isDarkMode ? Colors.white : null),
                    decoration: InputDecoration(
                      hintText: 'Carbohidratos (g)',
                      prefixIcon: const Icon(Icons.grain),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      labelStyle:
                          TextStyle(color: isDarkMode ? Colors.white70 : null),
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey.shade500 : null),
                      prefixIconColor: isDarkMode ? Colors.white70 : null,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) => carbs =
                        double.tryParse(value ?? '0') ?? 0, // Default to 0
                    validator: (value) => double.tryParse(value ?? '') == null
                        ? 'Valor inválido'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(color: isDarkMode ? Colors.white : null),
                    decoration: InputDecoration(
                      hintText:
                          'Momento del día (Desayuno, Snack, Almuerzo...)',
                      prefixIcon: const Icon(Icons.restaurant_menu),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade600
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      labelStyle:
                          TextStyle(color: isDarkMode ? Colors.white70 : null),
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey.shade500 : null),
                      prefixIconColor: isDarkMode ? Colors.white70 : null,
                    ),
                    onSaved: (value) => timeOfDay = value ?? '',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                        final newImage = await imagePickerService.selectImage(
                            context: context,
                            source: ImageSource.gallery,
                            uidMeal: uid,
                            collection: 'meals');

                        if (newImage != null) {
                          setDialogState(() {
                            currentImage = newImage;
                          });
                        }
                      },
                      child: const Text('Imagen comida')),
                  const SizedBox(height: 16),
                  if (currentImage != null)
                    Container(
                      key: ValueKey(currentImage),
                      height: 200, // Add fixed height
                      width: double.infinity,
                      child: Image(
                        image: NetworkImage(currentImage!),
                        fit: BoxFit.cover, // Add fit property
                        errorBuilder: (context, error, stackTrace) {
                          print("Error cargando imagen: $error");
                          return const Center(
                              child: Text('Error al cargar la imagen'));
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  setState(() {
                    daysData[selectedDayIndex].meals.add(
                          Meal(
                              id: uid, // Temporary ID for template
                              name: name,
                              description: description,
                              calories: calories,
                              protein: protein,
                              carbs: carbs,
                              image: currentImage, // Use currentImage here
                              timeOfDay: timeOfDay),
                        );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('AÑADIR'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, String>?> _showTemplateDetailsDialog(
      BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String templateName = '';
    String templateDescription = '';
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        title: Text(
          'Detalles de la Plantilla',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : null,
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: TextStyle(color: isDarkMode ? Colors.white : null),
                decoration: InputDecoration(
                  labelText: 'Nombre de la plantilla',
                  hintText: 'Ej: Dieta Volumen',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
                onSaved: (value) => templateName = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: isDarkMode ? Colors.white : null),
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Ej: Plan de alimentación para ganar masa muscular',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo requerido' : null,
                onSaved: (value) => templateDescription = value ?? '',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCELAR',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                formKey.currentState?.save();
                Navigator.pop(context, {
                  'name': templateName,
                  'description': templateDescription,
                });
              }
            },
            child: const Text('CONTINUAR'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveTemplate() async {
    // First ask for template details
    final templateDetails = await _showTemplateDetailsDialog(context);
    if (templateDetails == null) return; // User cancelled

    try {
      // 1. First, save all meals to Firestore
      final List<String> mealIds = [];
      for (var dayMeal in daysData) {
        for (var meal in dayMeal.meals) {
          print('Saving meal: ${meal.name}');
          print('Calories: ${meal.calories}');
          print('Protein: ${meal.protein}');
          print('Carbs: ${meal.carbs}');

          final mealToSave = Meal(
            id: meal.id,
            name: meal.name,
            description: meal.description,
            calories: meal.calories?.toDouble() ?? 0,
            protein: meal.protein?.toDouble() ?? 0,
            carbs: meal.carbs?.toDouble() ?? 0,
            image: meal.image,
            timeOfDay: meal.timeOfDay,
          );

          bool isMealCreated = await Meal.createMeal(mealToSave);
          if (isMealCreated) {
            mealIds.add(meal.id);
          }
        }
      }

      // 2. Create days and store their IDs
      final List<String> dayIds = [];
      for (var i = 0; i < daysData.length; i++) {
        final day = Day(
          id: UniqueKey().toString(),
          name: daysData[i].day,
          mealIds: daysData[i].meals.map((m) => m.id).toList(),
        );

        bool isDayCreated = await Day.createDay(day);
        if (isDayCreated) {
          dayIds.add(day.id);
        }
      }

      // 3. Create the template with user-provided details
      final template = Template(
        id: UniqueKey().toString(),
        name: templateDetails['name']!,
        description: templateDetails['description']!,
        dayIds: dayIds,
        calories: widget.dailyCalories,
        type: 'custom',
      );

      bool isTemplateCreated = await Template.createTemplate(template);

      // 4. Create UserDiet that links to the template
      if (isTemplateCreated) {
        final userDiet = UserDiet(
          id: UniqueKey().toString(),
          templateId: template.id,
          completedMealIds: [], // Empty initially
        );

        bool isUserDietCreated = await UserDiet.createUserDiet(userDiet);

        // 5. Update client with userDiet reference
        if (isUserDietCreated) {
          final updatedClient = Client(
            id: widget.client.id,
            username: widget.client.username,
            email: widget.client.email,
            userDietId: userDiet.id, // Link to UserDiet instead of template
            sex: widget.client.sex,
            bodyweight: widget.client.bodyweight,
            height: widget.client.height,
            description: widget.client.description,
          );

          bool isClientUpdated = await Client.updateClient(updatedClient);

          if (isClientUpdated && mounted) {
            showToast(
              context,
              'Plan de comidas guardado correctamente',
              toastType: ToastType.success,
            );
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(
          context,
          'Error al guardar el plan de comidas',
          toastType: ToastType.error,
        );
      }
    }
  }
}
