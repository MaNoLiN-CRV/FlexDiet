import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/services/admin_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimalist Bottom Nav',
      theme: Theme.of(context),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  bool _isInitialized = false;

  final List<Widget> _widgetOptions = <Widget>[
    const Center(child: Text('Calendar')),
    const Center(child: Text('Home')),
    const Center(child: Text('Settings')),
    const Center(child: Text('Admin')),
  ];

  @override
  void initState() {
    super.initState();
    _initializeIndex();
  }

  Future<void> _initializeIndex() async {
    final isAdmin = await AdminService().isUserAdmin();
    if (mounted) {
      setState(() {
        _selectedIndex =
            isAdmin ? 3 : 1; // 3 para admin, 1 para usuarios normales
        _isInitialized = true;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: const Text('Minimalist Navigation'),
        titleTextStyle: TextStyle(
          color: theme.iconTheme.color,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        centerTitle: true,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AdminService().isUserAdmin(),
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        final isAdmin = snapshot.data ?? false;

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a placeholder while waiting for the admin check
          return const SizedBox.shrink();
        }

        if (isAdmin) {
          // Admin navigation - Only two icons
          final adminIndex =
              selectedIndex == 3 ? 0 : 1; // Convert admin indices
          return CircleNavBar(
            activeIndex: adminIndex,
            onTap: (index) {
              // Convert local indices back to global
              if (index == 0) {
                onItemTapped(3); // Admin screen
              } else {
                onItemTapped(2); // Settings screen
              }
            },
            activeIcons: [
              Icon(Icons.admin_panel_settings_rounded,
                  color: theme.colorScheme.primary),
              Icon(Icons.settings_rounded, color: theme.colorScheme.primary),
            ],
            inactiveIcons: [
              Icon(Icons.admin_panel_settings_outlined,
                  color: theme.colorScheme.outline),
              Icon(Icons.settings_outlined, color: theme.colorScheme.outline),
            ],
            color: theme.colorScheme.surface,
            circleColor: theme.colorScheme.surface,
            height: 60,
            circleWidth: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            cornerRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            shadowColor: theme.colorScheme.shadow.withOpacity(0.2),
            circleShadowColor: theme.colorScheme.shadow.withOpacity(0.2),
            elevation: 8,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.colorScheme.surface, theme.colorScheme.surface],
            ),
            circleGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.colorScheme.surface, theme.colorScheme.surface],
            ),
          );
        }

        // Regular user navigation - Three icons
        return CircleNavBar(
          activeIndex: selectedIndex,
          onTap: onItemTapped,
          activeIcons: [
            Icon(Icons.calendar_month, color: theme.colorScheme.primary),
            Icon(Icons.home_rounded, color: theme.colorScheme.primary),
            Icon(Icons.settings_rounded, color: theme.colorScheme.primary),
          ],
          inactiveIcons: [
            Icon(Icons.calendar_month_outlined,
                color: theme.colorScheme.outline),
            Icon(Icons.home_outlined, color: theme.colorScheme.outline),
            Icon(Icons.settings_outlined, color: theme.colorScheme.outline),
          ],
          color: theme.colorScheme.surface,
          circleColor: theme.colorScheme.surface,
          height: 60,
          circleWidth: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          cornerRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
          shadowColor: theme.colorScheme.shadow.withOpacity(0.2),
          circleShadowColor: theme.colorScheme.shadow.withOpacity(0.2),
          elevation: 8,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
          circleGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
        );
      },
    );
  }
}
