import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/card_data.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_flexdiet/screens/admin/edit_person_screen.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class UseTemplateScreen extends StatefulWidget {
  final String clientId;
  static const double _standardPadding = 16.0;
  static const double _cardSpacing = 20.0;

  const UseTemplateScreen({
    super.key,
    required this.clientId,
  });

  @override
  State<UseTemplateScreen> createState() => _UseTemplateScreenState();
}

class _UseTemplateScreenState extends State<UseTemplateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  Client? _client;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadClient();
  }

  void _initializeAnimations() {
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    );
    _fabController.forward();
  }

  Future<void> _loadClient() async {
    try {
      final client = await Client.getClient(widget.clientId);
      if (mounted) {
        setState(() {
          _client = client;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al cargar el cliente'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _showProfileDialog(BuildContext context) async {
    if (_client == null) return;

    final theme = Theme.of(context);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
              ),
              child: Icon(
                Icons.person,
                size: 48,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _client!.username,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_client!.bodyweight != null) ...[
              const SizedBox(height: 8),
              Text(
                'Peso actual: ${_client!.bodyweight}kg',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPerson(clientId: _client!.id),
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text('Editar Perfil'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    if (_client == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Cliente no encontrado',
            style: theme.textTheme.titleLarge,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Plan para ${_client!.username}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildWaveBackgrounds(theme),
          _buildMainContent(context, theme, MediaQuery.of(context).size.height),
          _buildProfileButton(context),
        ],
      ),
    );
  }

  Widget _buildWaveBackgrounds(ThemeData theme) {
    return Stack(
      children: [
        Positioned.fill(
          top: 50,
          child: RepaintBoundary(
            child: WaveBackground(
              color: theme.colorScheme.primary.withValues(alpha: 0.7),
              frequency: 0.5,
              phase: 1,
            ),
          ),
        ),
        Positioned.fill(
          top: 250,
          child: RepaintBoundary(
            child: WaveBackground(
              color: theme.colorScheme.secondary.withValues(alpha: 0.5),
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
        padding: const EdgeInsets.fromLTRB(
          UseTemplateScreen._standardPadding,
          UseTemplateScreen._standardPadding,
          UseTemplateScreen._standardPadding,
          80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: UseTemplateScreen._cardSpacing),
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
          'Escoge el Plan',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona la plantilla que mejor se adapte a tu cliente',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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

  Widget _buildProfileButton(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 32,
      child: ScaleTransition(
        scale: _fabAnimation,
        child: Hero(
          tag: 'profile-hero',
          child: Material(
            elevation: 8,
            shadowColor:
                Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _showProfileDialog(context),
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
