import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/models.dart';

class CardScroll extends StatelessWidget {
  final List<CardData> cards;
  final Axis scrollDirection;
  final void Function(int index)? onCardTap;
  final String? selectedCard;

  const CardScroll({
    super.key,
    required this.cards,
    this.scrollDirection = Axis.horizontal,
    this.onCardTap,
    this.selectedCard,
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
          isSelected: cards[index].title == selectedCard,
        );
      },
    );
  }
}

class CardItem extends StatelessWidget {
  final CardData cardData;
  final VoidCallback? onTap;
  final bool isSelected;

  const CardItem({
    super.key,
    required this.cardData,
    this.onTap,
    this.isSelected = false,
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
        color: isSelected ? theme.colorScheme.secondary : null,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  cardData.imageUrl,
                  height: 120,
                  width: double.infinity,
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
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/logo.png',
                      height: 120,
                      width: double.infinity,
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
                        color:
                            isSelected ? theme.colorScheme.onSecondary : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (cardData.description != null)
                      Text(
                        cardData.description!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.onSecondary
                              : theme.textTheme.bodyMedium?.color,
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
