import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/login_screen.dart';
import 'package:flutter_flexdiet/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: defaultTheme,
      title: 'Material App',
      home: Scaffold(
        body: Center(
          child: LoginScreen(),
        ),
      ),
    );
  }
}
