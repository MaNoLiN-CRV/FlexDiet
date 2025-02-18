import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomUserInfo extends StatefulWidget {
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
    this.isGender = false,
    this.genderValue,
    this.onChangedGender,
  });

  @override
  State<CustomUserInfo> createState() => _CustomUserInfoState();
}

class _CustomUserInfoState extends State<CustomUserInfo> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color focusColor = theme.colorScheme.secondary;
    final Color defaultColor = Colors.grey.shade600;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused ? focusColor : defaultColor,
            width: 1.5,
          ),
          boxShadow: [
            if (_isFocused)
              BoxShadow(
                color: focusColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelText,
              style: TextStyle(
                color: _isFocused ? focusColor : defaultColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.isGender)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none, // Remove underline
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                ),
                value: widget.genderValue,
                items: const [
                  DropdownMenuItem(value: 'hombre', child: Text('Hombre')),
                  DropdownMenuItem(value: 'mujer', child: Text('Mujer')),
                ],
                onChanged: widget.onChangedGender,
                validator: widget.validator,
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            else if (widget.isDropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none, // Remove underline
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                ),
                value: widget.value,
                items: widget.items,
                onChanged: widget.onChangedDropdown,
                validator: widget.validator,
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            else
              TextFormField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                decoration: const InputDecoration(
                  border: InputBorder.none, // Remove underline
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                ),
                validator: widget.validator,
                onChanged: widget.onChanged,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    ).animate(target: _isFocused ? 1 : 0).scale(
        duration: const Duration(milliseconds: 200),
        begin: const Offset(1, 1),
        end: const Offset(1.02, 1.02));
  }
}
