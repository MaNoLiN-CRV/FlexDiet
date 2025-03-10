import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/models.dart';
import 'package:flutter_flexdiet/navigation/navigation.dart';
import 'package:flutter_flexdiet/providers/diet_state_provider.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:flutter_flexdiet/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  static const double _cardHeight = 250.0;
  static const double _standardPadding = 16.0;
  static const double _smallSpacing = 10.0;
  static const double _mediumSpacing = 20.0;

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeScreenContent();
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  final TextEditingController _weightController = TextEditingController();
  final _notificationService = NotificationService();

  // Mover estos valores a un ValueNotifier para actualizaciones localizadas
  final ValueNotifier<double> _completedCalories = ValueNotifier(0.0);
  final ValueNotifier<double> _completedProtein = ValueNotifier(0);
  final ValueNotifier<double> _completedCarbs = ValueNotifier(0);

  @override
  void dispose() {
    _weightController.dispose();
    _completedCalories.dispose();
    _completedProtein.dispose();
    _completedCarbs.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dietState = context.read<DietStateProvider>();
      await dietState.initializeData();

      // Actualizar valores de nutrientes después de inicializar
      _updateCompletedNutrients(dietState);

      // Verificar si debe mostrar el diálogo de actualización de peso
      _checkAndShowWeightUpdateDialog();
    });
  }

  // Verificar si debe mostrar el diálogo de actualización de peso
  Future<void> _checkAndShowWeightUpdateDialog() async {
    final bool shouldShow =
        await _notificationService.shouldShowBodyweightUpdateDialog();

    if (shouldShow && mounted) {
      // Esperar un momento para que la pantalla termine de cargarse
      await Future.delayed(const Duration(milliseconds: 500));
      await _showWeightUpdateDialog();
    }
  }

  // Función para mostrar el diálogo de actualización de peso
  Future<void> _showWeightUpdateDialog() async {
    if (!mounted) return;

    final dietState = context.read<DietStateProvider>();

    // Obtener el peso más reciente como valor por defecto
    final currentWeight = dietState.client?.bodyweight ?? 0.0;
    final latestBodyweight = await _notificationService.getLatestBodyweight();

    // Usar el peso guardado si existe, de lo contrario usar el peso actual
    _weightController.text = (latestBodyweight ?? currentWeight).toString();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _buildWeightDialog(dialogContext, dietState);
      },
    );
  }

  // Extraer la construcción del diálogo a un método separado
  Widget _buildWeightDialog(
      BuildContext dialogContext, DietStateProvider dietState) {
    final theme = Theme.of(dialogContext);
    final isDarkMode = theme.brightness == Brightness.dark;
    final dialogBackgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final buttonColor =
        isDarkMode ? theme.colorScheme.secondary : theme.colorScheme.primary;
    final buttonTextColor = isDarkMode ? Colors.black : Colors.white;

    return AlertDialog(
      backgroundColor: dialogBackgroundColor,
      titleTextStyle: TextStyle(color: textColor, fontSize: 20),
      contentTextStyle: TextStyle(color: textColor),
      title: Text('Actualiza tu peso', style: TextStyle(color: textColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Es importante registrar tu peso para realizar un seguimiento adecuado de tu progreso.',
            style: TextStyle(color: textColor),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Peso (kg)',
              labelStyle: TextStyle(color: textColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: textColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: textColor),
              ),
            ),
            style: TextStyle(color: textColor),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // Guardar el peso ingresado para usarlo mañana si el usuario elige "Más tarde"
            final enteredWeight = double.tryParse(_weightController.text);
            if (enteredWeight != null) {
              await _notificationService.setLatestBodyweight(enteredWeight);
            }

            // Mark the dialog as not shown for tomorrow
            await _notificationService.snoozeBodyweightUpdateDialog();

            Navigator.of(dialogContext).pop();
          },
          child: Text('Más tarde', style: TextStyle(color: textColor)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: buttonTextColor,
          ),
          onPressed: () async {
            // Obtener y validar el peso ingresado
            final enteredWeight = double.tryParse(_weightController.text);
            if (enteredWeight == null || enteredWeight <= 0) {
              final SnackBar snackBar = const SnackBar(
                content: Text('Por favor, introduce un peso válido'),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(dialogContext).showSnackBar(snackBar);
              return;
            }

            // Actualizar el peso en el modelo Cliente
            if (dietState.client != null) {
              final success =
                  await dietState.client!.updateBodyweight(enteredWeight);

              if (success) {
                // Marcar el diálogo como mostrado hoy
                await _notificationService
                    .setBodyweightUpdateDialogShownToday(true);
                // Set the weight update date for weekly suppression
                await _notificationService.setLastWeightUpdateDate();
                // Limpiar el peso guardado
                await _notificationService.setLatestBodyweight(null);

                if (mounted) {
                  final SnackBar snackBar = const SnackBar(
                    content: Text('Peso actualizado correctamente'),
                    backgroundColor: Colors.green,
                  );
                  ScaffoldMessenger.of(dialogContext).showSnackBar(snackBar);
                  Navigator.of(dialogContext).pop();
                }
              } else {
                if (mounted) {
                  final SnackBar snackBar = const SnackBar(
                    content: Text('Error al actualizar el peso'),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(dialogContext).showSnackBar(snackBar);
                }
              }
            }
          },
          child: const Text('Actualizar'),
        ),
      ],
    );
  }

  void _updateCompletedNutrients(DietStateProvider dietState) {
    if (!mounted) return;
    double calories = 0;
    double protein = 0;
    double carbs = 0;

    for (final meal in dietState.todayMeals) {
      if (dietState.userDiet?.completedMealIds.contains(meal.id) ?? false) {
        calories += meal.calories ?? 0;
        protein += meal.protein ?? 0;
        carbs += meal.carbs ?? 0;
      }
    }

    // Actualizar los ValueNotifiers en lugar de variables de estado
    _completedCalories.value = calories;
    _completedProtein.value = protein;
    _completedCarbs.value = carbs;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DietStateProvider>(
      builder: (context, dietState, child) {
        if (dietState.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // El scaffold y estructuras principales que no cambian frecuentemente
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: _buildAppBar(Theme.of(context)),
          body: Stack(
            children: [
              // Fondo estático que no necesita reconstruirse con cada cambio
              RepaintBoundary(
                child: _buildWaveBackgrounds(Theme.of(context)),
              ),
              // Contenido principal
              _buildMainContent(Theme.of(context), context, dietState),
            ],
          ),
          bottomNavigationBar: BottomNav(
            selectedIndex: 1,
            onItemTapped: (index) => navigationRouter(context, index),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showWeightUpdateDialog,
            tooltip: 'Actualizar peso',
            child: const Icon(Icons.monitor_weight),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      title: Text(
        'Mi diario de Dietas',
        style: theme.appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _buildWaveBackgrounds(ThemeData theme) {
    // Este widget está dentro de un RepaintBoundary para evitar repintarlo
    return Stack(
      children: [
        Positioned.fill(
          top: 50,
          child: RepaintBoundary(
            child: WaveBackground(
              color: theme.colorScheme.primary,
              frequency: 0.5,
              phase: 1,
            ),
          ),
        ),
        Positioned.fill(
          top: 250,
          child: RepaintBoundary(
            child: WaveBackground(
              color: theme.colorScheme.secondary,
              frequency: 0.3,
              phase: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(
      ThemeData theme, BuildContext context, DietStateProvider dietState) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(HomeScreen._standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Usar NutritionCard como widget separado
            NutritionCard(
              theme: theme,
              completedCalories: _completedCalories,
              completedProtein: _completedProtein,
              completedCarbs: _completedCarbs,
              totalCalories: dietState.totalCalories,
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 0.ms)
                .slideX(begin: 0.2, end: 0),
            const SizedBox(height: 15),
            // Usar MealsSection como widget separado
            MealsSection(
              theme: theme,
              context: context,
              dietState: dietState,
              onMealStatusChanged: (String mealId, bool completed) async {
                final meal =
                    dietState.todayMeals.firstWhere((m) => m.id == mealId);

                if (completed) {
                  dietState.userDiet?.completedMealIds.add(meal.id);
                } else {
                  dietState.userDiet?.completedMealIds.remove(meal.id);
                }

                // Actualizar nutrientes sin reconstruir toda la pantalla
                _updateCompletedNutrients(dietState);

                // Update UserDiet in Firestore
                if (dietState.userDiet != null) {
                  await UserDiet.updateUserDiet(dietState.userDiet!);
                }

                // Save to historic meals for today
                await dietState.saveHistoricMeals(
                  DateTime.now(),
                  dietState.userDiet?.completedMealIds ?? [],
                );
              },
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms)
                .slideX(begin: 0.2, end: 0),
            const SizedBox(height: 15),
            // WeightChart como widget separado
            RepaintBoundary(
              child: WeightChart(
                weightHistory: dietState.client?.bodyweightHistory ?? [],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 200.ms)
                .slideX(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}

// Nuevo widget para la tarjeta de nutrición
class NutritionCard extends StatelessWidget {
  final ThemeData theme;
  final ValueNotifier<double> completedCalories;
  final ValueNotifier<double> completedProtein;
  final ValueNotifier<double> completedCarbs;
  final double totalCalories;

  const NutritionCard({
    super.key,
    required this.theme,
    required this.completedCalories,
    required this.completedProtein,
    required this.completedCarbs,
    required this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    return GridCard(
      cardTheme: CardTheme(
        color: theme.colorScheme.secondary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HomeScreen._smallSpacing),
        ),
      ),
      columns: 3,
      columnSpace: HomeScreen._smallSpacing,
      rowSpace: HomeScreen._smallSpacing,
      padding: const EdgeInsets.all(HomeScreen._mediumSpacing),
      children: [
        // Usar ValueListenableBuilder para reconstruir solo cuando cambia el valor
        ValueListenableBuilder<double>(
          valueListenable: completedProtein,
          builder: (context, value, child) {
            return _CaloryInfo(
              title: 'Proteínas',
              value: '${value.toStringAsFixed(1)} g',
              theme: theme,
            );
          },
        ),
        // Usar ValueListenableBuilder para reconstruir solo cuando cambia el valor
        ValueListenableBuilder<double>(
          valueListenable: completedCalories,
          builder: (context, value, child) {
            return CalorieWheel(
              consumedCalories: value.toInt(),
              dailyGoal: totalCalories.toInt(),
              theme: theme,
            );
          },
        ),
        // Usar ValueListenableBuilder para reconstruir solo cuando cambia el valor
        ValueListenableBuilder<double>(
          valueListenable: completedCarbs,
          builder: (context, value, child) {
            return _CaloryInfo(
              title: 'Carbohidratos',
              value: '${value.toStringAsFixed(1)} g',
              theme: theme,
            );
          },
        ),
      ],
    );
  }
}

// Nuevo widget para la sección de comidas
class MealsSection extends StatelessWidget {
  final ThemeData theme;
  final BuildContext context;
  final DietStateProvider dietState;
  final Function(String, bool) onMealStatusChanged;

  const MealsSection({
    super.key,
    required this.theme,
    required this.context,
    required this.dietState,
    required this.onMealStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (dietState.todayMeals.isEmpty) {
      return Center(
        child: Text(
          'No hay comidas para hoy',
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comidas de Hoy', style: theme.textTheme.titleLarge),
        const SizedBox(height: HomeScreen._smallSpacing),
        SizedBox(
          height: HomeScreen._cardHeight,
          width: double.infinity,
          child: OptimizedCardScroll(
            onCardTap: (index) {
              final meal = dietState.todayMeals[index];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DetailsScreen(
                    title: meal.name ?? '',
                    subtitle: 'Detalles de la comida',
                    description: meal.description ?? 'Sin descripción',
                    image: meal.image,
                    kcal: '${meal.calories?.toStringAsFixed(0)} kcal',
                    proteins: '${meal.protein?.toStringAsFixed(1)} g',
                    carbs: '${meal.carbs?.toStringAsFixed(1)} g',
                    ingredients: meal.ingredients ?? 'Sin ingredientes',
                  ),
                ),
              );
            },
            cards: dietState.todayMeals
                .map((meal) => MealCardData(
                      title: meal.timeOfDay ?? 'Sin nombre',
                      description: meal.description ?? '',
                      imageUrl: meal.image ?? 'default_image_url',
                      isSelected: dietState.userDiet?.completedMealIds
                              .contains(meal.id) ??
                          false,
                      mealId: meal.id, // Añadir ID de comida para identificarla
                    ))
                .toList(),
            onMealStatusChanged: onMealStatusChanged,
          ),
        ),
      ],
    );
  }
}

// Modificar MealCardData para incluir el ID de la comida
class MealCardData extends CardData {
  bool isSelected;
  final IconData defaultIcon;
  final String mealId; // Agregar el ID de la comida

  MealCardData({
    required super.title,
    required super.description,
    super.imageUrl,
    this.isSelected = false,
    this.defaultIcon = Icons.restaurant,
    required this.mealId, // Requerir el ID de la comida
  });
}

// CardScroll optimizado que utiliza ListView.builder con widgets individuales
class OptimizedCardScroll extends StatelessWidget {
  final List<MealCardData> cards;
  final Function(int) onCardTap;
  final Function(String, bool) onMealStatusChanged;

  const OptimizedCardScroll({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.onMealStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return MealCard(
          card: cards[index],
          index: index,
          onTap: () => onCardTap(index),
          onStatusChanged: onMealStatusChanged,
        );
      },
    );
  }
}

// Widget separado para cada tarjeta individual
class MealCard extends StatefulWidget {
  final MealCardData card;
  final int index;
  final VoidCallback onTap;
  final Function(String, bool) onStatusChanged;

  const MealCard({
    super.key,
    required this.card,
    required this.index,
    required this.onTap,
    required this.onStatusChanged,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.card.isSelected;
  }

  @override
  void didUpdateWidget(MealCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.isSelected != widget.card.isSelected) {
      _isSelected = widget.card.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
        _isSelected ? Colors.white : theme.textTheme.bodyMedium?.color;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 200,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: _isSelected ? Colors.green : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: widget.card.imageUrl != null &&
                        widget.card.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.card.imageUrl!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                        errorBuilder: (context, error, stackTrace) {
                          return _buildIconContainer(
                              widget.card.defaultIcon, theme);
                        },
                      )
                    : _buildIconContainer(widget.card.defaultIcon, theme),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.card.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: textColor),
                    ),
                    Text(
                      widget.card.description ?? '',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: textColor),
                      maxLines: 1, // Limit to one line
                      overflow: TextOverflow
                          .ellipsis, // Add ellipsis (...) if the text overflows
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MSHCheckbox(
                      size: 30,
                      value: _isSelected,
                      colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                        checkedColor: Colors.white,
                        uncheckedColor: theme.colorScheme.onSurface,
                      ),
                      style: MSHCheckboxStyle.stroke,
                      onChanged: (selected) {
                        setState(() {
                          _isSelected = selected;
                        });
                        // Actualizar el estado externo con el ID de la comida
                        widget.onStatusChanged(widget.card.mealId, selected);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon, ThemeData theme) {
    return Container(
      height: 120,
      width: double.infinity,
      color: theme.colorScheme.primary.withValues(alpha: 0.1),
      child: Icon(
        icon,
        size: 48,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _CaloryInfo extends StatelessWidget {
  final String title;
  final String value;
  final ThemeData theme;

  const _CaloryInfo({
    required this.title,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
