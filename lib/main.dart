import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
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

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
                return Scaffold(
                  body: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              } else if (!snapshot.hasData) {
                return const SplashScreen();
              } else {
                return snapshot.data!;
              }
            },
          ),
        );
      },
    );
  }

  Future<Widget> _getInitialScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final hasCompletedInfo = await _hasCompletedUserInfo();
      return hasCompletedInfo ? const HomeScreen() : const UserInfoScreen();
    } else {
      return const LoginScreen();
    }
  }

  Future<bool> _hasCompletedUserInfo() async {
    try {
      return prefs.getBool('userInfoCompleted') ?? false;
    } catch (e) {
      return false;
    }
  }
}
