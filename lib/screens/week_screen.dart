import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';


class WeekScreen extends StatelessWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(selectedIndex: 0, onItemTapped: (index) {
        navigationRouter(context, index);
      }),
      body: Center(
        child: Text('Week Screen'),
      ),
    );
  }
}