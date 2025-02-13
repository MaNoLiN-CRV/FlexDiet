import 'dart:math';
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
                _buildCalorieWheel(2200, 2500, theme),
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

  Widget _buildCalorieWheel(
      int consumedCalories, int dailyGoal, ThemeData theme) {
    double progress = consumedCalories / dailyGoal;
    if (progress > 1.0) progress = 1.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: CalorieWheelPainter(
              progress: progress,
              progressColor: theme.colorScheme.secondaryContainer,
              trackColor: theme.colorScheme.surface.withAlpha(50),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$consumedCalories',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.surface,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'kcal',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: theme.colorScheme.surface.withAlpha(128),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class CalorieWheelPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color trackColor;

  CalorieWheelPainter({
    required this.progress,
    required this.progressColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CalorieWheelPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
