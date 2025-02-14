import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveBackground extends StatefulWidget {
  final Color color;
  final double frequency;
  final double phase;
  final double top;
  
  const WaveBackground({
    super.key,
    this.color = Colors.blue,
    this.frequency = 2.0,
    this.phase = 0.0,
    this.top = 0.0,
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
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            isComplex: true,
            willChange: true, 
            painter: WavePainter(
              color: widget.color.withValues(alpha: 0.2),
              frequency: widget.frequency,
              phase: _controller.value * 2 * math.pi + widget.phase,
            ),
          );
        },
      ),
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
      ..style = PaintingStyle.fill
      ..isAntiAlias = true; // Smooth edges

    final path = Path();
    path.moveTo(0, size.height);

    final wavePoints = List<Offset>.generate(
      (size.width).toInt(),
      (x) => Offset(
        x.toDouble(),
        size.height / 2 + math.sin((x / size.width * frequency * math.pi * 2) + phase) * 100.0,
      ),
    );

    path.addPolygon(wavePoints, false);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      color != oldDelegate.color ||
      frequency != oldDelegate.frequency ||
      phase != oldDelegate.phase;
}
