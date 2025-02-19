import 'package:flutter/material.dart';

class CreateTemplateScreen extends StatefulWidget {
  const CreateTemplateScreen({super.key});

  @override
  State<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends State<CreateTemplateScreen> {
  int dailyCalories = 2000;
  List<String> daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Plantilla de Dieta'),
        backgroundColor: theme.colorScheme.primary,
        titleTextStyle: theme.textTheme.headlineSmall
            ?.copyWith(color: theme.colorScheme.onPrimary),
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Calorías Diarias',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Ej. 2000',
                hintStyle:
                    theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              ),
              onChanged: (value) {
                setState(() {
                  dailyCalories = int.tryParse(value) ?? 2000;
                });
              },
              controller: TextEditingController(text: dailyCalories.toString()),
            ),
            const SizedBox(height: 40),
            Text(
              'Días de la Semana',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: daysOfWeek
                  .map((day) => Chip(
                        label: Text(
                          day,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w500),
                        ),
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 48),
            Center(
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Plantilla guardada (funcionalidad no implementada)')),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  elevation: 0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  child: Text(
                    'Guardar Plantilla',
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
