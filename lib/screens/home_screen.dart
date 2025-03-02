import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/card_data.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_flexdiet/models/final_models/day.dart';
import 'package:flutter_flexdiet/models/final_models/meal.dart';
import 'package:flutter_flexdiet/models/final_models/template.dart';
import 'package:flutter_flexdiet/models/final_models/user_diet.dart';
import 'package:flutter_flexdiet/navigation/navigation.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  Client? _client;
  UserDiet? _userDiet;
  Template? _template;
  List<Day> _days = [];
  List<Meal> _todayMeals = [];
  bool _isLoading = true;
  double _totalCalories = 0;
  double _totalProtein = 0;
  double _totalCarbs = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Load client data
        _client = await Client.getClient(user.uid);
        print('Client loaded: ${_client?.username}');

        if (_client?.userDietId != null) {
          // Load user diet
          _userDiet = await UserDiet.getUserDiet(_client!.userDietId!);
          print('UserDiet loaded: ${_userDiet?.id}');

          // Load template
          _template = await Template.getTemplate(_userDiet!.templateId);
          print('Template loaded: ${_template?.name}');

          // Load days
          for (String dayId in _template!.dayIds) {
            final day = await Day.getDay(dayId);
            _days.add(day);
            print('Day loaded: ${day.name}');
          }

          // Get today's day name in Spanish
          final dayName =
              DateFormat('EEEE', 'es_ES').format(DateTime.now()).toLowerCase();

          // Find today's meals
          final todayDay = _days.firstWhere(
            (day) => day.name?.toLowerCase() == dayName,
            orElse: () => _days.first,
          );

          if (todayDay.mealIds != null) {
            // Load meals for today
            for (String mealId in todayDay.mealIds!) {
              final meal = await Meal.getMeal(mealId);
              _todayMeals.add(meal);
              print('Meal loaded: ${meal.name}');
            }

            // Calculate totals
            _totalCalories =
                _todayMeals.fold(0, (sum, meal) => sum + (meal.calories ?? 0));
            _totalProtein =
                _todayMeals.fold(0, (sum, meal) => sum + (meal.protein ?? 0));
            _totalCarbs =
                _todayMeals.fold(0, (sum, meal) => sum + (meal.carbs ?? 0));
            print('Totals calculated');
          }
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e, stackTrace) {
      print('Error loading data: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() => _isLoading = false);
        showToast(context, 'Error al cargar los datos',
            toastType: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(theme),
      body: Stack(
        children: [
          _buildWaveBackgrounds(theme),
          _buildMainContent(theme, context),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: 1,
        onItemTapped: (index) => navigationRouter(context, index),
      ),
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

  Widget _buildMainContent(ThemeData theme, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(HomeScreen._standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNutritionCard(theme)
                .animate()
                .fadeIn(duration: 300.ms, delay: 0.ms)
                .slideX(begin: 0.2, end: 0),
            const SizedBox(height: 15),
            _buildMealsSection(theme, context)
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
  Widget _buildNutritionCard(ThemeData theme) {
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
          value: '${_totalProtein.toStringAsFixed(1)} g',
          theme: theme,
        ),
        CalorieWheel(
          consumedCalories: _totalCalories.toInt(),
          dailyGoal: _template?.calories ?? 2000,
          theme: theme,
        ),
        _CaloryInfo(
          title: 'Carbohidratos',
          value: '${_totalCarbs.toStringAsFixed(1)} g',
          theme: theme,
        ),
      ],
    );
  }

  // Modify _buildMealsSection to use real data
  Widget _buildMealsSection(ThemeData theme, BuildContext context) {
    if (_todayMeals.isEmpty) {
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
              final meal = _todayMeals[index];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DetailsScreen(
                    title: meal.name ?? '',
                    subtitle: 'Detalles de la comida',
                    description: meal.description ?? '',
                    image: meal.image,
                    kcal: '${meal.calories?.toStringAsFixed(0)} kcal',
                    proteins: '${meal.protein?.toStringAsFixed(1)} g',
                    carbs: '${meal.carbs?.toStringAsFixed(1)} g',
                  ),
                ),
              );
            },
            cards: _todayMeals
                .map((meal) => MealCardData(
                      title: meal.name ?? 'Sin nombre',
                      description: meal.description ?? '',
                      imageUrl: meal.image ?? 'default_image_url',
                      isSelected:
                          _userDiet?.completedMealIds.contains(meal.id) ??
                              false,
                    ))
                .toList(),
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
  final Function(int) onCardTap;

  const CardScroll({
    super.key,
    required this.cards,
    required this.onCardTap,
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
                        onChanged: (selected) {
                          setState(() {
                            card.isSelected = selected;
                          });
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
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Icon(
        icon,
        size: 48,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
