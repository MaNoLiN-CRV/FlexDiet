import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget { // Cambiado a StatefulWidget
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final String macros; 

  const DetailsScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.macros, 
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState(); // Método createState correcto
}

class _DetailsScreenState extends State<DetailsScreen> { // Clase State genérica con DetallesScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Acceder a las propiedades con widget.
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.image, // Acceder a las propiedades con widget.
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title, // Acceder a las propiedades con widget.
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle, // Acceder a las propiedades con widget.
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description, // Acceder a las propiedades con widget.
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text( 
                    widget.macros, // Acceder a las propiedades con widget.
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}