import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(selectedIndex: 2, onItemTapped: (index) {
        navigationRouter(context, index);
      }),
      body: Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}