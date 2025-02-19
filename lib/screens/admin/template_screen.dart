// Constants
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class UIConstants {
  static const double defaultPadding = 24.0;
  static const double defaultSpacing = 16.0;
  static const double cardHeight = 0.25;
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

// Models
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

// Screen
class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  String? _selectedClientName;
  final TextEditingController _searchController = TextEditingController();

  // Move sample data to a separate file in a real app
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      bottomNavigationBar: BottomNav(
        selectedIndex: 3,
        onItemTapped: (index) => navigationRouter(context, index),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: UIConstants.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              if (_selectedClientName != null)
                _buildSelectedClientBanner(context),
              _buildAvailableClientsSection(context),
              _buildSearchField(context),
              SizedBox(height: UIConstants.defaultSpacing),
              _buildClientsList(context),
              _buildActionButtons(context),
            ],
          ),
        ),
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
      'Selecciona un cliente para editar o asignar plantillas',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSelectedClientBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: UIConstants.defaultSpacing),
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.defaultPadding / 2,
        vertical: UIConstants.defaultSpacing / 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Cliente seleccionado: $_selectedClientName',
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAvailableClientsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.defaultSpacing),
      child: Text(
        'Clientes disponibles',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withOpacity(0.8),
              fontStyle: FontStyle.italic,
            ),
        textAlign: TextAlign.center,
      ),
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
          color: theme.colorScheme.primary.withOpacity(0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultPadding,
          vertical: UIConstants.buttonHeight,
        ),
      ),
      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget _buildClientsList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * UIConstants.cardHeight,
      child: CardScroll(
        scrollDirection: Axis.horizontal,
        cards: _filteredClients.map((client) => client.toCardData()).toList(),
        onCardTap: (index) {
          if (index >= 0 && index < _filteredClients.length) {
            _selectClient(_filteredClients[index].name);
          }
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
