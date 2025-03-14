import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_flexdiet/models/client.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/admin_service.dart';
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flexdiet/providers/diet_state_provider.dart';
import 'package:flutter_flexdiet/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:intl/date_symbol_data_local.dart';

late SharedPreferences prefs;

const String _appFirstLaunchKey = 'appFirstLaunch';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qsabrkicimdalfyurpio.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzYWJya2ljaW1kYWxmeXVycGlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5MTQ2NTQsImV4cCI6MjA1NjQ5MDY1NH0.XLNqLhHxeb0H5pYqpwcy5S2gHPl8eu2JihKSB1jK9II',
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  prefs = await SharedPreferences.getInstance();

  // Initialize Timezone and Notification Service
  tzdata.initializeTimeZones();

  Intl.defaultLocale = 'es';

  // Initialize locale data for date formatting
  await initializeDateFormatting('es', null); // Initialize the 'es' locale

  // Check if the app is launching for the first time
  bool isFirstLaunch = prefs.getBool(_appFirstLaunchKey) ?? true;

  if (isFirstLaunch) {
    // Set lastWeightUpdateDate to a date in the future (7 days from now)
    DateTime futureDate = DateTime.now().add(const Duration(days: 7));
    String futureDateString = DateFormat('yyyy-MM-dd', 'es')
        .format(futureDate); // Specify the locale here as well
    await prefs.setString(
        NotificationService.lastWeightUpdateDateKey, futureDateString);

    // Set the flag to false so this only runs once
    await prefs.setBool(_appFirstLaunchKey, false);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DietStateProvider()),
      ],
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
      try {
        // Initialize admin service first
        final adminService = AdminService();
        await adminService.initialize();
        final isAdmin = await adminService.isUserAdmin();

        // If admin, return AdminScreen immediately without checking for client data
        if (isAdmin) {
          return const AdminScreen();
        }

        // Only fetch client data for non-admin users
        final client = await Client.getClient(user.uid);
        final hasCompletedInfo = await _hasCompletedUserInfo();

        return hasCompletedInfo
            ? const HomeScreen()
            : UserInfoScreen(client: client);
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching client data: $e');
        }
        return const LoginScreen();
      }
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
