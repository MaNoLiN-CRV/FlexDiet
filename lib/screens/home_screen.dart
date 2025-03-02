import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/models.dart';
import 'package:flutter_flexdiet/navigation/navigation.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

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

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          value: '120 g',
          theme: theme,
        ),
        CalorieWheel(
          consumedCalories: 2000,
          dailyGoal: 3000,
          theme: theme,
        ),
        _CaloryInfo(
          title: 'Carbohidratos',
          value: '300 g',
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildMealsSection(ThemeData theme, BuildContext context) {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DetailsScreen(
                      title: 'Desayuno',
                      subtitle: 'Empieza el día con energía',
                      description: 'Huevos y tostadas',
                      image:
                          'https://familiakitchen.com/wp-content/uploads/2022/12/Beans-and-Rice-4-Fudio-istock-D-1198428606.jpg',
                      kcal: '460 kcal',
                      proteins: '20 g',
                      carbs: '101 g',
                    ),
                  ));
            },
            cards: [
              MealCardData(
                title: 'Desayuno',
                description: 'Huevos y tostadas',
                imageUrl:
                    'https://familiakitchen.com/wp-content/uploads/2022/12/Beans-and-Rice-4-Fudio-istock-D-1198428606.jpg',
              ),
              MealCardData(
                title: 'Almuerzo',
                description: 'Ensalada con pollo',
                imageUrl:
                    'https://familiakitchen.com/wp-content/uploads/2022/12/Beans-and-Rice-4-Fudio-istock-D-1198428606.jpg',
              ),
              MealCardData(
                title: 'Cena',
                description: 'Bistec y verduras',
                imageUrl:
                    'https://familiakitchen.com/wp-content/uploads/2022/12/Beans-and-Rice-4-Fudio-istock-D-1198428606.jpg',
              ),
            ],
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

class MealCardData extends CardData {
  bool isSelected;

  MealCardData({
    required super.title,
    required super.description,
    required super.imageUrl,
    this.isSelected = false,
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
                  child: Image.network(
                    card.imageUrl!,
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
                      return Container(
                        color: theme.colorScheme.primary,
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
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
}
