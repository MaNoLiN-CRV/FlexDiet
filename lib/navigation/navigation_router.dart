import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/admin_service.dart';

void navigationRouter(BuildContext context, int index) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final isAdmin = await AdminService().isUserAdmin();

  Widget targetScreen;

  if (isAdmin) {
    // Admin navigation - Only AdminScreen and SettingsScreen
    switch (index) {
      case 3: // AdminScreen
        targetScreen = const AdminScreen();
        break;
      case 2: // SettingsScreen
        targetScreen = const SettingsScreen();
        break;
      default:
        return;
    }
  } else {
    // Regular user navigation
    switch (index) {
      case 0: // WeekScreen
        targetScreen = const WeekScreen();
        break;
      case 1: // HomeScreen
        targetScreen = const HomeScreen();
        break;
      case 2: // SettingsScreen
        targetScreen = const SettingsScreen();
        break;
      default:
        return;
    }
  }

  if (context.mounted) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
