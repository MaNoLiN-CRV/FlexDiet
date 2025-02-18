import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/screens/login/login_screen.dart';
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          'Ajustes',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Mi Perfil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: 2,
        onItemTapped: (index) => navigationRouter(context, index),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _UsernameInfoSettings(theme: theme),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _CardLogic(
                    text: 'Selecciona un tema:',
                    list: ['Claro', 'Oscuro'],
                    value: themeProvider.currentThemeName,
                    onChange: (value) {
                      themeProvider.setTheme(value!);
                    },
                    themeProvider: themeProvider,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  _CardLogic(
                    text: 'Tamaño de la fuente:',
                    list: ['Pequeña', 'Mediana', 'Grande'],
                    value: themeProvider.currentFontSize,
                    onChange: (value) {
                      themeProvider.setFontSize(value);
                    },
                    themeProvider: themeProvider,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  _ElevatedButtonSettings(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsernameInfoSettings extends StatelessWidget {
  const _UsernameInfoSettings({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue.withAlpha(128),
                width: 4,
              ),
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey[200],
              backgroundImage: const NetworkImage(
                  'https://static.vecteezy.com/system/resources/previews/030/750/807/non_2x/user-icon-in-trendy-outline-style-isolated-on-white-background-user-silhouette-symbol-for-your-website-design-logo-app-ui-illustration-eps10-free-vector.jpg'),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Username Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text('Edit Profile', style: theme.textTheme.labelLarge),
            ],
          ),
        ],
      ),
    );
  }
}

class _ElevatedButtonSettings extends StatelessWidget {
  const _ElevatedButtonSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Make the function async
        // Get an instance of SharedPreferences
        SharedPreferences prefs =
            await SharedPreferences.getInstance();
    
        // Clear all stored data
        await prefs.clear();
    
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 15),
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 3,
      ),
      child: const Text('Cerrar Sesión'),
    );
  }
}

class _CardLogic extends StatelessWidget {
  const _CardLogic({
    super.key,
    required this.text,
    required this.list,
    required this.value, 
    required this.onChange,
    required this.themeProvider,
    required this.theme,
  });

  final ThemeProvider themeProvider;
  final ThemeData theme;
  final String text;
  final List<dynamic> list;
  final String value;
  final void Function(dynamic) onChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(text,
                      style: theme.textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                child: CustomDropdownButton(
                  value: value,
                  onChange: onChange,
                  list: list,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
