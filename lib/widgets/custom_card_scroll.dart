import 'package:flutter/material.dart';

class CardScroll extends StatelessWidget {
  final List<CardData> cards;
  final Axis scrollDirection;
  const CardScroll({super.key, required this.cards , this.scrollDirection = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return CardItem(cardData: cards[index]);
      },
    );
  }
}

class CardData {
  final String title;
  final String description;
  final String imageUrl;

  CardData({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class CardItem extends StatelessWidget {
  final CardData cardData;

  const CardItem({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 200, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                cardData.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, object, stackTrace) {
                  return Image(image: AssetImage('assets/images/logo.png'), fit: BoxFit.cover);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardData.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(cardData.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}