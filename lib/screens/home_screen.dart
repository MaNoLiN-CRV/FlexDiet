import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/card_data.dart';
import 'package:flutter_flexdiet/models/final_models/meal.dart';
import 'package:flutter_flexdiet/models/final_models/user_diet.dart';
import 'package:flutter_flexdiet/navigation/navigation.dart';
import 'package:flutter_flexdiet/providers/diet_state_provider.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DietStateProvider>().initializeData();
    });
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

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: _buildAppBar(Theme.of(context)),
          body: Stack(
            children: [
              _buildWaveBackgrounds(Theme.of(context)),
              _buildMainContent(Theme.of(context), context, dietState),
            ],
          ),
          bottomNavigationBar: BottomNav(
            selectedIndex: 1,
            onItemTapped: (index) => navigationRouter(context, index),
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
            _buildNutritionCard(theme, dietState)
                .animate()
                .fadeIn(duration: 300.ms, delay: 0.ms)
                .slideX(begin: 0.2, end: 0),
            const SizedBox(height: 15),
            _buildMealsSection(theme, context, dietState)
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms)
                .slideX(begin: 0.2, end: 0),
            const SizedBox(height: 15),
            WeightChart()
                .animate()
                .fadeIn(duration: 300.ms, delay: 200.ms)
                .slideX(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  // Modify _buildNutritionCard to use real data
  Widget _buildNutritionCard(ThemeData theme, DietStateProvider dietState) {
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
        _CaloryInfo(
          title: 'Proteínas',
          value: '${dietState.totalProtein.toStringAsFixed(1)} g',
          theme: theme,
        ),
        CalorieWheel(
          consumedCalories: dietState.totalCalories.toInt(),
          dailyGoal: dietState.template?.calories ?? 2000,
          theme: theme,
        ),
        _CaloryInfo(
          title: 'Carbohidratos',
          value: '${dietState.totalCarbs.toStringAsFixed(1)} g',
          theme: theme,
        ),
      ],
    );
  }

  // Modify _buildMealsSection to use real data
  Widget _buildMealsSection(
      ThemeData theme, BuildContext context, DietStateProvider dietState) {
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
          child: CardScroll(
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
                    ))
                .toList(),
            meals: dietState.todayMeals,
            onMealStatusChanged: (mealId, completed) async {
              final mealInList =
                  dietState.todayMeals.firstWhere((meal) => meal.id == mealId);

              if (completed) {
                // Add to completed meals
                dietState.userDiet?.completedMealIds.add(mealInList.id);
              } else {
                // Remove from completed meals
                dietState.userDiet?.completedMealIds.remove(mealInList.id);
              }

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
          ),
        ),
      ],
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

// Modify MealCardData to include an icon
class MealCardData extends CardData {
  bool isSelected;
  final IconData defaultIcon;

  MealCardData({
    required super.title,
    required super.description,
    super.imageUrl,
    this.isSelected = false,
    this.defaultIcon = Icons.restaurant,
  });
}

class CardScroll extends StatefulWidget {
  final List<MealCardData> cards;
  final List<Meal> meals;
  final Function(int) onCardTap;
  final Function(String mealId, bool completed) onMealStatusChanged;

  const CardScroll({
    super.key,
    required this.cards,
    required this.meals,
    required this.onCardTap,
    required this.onMealStatusChanged,
  });

  @override
  State<CardScroll> createState() => _CardScrollState();
}

class _CardScrollState extends State<CardScroll> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.cards.length,
      itemBuilder: (context, index) {
        final card = widget.cards[index];
        final textColor =
            card.isSelected ? Colors.white : theme.textTheme.bodyMedium?.color;

        return GestureDetector(
          onTap: () {
            widget.onCardTap(index);
          },
          child: Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: card.isSelected ? Colors.green : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: card.imageUrl != null && card.imageUrl!.isNotEmpty
                      ? Image.network(
                          card.imageUrl!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return _buildIconContainer(card.defaultIcon, theme);
                          },
                        )
                      : _buildIconContainer(card.defaultIcon, theme),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: textColor),
                      ),
                      Text(
                        card.description ?? '',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: textColor),
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
                        value: card.isSelected,
                        colorConfig:
                            MSHColorConfig.fromCheckedUncheckedDisabled(
                          checkedColor: Colors.white,
                          uncheckedColor: theme.colorScheme.onSurface,
                        ),
                        style: MSHCheckboxStyle.stroke,
                        onChanged: (selected) async {
                          setState(() {
                            card.isSelected = selected;
                          });

                          // Get the corresponding meal
                          final mealInList = widget.meals[index];

                          if (selected) {
                            // Add to completed meals
                            widget.onMealStatusChanged(mealInList.id, true);
                          } else {
                            // Remove from completed meals
                            widget.onMealStatusChanged(mealInList.id, false);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this helper method in _CardScrollState
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
