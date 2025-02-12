import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/widgets/CustomGridCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color backgroundColorWhite = const Color(0xFFE3EDF7);
  final Color backgroundColorBlue = const Color(0xFF4530B3);
  final Color containersBlue = const Color(0xFF5451D6);
  final Color selectionBlue = const Color(0xFF21D1FF);
  final Color textBlue = const Color(0xFF30436E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorWhite,
      appBar: AppBar(
        backgroundColor: backgroundColorBlue,
        title: Text(
          'My Diet Diary',
          style: TextStyle(color: backgroundColorWhite),
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
                color: containersBlue,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              columns: 3,
              columnSpace: 10,
              rowSpace: 10,
              padding: const EdgeInsets.all(20),
              children: [
                _buildCaloryInfo('Protein', '120 g'),
                _buildCalorieWheel(2200, 2500),
                _buildCaloryInfo('Carbs', '300 g'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Today\'s Meals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textBlue,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            GridCard(
              cardTheme: CardTheme(
                color: containersBlue,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              columns: 2, 
              columnSpace: 10,
              rowSpace: 10,
              padding: const EdgeInsets.all(15),
              children: [
                _buildMealItem('Breakfast', 'Whole wheat toast, avocado...'),
                _buildMealItem('Lunch', 'Quinoa salad, chicken...'),
                _buildMealItem('Snacks', 'Fruit, nuts...'),
                _buildMealItem('Dinner', 'Grilled salmon, vegetables...'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColorBlue,
        selectedItemColor: selectionBlue,
        unselectedItemColor: backgroundColorWhite.withAlpha(128),
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

  Widget _buildCaloryInfo(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: backgroundColorWhite.withAlpha(128),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: backgroundColorWhite, 
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper widget for meal items
  Widget _buildMealItem(String mealType, String description) {
    return InkWell(
      onTap: () {
        print('Clicked on $mealType');
  
      },
      borderRadius: BorderRadius.circular(
          10), 
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealType,
              style: TextStyle(
                color: backgroundColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                color: backgroundColorWhite
                    .withAlpha(128), 
                fontSize: 14,
              ),
              overflow:
                  TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieWheel(int consumedCalories, int dailyGoal) {
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
              progressColor: selectionBlue,
              trackColor:
                  backgroundColorWhite.withAlpha(50),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$consumedCalories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: backgroundColorWhite,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'kcal',
              style: TextStyle(
                fontSize: 12,
                color: backgroundColorWhite
                    .withAlpha(128), 
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

    // Progress arc
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
