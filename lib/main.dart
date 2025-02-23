import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flexdiet/screens/screens.dart'; // Import all screens
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Intl.defaultLocale = 'es';

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthService authService = AuthService(); // Get the AuthService instance

  Future<bool> _hasCompletedUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('userInfoCompleted') ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Listen for sign-out events
    authService.signOutStream.listen((_) {
      // Navigate to the LoginScreen when a sign-out occurs
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    authService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FlexDiet',
            theme: themeProvider.themeData,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es', 'ES'),
            ],
            home: FutureBuilder<Widget>(
              future: _getInitialScreen(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen(); // Or a loading indicator
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else {
                  return snapshot.data!;
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future<Widget> _getInitialScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Add a delay before navigating when user is already logged in
      await Future.delayed(const Duration(seconds: 2));
      final hasCompletedInfo = await _hasCompletedUserInfo();
      return hasCompletedInfo ? const HomeScreen() : const UserInfoScreen();
    } else {
      return const LoginScreen();
    }
  }
}
