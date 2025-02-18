import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/widgets/custom_card_scroll.dart';

List<CardData> weekDays = [
  CardData(title: "Lunes", imageUrl: "assets/images/day.png"),
  CardData(title: "Martes", imageUrl: "assets/images/day.png"),
  CardData(title: "Miercoles", imageUrl: "assets/images/day.png"),
  CardData(title: "Jueves", imageUrl: "assets/images/day.png"),
  CardData(title: "Viernes", imageUrl: "assets/images/day.png"),
  CardData(title: "Sabado", imageUrl: "assets/images/day.png"),
  CardData(title: "Domingo", imageUrl: "assets/images/day.png"),
];

class WeekScreen extends StatelessWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semana"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNav(
          selectedIndex: 0,
          onItemTapped: (index) {
            navigationRouter(context, index);
          }),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CardScroll(cards: weekDays, scrollDirection: Axis.vertical)
        ]),
      ),
    );
  }
}
