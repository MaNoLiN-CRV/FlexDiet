import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flexdiet/theme/theme.dart';

class WeightSelectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final double? selectedValue;
  final void Function(double?)? onChanged;

  const WeightSelectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.selectedValue,
    this.onChanged,
  });

  @override
  State<WeightSelectionCard> createState() => _WeightSelectionCardState();
}

class _WeightSelectionCardState extends State<WeightSelectionCard> {
  double _sliderValue = 50.0;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.selectedValue ??
        50.0; // Initialize with selectedValue or default 50.0
  }

  @override
  void didUpdateWidget(covariant WeightSelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {
        _sliderValue = widget.selectedValue ?? 50.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor =
        isDarkMode ? Colors.grey.shade800 : Colors.white;
    final Color selectedColor = isDarkMode ? textLightBlue : Colors.black;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: selectedColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, size: 36, color: selectedColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              Text(
                '${_sliderValue.toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          Slider(
            value: _sliderValue,
            min: 30.0,
            max: 200.0,
            divisions: 170,
            label: '${_sliderValue.round()} kg',
            activeColor: selectedColor,
            inactiveColor: Colors.grey,
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
              widget.onChanged?.call(value);
            },
          ),
        ],
      ),
    ).animate().scale(
          duration: const Duration(milliseconds: 200),
          begin: const Offset(1, 1),
          end: const Offset(1.02, 1.02),
        );
  }
}
