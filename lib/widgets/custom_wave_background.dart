import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveBackground extends StatefulWidget {
  final Color color;
  final double frequency;
  final double phase;
  
  const WaveBackground({
    super.key,
    this.color = Colors.blue,
    this.frequency = 2.0,
    this.phase = 0.0,
  });

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(
            color: widget.color.withValues( alpha: 0.1),
            frequency: widget.frequency,
            phase: _controller.value * 2 * math.pi + widget.phase,
          ),
          child: child,
        );
      },
      child: Container(),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final double frequency;
  final double phase;

  WavePainter({
    required this.color,
    required this.frequency,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x < size.width; x++) {
      final y = size.height / 2 +
          math.sin((x / size.width * frequency * math.pi * 2) + phase) * 50.0;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      color != oldDelegate.color ||
      frequency != oldDelegate.frequency ||
      phase != oldDelegate.phase;
}