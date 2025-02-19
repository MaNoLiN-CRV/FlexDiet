import 'package:flutter/material.dart';

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
        return CardItem(
          cardData: cards[index],
          onTap: () => onCardTap?.call(index),
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
  final VoidCallback? onTap;

  const CardItem({
    super.key,
    required this.cardData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(12);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 200,
      child: Material(
        elevation: 2,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 120,
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
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (cardData.description != null)
                      Text(
                        cardData.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
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
    );
  }
}
