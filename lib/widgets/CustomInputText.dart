import 'package:flutter/material.dart';

/// A custom form input widget that provides a standardized text input field with a label.
/// 
/// This widget wraps [TextFormField] to create a reusable input component with
/// consistent styling and built-in support for validation, initial values, and
/// various input configurations.
/// 
/// Example usage:
/// ```dart
/// CustomInput(
///   label: 'Username',
///   validator: (value) {
///     if (value.isEmpty) return 'Please enter a username';
///     return null;
///   },
/// )
/// ```
class CustomInput extends StatefulWidget {
  /// The text label displayed above the input field.
  final String label;

  /// The initial value to be shown in the input field.
  /// If null, the field will be empty.
  final String? initialValue;

  /// Callback function that is called when the text in the field changes.
  /// 
  /// The function receives the new value as a String parameter.
  final ValueChanged<String>? onChanged;

  /// Function to validate the input value.
  /// 
  /// Returns an error message string if validation fails, or null if valid.
  final FormFieldValidator<String>? validator;

  /// The type of keyboard to display for editing the text.
  /// 
  /// For example, [TextInputType.number] for numeric input,
  /// or [TextInputType.emailAddress] for email input.
  final TextInputType? keyboardType;

  /// The type of action button to show on the keyboard.
  /// 
  /// This determines the bottom-right button on the software keyboard.
  final TextInputAction? textInputAction;

  /// Whether to hide the text being edited (useful for passwords).
  final bool obscureText;

  /// The maximum number of characters allowed in the input field.
  final int? maxLength;

  /// The maximum number of lines for the input field.
  /// 
  /// If this is 1 (the default), the enter key on the keyboard will move focus
  /// to the next field. Otherwise, the enter key will insert a new line.
  final int? maxLines;

  /// Whether this input field is used for password entry.
  /// 
  /// When true, this disables autocorrect functionality.
  final bool? isPassword;

  const CustomInput({
    Key? key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLength,
    this.maxLines,
    this.isPassword = false,
  }) : super(key: key);

  @override
  CustomInputState createState() => CustomInputState();
}

/// The state for the CustomInput widget.
/// 
/// Manages a [TextEditingController] for the input field and handles its lifecycle.
class CustomInputState extends State<CustomInput> {
  /// Controller for the text input field.
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: widget.onChanged,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      autocorrect: widget.isPassword ?? false,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}