import 'package:flutter/material.dart';

/// A custom input text widget that extends TextFormField.
/// It allows for customization of initial value, controller, and decoration.
/// Example usage:
/// ```dart
/// CustomInputText(
///   controller: _controller,
///   decoration: InputDecoration(
///     labelText: 'Enter some text',
///     border: OutlineInputBorder(),
///   ),
/// )
/// ```
/// Advanced usage:
/// ```dart
/// CustomInputText(
///   controller: _controller,
///   decoration: InputDecoration(
///     labelText: 'Enter some text',
///     border: OutlineInputBorder(),
///   ),
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return 'Please enter some text';
///     }
///     return null;
///   },
/// )
/// ```
/// ```dart
/// CustomInputText(
///   controller: _controller,
///   decoration: InputDecoration(
///     labelText: 'Enter some text',
///     border: OutlineInputBorder(),
///   ),
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return 'Please enter some text';
///     }
///     return null;
///   },
///   obscureText: true,
/// )
/// ```
/// ```dart
/// CustomInputText(
///   controller: _controller,
///   decoration: InputDecoration(
///     labelText: 'Enter some text',
///     border: OutlineInputBorder(),
///   ),
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return 'Please enter some text';
///     }
///     return null;
///   },
///   obscureText: true,
///   maxLines: 1,
/// )
/// ```

class CustomInputText extends StatelessWidget { 
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final bool? isPassword;
  final TextEditingController controller; 
  final InputDecoration decoration;

  const CustomInputText({
    super.key,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLength,
    this.maxLines,
    this.isPassword = false,
    required this.controller,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller, 
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: obscureText ? 1 : maxLines,
      autocorrect: isPassword ?? false,
      decoration: decoration,
    );
  }
}