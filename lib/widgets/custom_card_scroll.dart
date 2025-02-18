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
    return Stack(
      children: [
        ListView.builder(
          scrollDirection: scrollDirection,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onCardTap?.call(index),
              child: CardItem(cardData: cards[index]),
            );
          },
        ),
      ],
    );
  }
}

class CardData {
  String title;
  String description;
  String imageUrl;

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
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(12);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: 200,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 120, minWidth: double.infinity),
                  child: Image.network(
                    cardData.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
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
                      return Image(
                        image: const AssetImage('assets/images/logo.png'),
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
                          ) ??
                          const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cardData.description,
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
        ],
      ),
    );
  }
}
