import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/navigation.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/image_service/image_service.dart';
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: 2,
        onItemTapped: (index) => navigationRouter(context, index),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        value: themeProvider.currentThemeName,
                        onChange: (value) {
                          themeProvider.setTheme(value);
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
          Positioned(
            right: 16,
            bottom: 20,
            child: Hero(
              tag: 'profile-hero',
              child: Material(
                elevation: 8,
                shadowColor:
                    Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserInfoScreen())),
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
        ],
      ),
    );
  }
}

class _UsernameInfoSettings extends StatefulWidget {
  const _UsernameInfoSettings({required this.theme});

  final ThemeData theme;

  @override
  State<_UsernameInfoSettings> createState() => _UsernameInfoSettingsState();
}

class _UsernameInfoSettingsState extends State<_UsernameInfoSettings> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  XFile? _imagenSeleccionada;
  late String _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userName = user?.displayName ?? user?.email ?? 'Nombre de Usuario';
    });
  }

  @override
  Widget build(BuildContext context) {
    void _seleccionarImagenDeGaleria() async {
      final XFile? imagen = await _imagePickerService.seleccionarImagen(
          context, ImageSource.gallery);
      if (imagen != null) {
        setState(() {
          _imagenSeleccionada = imagen;
        });
      } else {
        if (context.mounted) {
          showToast(context, "No se seleccionó ninguna imagen",
              toastType: ToastType.warning);
        }
      }
    }

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
                backgroundImage: _imagenSeleccionada != null
                    ? FileImage(File(_imagenSeleccionada!.path))
                    : null),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                ElevatedButton(
                  onPressed: _seleccionarImagenDeGaleria,
                  child: Text('Establecer Imagen de Perfil',
                      style: ThemeProvider()
                          .themeData
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: ThemeData().colorScheme.onPrimary)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ElevatedButtonSettings extends StatelessWidget {
  const _ElevatedButtonSettings();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();

        if (context.mounted) {
          Navigator.pushReplacement(
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                  Text(text, style: theme.textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
