import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/screens/settings_screen.dart';
import 'package:flutter_flexdiet/screens/week_screen.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          'My Diet Diary',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Wave backgrounds
          Positioned.fill(
            top: 50,
            child: WaveBackground(
              color: theme.colorScheme.primary,
              frequency: 0.5,
              phase: 1,
            ),
          ),
          Positioned.fill(
            top: 250,
            child: WaveBackground(
              color: theme.colorScheme.secondary,
              frequency: 0.3,
              phase: 0,
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GridCard(
                  cardTheme: CardTheme(
                    color: theme.colorScheme.secondary,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  columns: 3,
                  columnSpace: 10,
                  rowSpace: 10,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildCaloryInfo('Protein', '120 g', theme),
                    CalorieWheel(
                        consumedCalories: 2000, dailyGoal: 3000, theme: theme),
                    _buildCaloryInfo('Carbs', '300 g', theme),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Today\'s Meals',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: CardScroll(cards: [
                    CardData(
                      title: 'Breakfast',
                      description: 'Eggs and toast',
                      imageUrl:
                          'https://familiakitchen.com/wp-content/uploads/2022/12/Beans-and-Rice-4-Fudio-istock-D-1198428606.jpg',
                    ),
                    CardData(
                      title: 'Lunch',
                      description: 'Salad with chicken',
                      imageUrl:
                          'https://familiakitchen.com/wp-content/uploads/2022/12/Beans-and-Rice-4-Fudio-istock-D-1198428606.jpg',
                    ),
                    CardData(
                      title: 'Dinner',
                      description: 'Steak and vegetables',
                      imageUrl:
                          'https://familiakitchen.com/wp-content/uploads/2022/12/Beans-and-Rice-4-Fudio-istock-D-1198428606.jpg',
                    )
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: 1,
        onItemTapped: (index) {
          navigationRouter(context, index);
        }, // Navigate to register screen when the register button is tapped
      ),
    );
  }

  Widget _buildCaloryInfo(String title, String value, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.surface.withAlpha(128),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}