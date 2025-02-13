import 'package:flutter/material.dart';
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
      body: Padding(
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
                CalorieWheel(consumedCalories: 2000, dailyGoal: 3000, theme: theme),
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
            GridCard(
              cardTheme: CardTheme(
                color: theme.colorScheme.secondary,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              columns: 2,
              columnSpace: 10,
              rowSpace: 10,
              padding: const EdgeInsets.all(15),
              children: [
                _buildMealItem(
                    'Breakfast', 'Whole wheat toast, avocado...', theme),
                _buildMealItem('Lunch', 'Quinoa salad, chicken...', theme),
                _buildMealItem('Snacks', 'Fruit, nuts...', theme),
                _buildMealItem(
                    'Dinner', 'Grilled salmon, vegetables...', theme),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.colorScheme.primary,
        selectedItemColor: theme.colorScheme.secondaryContainer,
        unselectedItemColor: theme.colorScheme.surface.withAlpha(128),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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

  Widget _buildMealItem(String mealType, String description, ThemeData theme) {
    return InkWell(
      onTap: () {
        print('Clicked on $mealType');
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealType,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.surface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.surface.withAlpha(128),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}


