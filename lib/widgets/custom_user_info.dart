import 'package:flutter/material.dart';

class CustomUserInfo extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? child;
  final ValueChanged<String?>? onChanged;
  final bool isDropdown;
  final List<DropdownMenuItem<String>>? items;
  final String? value;
  final void Function(String?)? onChangedDropdown;

  const CustomUserInfo({
    super.key,
    required this.labelText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.child,
    this.onChanged,
    this.isDropdown = false,
    this.items,
    this.value,
    this.onChangedDropdown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDropdown)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: labelText,
              border: const UnderlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            value: value,
            items: items,
            onChanged: onChangedDropdown,
            validator: validator,
          )
        else
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              border: const UnderlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            validator: validator,
            onChanged: onChanged,
          ),
      ],
    );
  }
}
