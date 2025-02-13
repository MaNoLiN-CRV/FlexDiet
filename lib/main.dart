import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/login_screen.dart';
import 'package:flutter_flexdiet/theme/default.dart';

void main() => runApp(const MyApp());

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
 