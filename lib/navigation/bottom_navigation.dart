import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
    Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    Center(child: Text('Favorites', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: const Text('Minimalist Navigation'),
        titleTextStyle: TextStyle(color: theme.iconTheme.color, fontWeight: FontWeight.bold, fontSize: 20),
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
  final ValueChanged<int> onItemTapped;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return CircleNavBar(
      activeIndex: selectedIndex,
      onTap: onItemTapped,
      activeIcons: [
        Icon(Icons.person_outline_rounded, color: theme.iconTheme.color),
        Icon(Icons.home_rounded, color: theme.iconTheme.color),
        Icon(Icons.settings_rounded, color: theme.iconTheme.color),
      ],
      inactiveIcons: const [
        Icon(Icons.person_outline_rounded, color: Colors.grey),
        Icon(Icons.home_rounded, color: Colors.grey),
        Icon(Icons.settings_rounded, color: Colors.grey),
      ],
      color: Colors.white,
      circleColor: Colors.white,
      height: 60,
      circleWidth: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      cornerRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(24),
        bottomLeft: Radius.circular(24),
      ),
      shadowColor: Colors.black26,
      circleShadowColor: Colors.white,
      elevation: 8,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [theme.colorScheme.surface, theme.colorScheme.surface],
      ),
      circleGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Colors.white],
      ),
    );
  }
}
