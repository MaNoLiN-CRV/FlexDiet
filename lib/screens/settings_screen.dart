import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/navigation/bottom_navigation.dart';
import 'package:flutter_flexdiet/navigation/navigation_router.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

//* En esta pantalla se encuentra opciones de configuración de la propia aplicación. La pantalla debe ser Stateful porque 
//* necesitamos usar setState para cambiar el CustomDropDownButton
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Valores que puede tomar el desplegable
  String _selectedTheme = 'Claro';
  String _selectedFontSize = 'Pequeña';

  @override
  Widget build(BuildContext context) {
    // Recuperamos el tema de la aplicación
    final theme = Theme.of(context);
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
      // El tabBar de nuestra aplicación
      bottomNavigationBar: BottomNav(
        selectedIndex: 2,
        onItemTapped: (index) => navigationRouter(context, index),
      ),
      // Utilizamos SingleChildScrollView para evitar desbordamiento
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
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
                      // Cambiado: usando CircleAvatar directamente
                      radius: 45,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(
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
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
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
                                Text(
                                  'Selecciona un tema:',
                                  style: theme.textTheme.bodyLarge
                                ),
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
                                value: _selectedTheme,
                                onChange: (value) {
                                  setState(() {
                                    _selectedTheme = value!;
                                  });
                                },
                                list: ['Claro', 'Oscuro'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
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
                                Text(
                                  'Selecciona un tema:',
                                  style: theme.textTheme.bodyLarge
                                ),
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
                                value: _selectedFontSize,
                                onChange: (value) {
                                  setState(() {
                                    _selectedFontSize = value!;
                                  });
                                },
                                list: ['Pequeña', 'Mediana', 'Grande'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
