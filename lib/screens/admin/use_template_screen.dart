import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class UseTemplateScreen extends StatelessWidget {
  static const double _standardPadding = 16.0;
  static const double _cardSpacing = 20.0;

  const UseTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(theme),
      body: Stack(
        children: [
          _buildWaveBackgrounds(theme),
          _buildMainContent(context, theme, height),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      elevation: 0,
      title: Text(
        'Plantillas de Dieta',
        style: theme.appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
    );
  }

  Widget _buildWaveBackgrounds(ThemeData theme) {
    return Stack(
      children: [
        Positioned.fill(
          top: 50,
          child: RepaintBoundary(
            child: WaveBackground(
              color: theme.colorScheme.primary.withOpacity(0.7),
              frequency: 0.5,
              phase: 1,
            ),
          ),
        ),
        Positioned.fill(
          top: 250,
          child: RepaintBoundary(
            child: WaveBackground(
              color: theme.colorScheme.secondary.withOpacity(0.5),
              frequency: 0.3,
              phase: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(
      BuildContext context, ThemeData theme, double height) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(_standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: _cardSpacing),
            _buildTemplateCards(context, theme, height),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escoge tu Plan',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona la plantilla que mejor se adapte a tus objetivos',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateCards(
      BuildContext context, ThemeData theme, double height) {
    return SizedBox(
      height: height * 0.7,
      child: CardScroll(
        cards: [
          CardData(
            title: 'PLANTILLA PARA MUJERES - PERDER PESO',
            description:
                'Dieta de 2000kcal para mujeres que desean perder peso de manera saludable. Incluye un perfil nutricional equilibrado y recetas enfocadas en tus objetivos.',
            imageUrl:
                'https://images.unsplash.com/photo-1607178743429-f34aa08f784d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHwxfHxkaWV0JTIwd29tYW58ZW58MHx8fHwxNzA3NjY3NzYxfDA&ixlib=rb-4.0.3&q=80&w=200',
          ),
          CardData(
            title: 'DIETA PARA GANAR MASA MUSCULAR',
            description:
                'Plan de comidas de 3500kcal optimizado para el crecimiento muscular. Rico en proteInas y carbohidratos complejos para apoyar tus entrenamientos y recuperacion muscular.',
            imageUrl:
                'https://images.unsplash.com/photo-1556771512-9804c2c7482f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHw2fHxidWxrJTIwbXVzY2xlfGVufDB8fHx8MTcwNzY2NzgyOXww&ixlib=rb-4.0.3&q=80&w=200',
          ),
          CardData(
            title: 'DIETA PARA DEPORTISTAS',
            description:
                'Dieta equilibrada de 2500kcal para deportistas que desean mantener un rendimiento optimo. Proporciona la energia y nutrientes necesarios para entrenamientos intensivos y competitivos.',
            imageUrl:
                'https://images.unsplash.com/photo-1554999212-c68ed64f0a51?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjQwNzZ8MHwxfHNlYXJjaHwxfHNsYWxhZCUyMGF0aGxldGV8ZW58MHx8fHwxNzA3NjY3ODc3fDA&ixlib=rb-4.0.3&q=80&w=200',
          ),
        ],
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
