import 'package:flutter/material.dart';

/// A custom input field with a label and optional validation
class CustomInput extends StatefulWidget {
  /// Creates a custom input field with a label and optional validation
  final String label;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
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
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
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


