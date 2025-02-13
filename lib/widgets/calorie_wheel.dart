import 'dart:math';

import 'package:flutter/material.dart';



class CalorieWheel extends StatelessWidget {
  final int consumedCalories;
  final int dailyGoal;
  final ThemeData theme;
  const CalorieWheel({
    super.key,
    required this.consumedCalories,
    required this.dailyGoal,
    required this.theme
  });

  @override
  Widget build(BuildContext context) {
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