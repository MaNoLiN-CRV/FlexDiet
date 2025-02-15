import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/admin/use_template_screen.dart';
import 'package:flutter_flexdiet/screens/home_screen.dart';
import 'package:flutter_flexdiet/widgets/custom_button.dart';

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO : Target customer for the template
          Text(
            'Target customer for the template, (not implemented)',
            style: theme.textTheme.bodyMedium,
          ),
          CustomButton(
            text: 'CREATE TEMPLATE',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            backgroundColor: theme.colorScheme.primary,
            textColor: theme.colorScheme.onPrimary,
          ),
          SizedBox(height: 16),
          CustomButton(
            text: 'USE TEMPLATE',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UseTemplateScreen()));
            },
            backgroundColor: theme.colorScheme.primary,
            textColor: theme.colorScheme.onPrimary,
          ),
        ],
      ),
    ));
  }
}
