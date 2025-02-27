import 'package:flutter_flexdiet/models/models.dart';

class Client {
  final String name;
  final String description;
  final String imageUrl;

  const Client({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
  
  CardData toCardData() => CardData(
        title: name,
        description: description,
        imageUrl: imageUrl,
      );
}
