import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/card_data.dart';
import 'package:flutter_flexdiet/models/client.dart';
import 'package:flutter_flexdiet/screens/admin/edit_person_screen.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_flexdiet/models/template.dart';
import 'package:flutter_flexdiet/models/user_diet.dart';

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
  List<Template> _templates = [];
  Template? _selectedTemplate;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadClient();
    _loadTemplates();
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

  Future<void> _loadTemplates() async {
    try {
      final snapshot = await Template.collection.get();
      if (mounted) {
        setState(() {
          _templates = snapshot.docs.map((doc) => doc.data()).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Error al cargar las plantillas',
            toastType: ToastType.error);
      }
    }
  }

  Future<void> _assignTemplateToUser(Template template) async {
    try {
      final userDiet = UserDiet(
        id: UniqueKey().toString(),
        templateId: template.id,
        completedMealIds: [],
      );

      bool isUserDietCreated = await UserDiet.createUserDiet(userDiet);

      if (isUserDietCreated && _client != null) {
        final updatedClient = Client(
          id: _client!.id,
          username: _client!.username,
          email: _client!.email,
          userDietId: userDiet.id,
          sex: _client!.sex,
          bodyweight: _client!.bodyweight,
          height: _client!.height,
          description: _client!.description,
        );

        bool isClientUpdated = await Client.updateClient(updatedClient);

        if (isClientUpdated && mounted) {
          setState(() {
            _selectedTemplate = template;
          });
          showToast(context, 'Plantilla asignada correctamente',
              toastType: ToastType.success);
        }
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Error al asignar la plantilla',
            toastType: ToastType.error);
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
    if (_templates.isEmpty) {
      return Center(
        child: Text(
          'No hay plantillas disponibles',
          style: theme.textTheme.titleLarge,
        ),
      );
    }

    return Column(
      children: [
        if (_selectedTemplate != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getTemplateIcon(_selectedTemplate!.type),
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Plantilla seleccionada: ${_selectedTemplate!.name}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(
          height: height * 0.7,
          child: CardScroll(
            cards: _templates
                .map((template) => CardData(
                      title: template.name,
                      description: template.description,
                      icon: _getTemplateIcon(template.type),
                    ))
                .toList(),
            onCardTap: (index) => _assignTemplateToUser(_templates[index]),
            scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }

  IconData _getTemplateIcon(String type) {
    switch (type) {
      case 'weight_loss':
        return Icons.fitness_center;
      case 'muscle_gain':
        return Icons.sports_gymnastics;
      case 'athlete':
        return Icons.running_with_errors;
      default:
        return Icons.restaurant;
    }
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
