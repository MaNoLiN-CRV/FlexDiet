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
  final bool isGender;
  final String? genderValue;
  final void Function(String?)? onChangedGender;

  const CustomUserInfo({
    Key? key,
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
    this.isGender = false,
    this.genderValue,
    this.onChangedGender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isGender)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: labelText,
              border: const UnderlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            value: genderValue,
            items: const [
              DropdownMenuItem(value: 'hombre', child: Text('Hombre')),
              DropdownMenuItem(value: 'mujer', child: Text('Mujer')),
            ],
            onChanged: onChangedGender,
            validator: validator,
          )
        else if (isDropdown)
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
