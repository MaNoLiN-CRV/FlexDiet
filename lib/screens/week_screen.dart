import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';

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
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Expanded(
            child: CardScroll(cards: weekDays, scrollDirection: Axis.vertical),
          ),
        ),
      ),
    );
  }
}

class CardScroll extends StatelessWidget {
  final List<CardData> cards;
  final Axis scrollDirection;
  final void Function(int index)? onCardTap;

  const CardScroll({
    super.key,
    required this.cards,
    this.scrollDirection = Axis.horizontal,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onCardTap?.call(index),
          child: CardItem(cardData: cards[index]),
        );
      },
    );
  }
}

class CardData {
  String title;
  String? description;
  String imageUrl;

  CardData({
    required this.title,
    this.description,
    required this.imageUrl,
  });
}

class CardItem extends StatelessWidget {
  final CardData cardData;

  const CardItem({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(12);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 200,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          elevation: 2,
          child: InkWell(
            onTap: () {/* Your tap action */},
            borderRadius: borderRadius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.network(
                    cardData.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardData.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ) ??
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      if (cardData.description != null)
                        Text(
                          cardData.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ) ??
                              const TextStyle(color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
