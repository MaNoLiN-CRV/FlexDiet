import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/models.dart';
import 'package:flutter_flexdiet/navigation/navigation.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context, isDarkMode),
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
                _buildHeader(context, isDarkMode)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0),
                SizedBox(height: UIConstants.defaultSpacing),
                _buildSearchField(context, isDarkMode)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                SizedBox(height: UIConstants.defaultSpacing),
                _buildClientsList(context, isDarkMode)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideX(begin: 0.2, end: 0),
                _buildActionButtons(context, isDarkMode)
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

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
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

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    final textColor = isDarkMode
        ? Colors.white
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Text(
      'Selecciona un cliente',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSearchField(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    final iconColor = isDarkMode
        ? Colors.white70
        : theme.colorScheme.onSurfaceVariant.withAlpha(153);
    return TextField(
      controller: _searchController,
      onChanged: _filterClients,
      decoration: InputDecoration(
        hintText: 'Buscar cliente...',
        prefixIcon: Icon(
          Icons.search,
          color: iconColor,
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

  Widget _buildClientsList(BuildContext context, bool isDarkMode) {
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

    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * UIConstants.cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filteredClients.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final client = _filteredClients[index];
              final isSelected = client.name == _selectedClientName;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 280,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                transform: isSelected
                    ? (Matrix4.identity()..scale(1.04))
                    : Matrix4.identity(),
                child: Card(
                  elevation: isSelected ? 8 : 4,
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => _selectClient(client.name),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              client.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Theme.of(context).colorScheme.primary,
                                  child: Icon(
                                    Icons.person,
                                    size: 64,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                );
                              },
                            ),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                                  .onPrimary
                                              : isDarkMode
                                                  ? Colors.white
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
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
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
            isDarkMode: isDarkMode,
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
            isDarkMode: isDarkMode,
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
            isDarkMode: isDarkMode,
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
    required bool isDarkMode,
  }) {
    final theme = Theme.of(context);
    final buttonColor = isSecondary
        ? (isDarkMode ? Colors.grey.shade800 : theme.colorScheme.secondary)
        : theme.colorScheme.primary;
    final textColor = isSecondary
        ? (isDarkMode ? Colors.white : theme.colorScheme.onSecondary)
        : theme.colorScheme.onPrimary;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: textColor,
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
          color: textColor,
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
