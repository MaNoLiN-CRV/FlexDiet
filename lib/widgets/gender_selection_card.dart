import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flexdiet/theme/theme.dart';

class GenderSelectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String value;
  final String? selectedValue;
  final void Function(String?)? onChanged;

  const GenderSelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    this.selectedValue,
    this.onChanged,
  });

  @override
  State<GenderSelectionCard> createState() => _GenderSelectionCardState();
}

class _GenderSelectionCardState extends State<GenderSelectionCard> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.selectedValue == widget.value;
  }

  @override
  void didUpdateWidget(covariant GenderSelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {
        _isSelected = widget.selectedValue == widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final Color backgroundColor =
        isDarkMode ? Colors.grey.shade800 : Colors.white;
    final Color selectedColor =
        isDarkMode ? textLightBlue : theme.colorScheme.secondary;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        widget.onChanged?.call(widget.value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isSelected ? selectedColor : Colors.grey.shade400,
            width: 2,
          ),
          boxShadow: [
            if (_isSelected)
              BoxShadow(
                color: selectedColor.withValues(
                  alpha: 0.3,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(widget.icon,
                size: 36, color: _isSelected ? selectedColor : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(target: _isSelected ? 1 : 0).scale(
        duration: const Duration(milliseconds: 200),
        begin: const Offset(1, 1),
        end: const Offset(1.02, 1.02));
  }
}
