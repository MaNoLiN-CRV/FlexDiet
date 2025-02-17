import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? value;
  final Icon? icon;
  final int? elevation;
  final TextStyle? textStyle;
  final ValueChanged<dynamic>? onChange;
  final List<dynamic> list;

  const CustomDropdownButton({
    Key? key,
    this.value,
    this.icon,
    this.elevation,
    this.textStyle,
    this.onChange,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initialValue = list.isNotEmpty ? list[0] : null;
    return DropdownButton<dynamic>(
      value: value ?? initialValue,
      icon: icon ?? const Icon(Icons.arrow_downward),
      elevation: elevation ?? 16,
      style: textStyle ?? theme.textTheme.labelLarge,
      onChanged: onChange,
      items: list.map<DropdownMenuItem<dynamic>>((dynamic value) {
        return DropdownMenuItem<dynamic>(value: value, child: Text(value));
      }).toList(),
    );
  }
}
