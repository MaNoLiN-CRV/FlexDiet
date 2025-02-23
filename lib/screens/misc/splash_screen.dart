import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_flexdiet/screens/login/login_screen.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationAndNavigate();
  }

  Future<bool> _hasCompletedUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('userInfoCompleted') ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _checkAuthenticationAndNavigate() async {
    // Add a delay to ensure the splash screen is visible for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if the user is already logged in
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, check if user info is completed
      final hasCompletedInfo = await _hasCompletedUserInfo();
      Widget targetScreen =
          hasCompletedInfo ? const HomeScreen() : const UserInfoScreen();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoadingScreen(
                    targetScreen: targetScreen,
                    loadingSeconds: 2, // Adjust loading seconds as needed
                  )),
        );
      }
    } else {
      // User is not logged in, navigate to the login screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  fit: BoxFit.contain,
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 28, 27, 27),
                    const Color.fromARGB(255, 34, 29, 74),
                    const Color.fromARGB(255, 41, 84, 154),
                    const Color.fromARGB(255, 2, 81, 227)
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ).createShader(bounds);
              },
              child: Text(
                'Tu camino hacia una vida saludable',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
