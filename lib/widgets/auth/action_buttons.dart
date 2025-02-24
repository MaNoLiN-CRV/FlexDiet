import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/theme/theme.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ForgotPasswordScreen()),
          ),
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: theme.textTheme.bodyLarge?.copyWith(color: textDarkBlue),
            textAlign: TextAlign.center,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()),
          ),
          child: Text(
            'Únete ahora',
            style: theme.textTheme.bodyLarge?.copyWith(color: textDarkBlue),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
