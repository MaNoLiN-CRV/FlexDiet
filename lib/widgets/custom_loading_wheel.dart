import 'dart:math';

import 'package:flutter/material.dart';

class LoadingWheel extends StatefulWidget {
  final ThemeData theme;
  final int seconds;

  const LoadingWheel({
    super.key,
    required this.theme,
    this.seconds = 2,
  });

  @override
  _LoadingWheelState createState() => _LoadingWheelState();
}

class _LoadingWheelState extends State<LoadingWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FruitLoadingPainter(
        theme: widget.theme,
        progress: _animation.value,
      ),
      child: const SizedBox(
        width: 75.0,
        height: 75.0,
      ),
    );
  }
}

class _FruitLoadingPainter extends CustomPainter {
  final ThemeData theme;
  final double progress;

  _FruitLoadingPainter({
    required this.theme,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundPaint = Paint()
      ..color = theme.colorScheme.surface.withAlpha(50)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, backgroundPaint);

    final foregroundPaint = Paint()
      ..color = theme.colorScheme.onSurface
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double startAngle = -0.5 * pi;
    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );

    final fruitIndex = (progress * fruits.length) % fruits.length;
    final currentFruit = fruits[fruitIndex.toInt()];
    final fruitPainter = TextPainter(
      text: TextSpan(
        text: currentFruit['icon'],
        style: TextStyle(
          fontSize: radius * 0.8,
          color: isDarkMode
              ? Colors.white
              : theme.colorScheme
                  .primary, // Use theme color or white based on dark mode
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    fruitPainter.layout();
    fruitPainter.paint(canvas, center - fruitPainter.size.center(Offset.zero));
  }

  final List<Map<String, dynamic>> fruits = [
    {'icon': '🍎'}, // Apple
    {'icon': '🍌'}, // Banana
    {'icon': '🍓'}, // Strawberry
    {'icon': '🍇'}, // Grapes
    {'icon': '🍊'}, // Orange
    {'icon': '🥝'}, // Kiwi
    {'icon': '🍋'}, // Lemon
    {'icon': '🍉'}, // Watermelon
    {'icon': '🍐'}, // Pear
  ];

  @override
  bool shouldRepaint(covariant _FruitLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.theme != theme;
  }
}
