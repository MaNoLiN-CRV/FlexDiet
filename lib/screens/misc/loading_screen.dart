import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class LoadingScreen extends StatefulWidget {
  final Widget targetScreen;
  final Future<void>? loadingFuture;
  final int loadingSeconds;

  const LoadingScreen({
    super.key,
    required this.targetScreen,
    this.loadingFuture,
    this.loadingSeconds = 2,
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _futureCompleted = false;
  bool _timerCompleted = false;

  @override
  void initState() {
    super.initState();
    _startLoading();
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
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: LoadingWheel(theme: theme, seconds: widget.loadingSeconds),
      ),
    );
  }
}
