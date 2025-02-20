import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/admin/create/select_foods_screen.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class CreateTemplateScreen extends StatefulWidget {
  const CreateTemplateScreen({super.key});

  @override
  State<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends State<CreateTemplateScreen> {
  int dailyCalories = 2000;
  final List<String> daysOfWeek = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];
  Set<String> selectedDays = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Plantilla de Dieta'),
        backgroundColor: theme.colorScheme.primary,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildSectionTitle('Calorías Diarias', theme, isDarkMode),
                const SizedBox(height: 16),
                _buildCaloriesInput(theme, isDarkMode),
                const SizedBox(height: 40),
                _buildSectionTitle('Días de la Semana', theme, isDarkMode),
                const SizedBox(height: 20),
                _buildDaysSelection(theme, isDarkMode),
                const SizedBox(height: 48),
                _buildSaveButton(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme, bool isDarkMode) {
    // Use isDarkMode to determine colors
    final titleColor = isDarkMode ? Colors.white : theme.colorScheme.primary;
    final borderColor = isDarkMode
        ? Colors.grey.shade700
        : theme.colorScheme.primary.withValues(alpha: 0.2);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: titleColor,
        ),
      ),
    );
  }

  Widget _buildCaloriesInput(ThemeData theme, bool isDarkMode) {
    final shadowColor = isDarkMode
        ? Colors.grey.shade900
        : theme.colorScheme.shadow.withValues(alpha: 0.1);
    final fillColor =
        isDarkMode ? Colors.grey.shade800 : theme.colorScheme.surface;
    final textColor =
        isDarkMode ? Colors.white : theme.textTheme.bodyLarge?.color;
    final hintColor = isDarkMode ? Colors.grey.shade500 : theme.hintColor;
    final iconColor = isDarkMode ? Colors.white70 : theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        style: theme.textTheme.bodyLarge
            ?.copyWith(fontWeight: FontWeight.w500, color: textColor),
        decoration: InputDecoration(
          hintText: 'Ej. 2000',
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: hintColor,
          ),
          prefixIcon: Icon(
            Icons.local_fire_department_rounded,
            color: iconColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
        ),
        onChanged: (value) {
          setState(() {
            dailyCalories = int.tryParse(value) ?? 2000;
          });
        },
        controller: TextEditingController(text: dailyCalories.toString()),
      ),
    );
  }

  Widget _buildDaysSelection(ThemeData theme, bool isDarkMode) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: daysOfWeek.map((day) {
        final isSelected = selectedDays.contains(day);

        final labelTextColor = isSelected
            ? theme.colorScheme.onPrimary
            : isDarkMode
                ? Colors.white
                : theme.colorScheme.onSurfaceVariant;

        final chipBackgroundColor = theme.colorScheme.surface;
        final selectedChipColor = theme.colorScheme.primary;

        return FilterChip(
          label: Text(
            day,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: labelTextColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedDays.add(day);
              } else {
                selectedDays.remove(day);
              }
            });
          },
          backgroundColor: chipBackgroundColor,
          selectedColor: selectedChipColor,
          checkmarkColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          elevation: 2,
          pressElevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(
                alpha: 0.3,
              ),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FilledButton(
          onPressed: () {
            if (selectedDays.isEmpty) {
              showToast(context, "Por favor, selecciona al menos un día.",
                  toastType: ToastType.warning);
              return;
            }
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SelectFoodsScreen(
                    selectedDays: selectedDays.toList(),
                    dailyCalories: dailyCalories),
              ),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            child: Text(
              'SIGUIENTE PASO',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
