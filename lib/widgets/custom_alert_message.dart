import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      required this.theme,
      required this.title,
      required this.content});

  final ThemeData theme;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: theme.textTheme.headlineSmall),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(content),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Aceptar', style: theme.textTheme.bodyMedium))
      ],
    );
  }
}