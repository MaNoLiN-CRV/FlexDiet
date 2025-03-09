import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/client.dart';
import 'package:flutter_flexdiet/models/ui_constants.dart';
import 'package:flutter_flexdiet/navigation/navigation.dart';
import 'package:flutter_flexdiet/screens/admin/edit_templates.dart';
import 'package:flutter_flexdiet/screens/log_screen.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Client> _clients = [];
  bool _isLoading = true;
  Timer? _debounce;

  final ValueNotifier<String?> _selectedClientIdNotifier =
      ValueNotifier<String?>(null);

  final ValueNotifier<List<Client>> _clientsNotifier =
      ValueNotifier<List<Client>>([]);

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _clientsNotifier.dispose();
    _selectedClientIdNotifier.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadClients() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final snapshot = await Client.collection.get();
      List<Client> loadedClients =
          snapshot.docs.map((doc) => doc.data()).toList();

      if (mounted) {
        final String? currentSelectedClientId = _selectedClientIdNotifier.value;

        _clientsNotifier.value = loadedClients;
        _clients = loadedClients;

        if (currentSelectedClientId != null &&
            loadedClients
                .any((client) => client.id == currentSelectedClientId)) {
          _selectedClientIdNotifier.value = currentSelectedClientId;
        }
        _isLoading = false;
        if (mounted) {
          await _preloadImages(loadedClients);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        if (mounted) {
          showToast(context, 'Error al cargar los clientes',
              toastType: ToastType.error);
        }
      }
    }
  }

  // Debounced filter clients function
  void _filterClientsDebounced(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterClients(query);
    });
  }

  void _filterClients(String query) {
    if (query.isEmpty) {
      if (mounted) {
        _clientsNotifier.value = List.from(_clients);
      }
    } else {
      final lowercaseQuery = query.toLowerCase();
      if (mounted) {
        _clientsNotifier.value = _clients.where((client) {
          return client.username.toLowerCase().contains(lowercaseQuery) ||
              (client.description?.toLowerCase().contains(lowercaseQuery) ??
                  false);
        }).toList();
      }
    }
  }

  // Preload Images
  Future<void> _preloadImages(List<Client> clients) async {
    if (!mounted) return;
    for (final client in clients) {
      if (client.image != null && client.image!.isNotEmpty) {
        try {
          await precacheImage(NetworkImage(client.image!), context);
        } catch (e) {
          print('Error preloading image for client ${client.id}: $e');
        }
      }
    }
  }

  // Update select client to be async
  void _selectClient(String clientId) async {
    if (mounted) {
      _selectedClientIdNotifier.value = clientId;
    }
  }

  Future<void> _refreshClients() async {
    if (!mounted) return;
    await _loadClients();
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
                ValueListenableBuilder<List<Client>>(
                  valueListenable: _clientsNotifier,
                  builder: (context, clients, child) {
                    if (_isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (clients.isEmpty) {
                      return Center(
                        child: Text(
                          'No se encontraron clientes',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      );
                    }
                    return ClientListView(
                      clients: clients,
                      selectedClientIdNotifier: _selectedClientIdNotifier,
                      onClientSelected: _selectClient,
                      isDarkMode: isDarkMode,
                    );
                  },
                ),
                ValueListenableBuilder<String?>(
                  valueListenable: _selectedClientIdNotifier,
                  builder: (context, selectedClientId, child) {
                    return _buildActionButtons(
                        context, isDarkMode, selectedClientId);
                  },
                ),
                SizedBox(height: UIConstants.defaultSpacing),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: UIConstants.buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(UIConstants.borderRadius),
                    ),
                  ),
                  child: Text('Ver Historial de Solicitudes'),
                ),
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
      onChanged: _filterClientsDebounced,
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

  // Use a new _buildActionButtons that receives selectedClientId as argument
  Widget _buildActionButtons(
      BuildContext context, bool isDarkMode, String? selectedClientId) {
    return Padding(
      padding: const EdgeInsets.only(top: UIConstants.defaultSpacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildActionButton(
            context: context,
            title: 'CREAR PLANTILLA',
            onPressed: selectedClientId != null
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTemplateScreen(
                          clientID: selectedClientId,
                        ),
                      ),
                    )
                : null,
            isSecondary: true,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: UIConstants.defaultSpacing),
          _buildActionButton(
            context: context,
            title: 'USAR PLANTILLA EXISTENTE',
            onPressed: selectedClientId != null
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UseTemplateScreen(
                          clientId: selectedClientId,
                        ),
                      ),
                    )
                : null,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: UIConstants.defaultSpacing),
          _buildActionButton(
            context: context,
            title: 'EDITAR CLIENTE',
            onPressed: selectedClientId != null
                ? () async {
                    final localContext = context;
                    if (localContext.mounted) {
                      final result = await Navigator.push(
                        localContext,
                        MaterialPageRoute(
                          builder: (context) => EditPerson(
                            clientId: selectedClientId,
                          ),
                        ),
                      );

                      if (localContext.mounted &&
                          result != null &&
                          result == true) {
                        await _refreshClients();
                      }
                    }
                  }
                : null,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: UIConstants.defaultSpacing),
          _buildActionButton(
            context: context,
            title: 'EDITAR PLANTILLAS',
            onPressed: selectedClientId != null
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTemplatesScreen(),
                      ),
                    )
                : null,
            isSecondary: true,
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
        ? (isDarkMode ? theme.colorScheme.primary : theme.colorScheme.secondary)
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
        style: theme.textTheme.bodyLarge?.copyWith(
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
}

class ClientListView extends StatelessWidget {
  final List<Client> clients;
  final ValueNotifier<String?> selectedClientIdNotifier;
  final Function(String) onClientSelected;
  final bool isDarkMode;

  const ClientListView({
    Key? key,
    required this.clients,
    required this.selectedClientIdNotifier,
    required this.onClientSelected,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: clients.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final client = clients[index];
              return ValueListenableBuilder<String?>(
                valueListenable: selectedClientIdNotifier,
                builder: (context, selectedClientId, child) {
                  final isSelected = client.id == selectedClientId;
                  return buildClientCard(client, isSelected, context,
                      isDarkMode, onClientSelected);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget buildClientCard(Client client, bool isSelected, BuildContext context,
    bool isDarkMode, Function(String) onClientSelected) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: 220,
    margin: const EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
    transform:
        isSelected ? (Matrix4.identity()..scale(1.05)) : Matrix4.identity(),
    child: Card(
      elevation: isSelected ? 8 : 4,
      color: isSelected ? Theme.of(context).colorScheme.primary : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onClientSelected(client.id),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: client.image != null && client.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: client.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 48,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.username,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : null,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (client.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        client.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : isDarkMode
                                      ? Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        if (client.bodyweight != null)
                          _buildClientInfo(
                            context,
                            '${client.bodyweight!}kg',
                            Icons.monitor_weight,
                            isSelected,
                            isDarkMode,
                          ),
                        if (client.height != null) ...[
                          const SizedBox(width: 8),
                          _buildClientInfo(
                            context,
                            '${client.height!}cm',
                            Icons.height,
                            isSelected,
                            isDarkMode,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, end: 0);
}

Widget _buildClientInfo(
  BuildContext context,
  String text,
  IconData icon,
  bool isSelected,
  bool isDarkMode,
) {
  Color textColor;
  Color iconColor;

  if (isSelected) {
    textColor = Theme.of(context).colorScheme.onPrimary;
    iconColor = Theme.of(context).colorScheme.onPrimary;
  } else {
    textColor = isDarkMode
        ? Theme.of(context).colorScheme.secondaryContainer
        : Theme.of(context).colorScheme.onSurfaceVariant;
    iconColor = isDarkMode
        ? Theme.of(context).colorScheme.secondaryContainer
        : Theme.of(context).colorScheme.primary;
  }

  return Row(
    children: [
      Icon(
        icon,
        size: 14,
        color: iconColor,
      ),
      const SizedBox(width: 2),
      Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
            ),
      ),
    ],
  );
}
