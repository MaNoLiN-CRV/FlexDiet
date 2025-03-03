import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/models/final_models/client.dart';
import 'package:flutter_flexdiet/models/ui_constants.dart';
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
  String? _selectedClientId;
  final TextEditingController _searchController = TextEditingController();
  List<Client> _clients = [];
  List<Client> _filteredClients = [];
  bool _isLoading = true;
  final ValueNotifier<List<Client>> _clientsNotifier =
      ValueNotifier<List<Client>>([]);

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    setState(() => _isLoading = true);
    print("_loadClients started");
    try {
      final snapshot = await Client.collection.get();
      List<Client> loadedClients =
          snapshot.docs.map((doc) => doc.data()).toList();
      _clientsNotifier.value = loadedClients;
      _clients = loadedClients;
      _filteredClients = List.from(_clients);
      _isLoading = false;
      print("_loadClients setState called");
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        showToast(context, 'Error al cargar los clientes',
            toastType: ToastType.error);
      }
    }
    print("_loadClients finished");
  }

  void _selectClient(String clientId) {
    setState(() => _selectedClientId = clientId);
  }

  void _filterClients(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClients = List.from(_clients);
      } else {
        final lowercaseQuery = query.toLowerCase();
        _filteredClients = _clients.where((client) {
          return client.username.toLowerCase().contains(lowercaseQuery) ||
              (client.description?.toLowerCase().contains(lowercaseQuery) ??
                  false);
        }).toList();
      }
    });
  }

  Future<void> _refreshClients() async {
    print("_refreshClients called");
    await _loadClients();
    final snapshot = await Client.collection.get();
    List<Client> loadedClients =
        snapshot.docs.map((doc) => doc.data()).toList();
    _clientsNotifier.value = loadedClients;
    print("_refreshClients finished");
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
                    _filteredClients = List.from(clients);
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
                    return Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.33,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filteredClients.length,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemBuilder: (context, index) {
                              final client = _filteredClients[index];
                              final isSelected = client.id == _selectedClientId;

                              return buildClientCard(
                                  client, isSelected, context, isDarkMode);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
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

  Widget buildClientCard(
      Client client, bool isSelected, BuildContext context, bool isDarkMode) {
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
          onTap: () => _selectClient(client.id),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  // Added ClipRRect
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: client.image != null && client.image!.isNotEmpty
                        ? Image(
                            image: NetworkImage(client.image!),
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
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
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
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

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: UIConstants.defaultSpacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildActionButton(
            context: context,
            title: 'CREAR PLANTILLA',
            onPressed: _selectedClientId != null
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateTemplateScreen(
                                clientID: _selectedClientId!,
                              )),
                    )
                : null,
            isSecondary: true,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: UIConstants.defaultSpacing),
          _buildActionButton(
            context: context,
            title: 'USAR PLANTILLA EXISTENTE',
            onPressed: _selectedClientId != null
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UseTemplateScreen(
                          clientId: _selectedClientId!,
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
            onPressed: _selectedClientId != null
                ? () async {
                    final localContext = context;
                    if (localContext.mounted) {
                      final result = await Navigator.push(
                        localContext,
                        MaterialPageRoute(
                          builder: (context) => EditPerson(
                            clientId: _selectedClientId!,
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

  @override
  void dispose() {
    _searchController.dispose();
    _clientsNotifier.dispose();
    super.dispose();
  }
}
