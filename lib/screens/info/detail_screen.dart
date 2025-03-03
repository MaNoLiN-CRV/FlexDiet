import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String? image;
  final String kcal;
  final String proteins;
  final String carbs;
  final String ingredients;

  const DetailsScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.image,
    required this.kcal,
    required this.proteins,
    required this.carbs,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(theme),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de macros principal
            _buildCardMacros(theme),
            // Imagen del plato
            _buildImageContainer(image),
            // Detalles de la comida
            _buildPrincipalContainer(theme, subtitle, description, kcal,
                proteins, carbs, ingredients),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCardMacros(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMacroInfo('Calorías', kcal),
          _buildMacroInfo('Proteínas', proteins),
          _buildMacroInfo('Carbohidratos', carbs),
        ],
      ),
    );
  }

  Widget _buildMacroInfo(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer(String? image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: image != null && image.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Icon(
                Icons.restaurant,
                size: 100,
                color: Colors.grey[400],
              ),
            ),
    );
  }

  Widget _buildPrincipalContainer(
      ThemeData theme,
      String subtitle,
      String description,
      String kcal,
      String proteins,
      String carbs,
      String ingredients) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          shadowColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'Ingredientes',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(ingredients.isNotEmpty ? ingredients : 'Sin ingredientes'),
                const SizedBox(height: 12),
                Text(
                  '\n\nRecuerda que estos valores son aproximados y pueden variar según los ingredientes y las porciones.',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
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
