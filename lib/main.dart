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
import 'package:flutter/foundation.dart';

// Declare shared preferences globally
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase and SharedPreferences

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print('SharedPreferences initialized in main()');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error during initialization: $e');
    }
  }

  Intl.defaultLocale = 'es';

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthService authService = AuthService();

  Future<bool> _hasCompletedUserInfo() async {
    try {
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
                  return const SplashScreen();
                } else if (snapshot.hasError) {
                  // Provide a friendly error message or fallback UI
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return const SplashScreen(); // Handle the case of no data
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
      // Add a delay before navigating when the user is already logged in
      await Future.delayed(const Duration(seconds: 2));

      // Check if user information is completed
      final hasCompletedInfo = await _hasCompletedUserInfo();
      return hasCompletedInfo
          ? const HomeScreen()
          : const UserInfoScreen(); // Navigate to the appropriate screen
    } else {
      return const LoginScreen(); // Show login screen if user is not logged in
    }
  }
}
