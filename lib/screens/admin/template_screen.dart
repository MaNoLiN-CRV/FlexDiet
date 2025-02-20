import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UIConstants {
  static const double defaultPadding = 24.0;
  static const double defaultSpacing = 16.0;
  static const double cardHeight = 0.27;
  static const double buttonHeight = 14.0;
  static const double borderRadius = 12.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: defaultPadding,
    vertical: defaultPadding,
  );

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    vertical: buttonHeight,
  );
}

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

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  String? _selectedClientName;
  final TextEditingController _searchController = TextEditingController();
  final List<Client> _clients = [
    Client(
      name: 'Snoop Dogg',
      description:
          'Cliente con rutina de ganar peso, entrena dos dias a la semana.',
      imageUrl:
          'https://allhiphop.com/wp-content/uploads/2022/11/Snoop-Dogg.jpg',
    ),
    Client(
      name: 'Eminem',
      description: 'Atleta, y fisicoculturista',
      imageUrl: 'https://cdn.britannica.com/63/136263-050-7FBFFBD1/Eminem.jpg',
    ),
    Client(
      name: 'Ice Cube',
      description: 'Rutina para perder peso',
      imageUrl:
          'https://heavy.com/wp-content/uploads/2017/02/gettyimages-615695594.jpg?quality=65&strip=all',
    ),
    Client(
      name: 'Juice WRLD',
      description: 'Rutina de ciclismo',
      imageUrl:
          'https://www.thefamouspeople.com/profiles/images/juice-wrld-1.jpg',
    ),
  ];

  late List<Client> _filteredClients;

  @override
  void initState() {
    super.initState();
    _filteredClients = List.from(_clients);
  }

  void _selectClient(String clientName) {
    setState(() => _selectedClientName = clientName);
  }

  void _filterClients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClients = List.from(_clients);
      } else {
        final lowercaseQuery = query.toLowerCase();
        _filteredClients = _clients.where((client) {
          return client.name.toLowerCase().contains(lowercaseQuery) ||
              client.description.toLowerCase().contains(lowercaseQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context),
      bottomNavigationBar: BottomNav(
        selectedIndex: 3,
        onItemTapped: (index) => navigationRouter(context, index),
      ),
      body: Stack(
        children: [
          _buildWaveBackgrounds(theme),
          Padding(
            padding: UIConstants.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0),
                SizedBox(height: UIConstants.defaultSpacing),
                _buildSearchField(context)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                SizedBox(height: UIConstants.defaultSpacing),
                _buildClientsList(context)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideX(begin: 0.2, end: 0),
                _buildActionButtons(context)
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms)
                    .scale(
                        begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      title: const Text('Panel de administrador'),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      elevation: 0,
      iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Selecciona un cliente',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _searchController,
      onChanged: _filterClients,
      decoration: InputDecoration(
        hintText: 'Buscar cliente...',
        prefixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.primary.withAlpha(153),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.3,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultPadding,
          vertical: UIConstants.buttonHeight,
        ),
      ),
      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildClientsList(BuildContext context) {
    if (_filteredClients.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron clientes',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * UIConstants.cardHeight + 16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filteredClients.length,
        itemBuilder: (context, index) {
          final client = _filteredClients[index];
          final isSelected = client.name == _selectedClientName;

          return AnimatedContainer(
            padding: const EdgeInsets.all(8),
            duration: const Duration(milliseconds: 200),
            width: 280,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            transform: isSelected
                ? (Matrix4.identity()..scale(1.05))
                : Matrix4.identity(),
            child: Card(
              elevation: isSelected ? 8 : 4,
              color: isSelected ? Theme.of(context).colorScheme.primary : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _selectClient(client.name),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        client.imageUrl,
                        height: 160,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 160,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 160,
                            color: Theme.of(context).colorScheme.primary,
                            child: Icon(
                              Icons.person,
                              size: 64,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : null,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                client.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: (100 * index).ms)
              .slideX(begin: 0.2, end: 0);
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: UIConstants.defaultSpacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildActionButton(
            context: context,
            title: 'CREAR PLANTILLA',
            onPressed: _selectedClientName != null
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateTemplateScreen()),
                    )
                : null,
            isSecondary: true,
          ),
          const SizedBox(height: UIConstants.defaultSpacing),
          _buildActionButton(
            context: context,
            title: 'USAR PLANTILLA EXISTENTE',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UseTemplateScreen()),
            ),
          ),
          const SizedBox(height: UIConstants.defaultSpacing),
          _buildActionButton(
            context: context,
            title: 'EDITAR CLIENTE',
            onPressed: _selectedClientName != null
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditPerson(name: _selectedClientName!),
                      ),
                    )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required VoidCallback? onPressed,
    bool isSecondary = false,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary
            ? theme.colorScheme.secondary
            : theme.colorScheme.primary,
        foregroundColor: isSecondary
            ? theme.colorScheme.onSecondary
            : theme.colorScheme.onPrimary,
        padding: UIConstants.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        ),
        elevation: 2,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isSecondary
              ? theme.colorScheme.onSecondary
              : theme.colorScheme.onPrimary,
        ),
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(
          duration: 2000.ms,
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
        );
  }

  Widget _buildWaveBackgrounds(ThemeData theme) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: WaveBackground(
          color: theme.colorScheme.primary,
          frequency: 0.5,
          phase: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
