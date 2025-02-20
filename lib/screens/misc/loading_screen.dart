import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoadingScreen extends StatefulWidget {
  final Widget targetScreen;
  final Future<void>? loadingFuture;
  final int loadingSeconds;
  final String loadingText;

  const LoadingScreen({
    super.key,
    required this.targetScreen,
    this.loadingFuture,
    this.loadingSeconds = 1,
    this.loadingText = "Cargando...",
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  bool _futureCompleted = false;
  bool _timerCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _startLoading();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startLoading() async {
    Timer(Duration(seconds: widget.loadingSeconds), () {
      _timerCompleted = true;
      _navigateToTargetScreenIfReady();
    });

    if (widget.loadingFuture != null) {
      await widget.loadingFuture!;
      _futureCompleted = true;
      _navigateToTargetScreenIfReady();
    } else {
      _futureCompleted = true;
    }
  }

  void _navigateToTargetScreenIfReady() {
    if (_timerCompleted && _futureCompleted && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.targetScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final loadingTextColor =
        isDarkMode ? theme.colorScheme.onSurface : theme.colorScheme.primary;
    final subtitleTextColor = isDarkMode
        ? theme.colorScheme.onSurface.withValues(alpha: 70)
        : theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingWheel(
              theme: theme,
              seconds: widget.loadingSeconds,
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                widget.loadingText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: loadingTextColor,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Ajustando tu dieta...",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: subtitleTextColor,
              ),
            )
                .animate()
                .fadeIn(duration: 1000.ms)
                .then()
                .slide(begin: const Offset(0, 0.25), curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}
