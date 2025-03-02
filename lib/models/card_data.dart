import 'package:flutter/material.dart';

class CardData {
  final String title;
  final String? description;
  final String? imageUrl;
  final IconData? icon;

  CardData({
    required this.title,
    this.description,
    this.imageUrl,
    this.icon,
  }) : assert(
          imageUrl != null || icon != null,
          'Either imageUrl or icon must be provided',
        );

  /// Factory constructor for image-based cards
  factory CardData.withImage({
    required String title,
    String? description,
    required String imageUrl,
  }) {
    return CardData(
      title: title,
      description: description,
      imageUrl: imageUrl,
    );
  }

  /// Factory constructor for icon-based cards
  factory CardData.withIcon({
    required String title,
    String? description,
    required IconData icon,
  }) {
    return CardData(
      title: title,
      description: description,
      icon: icon,
    );
  }

  /// Check if the card should display an icon
  bool get hasIcon => icon != null;

  /// Check if the card should display an image
  bool get hasImage => imageUrl != null;
}
