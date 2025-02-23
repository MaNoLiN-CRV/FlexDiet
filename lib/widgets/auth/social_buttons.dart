import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/services/auth/auth_handler.dart';

class SocialLoginButtons extends StatelessWidget {
  final provider.GoogleAuth googleAuthService;
  final AuthHandler authHandler;

  const SocialLoginButtons(
      {super.key, required this.googleAuthService, required this.authHandler});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final googleButtonColor =
        isDarkMode ? backgroundColorDarkBlue : backgroundColorWhite;
    final appleButtonColor =
        isDarkMode ? backgroundColorDarkBlue : backgroundColorWhite;
    final appleIconColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: GoogleAuthButton(
              onPressed: () => authHandler.handleGoogleSignIn(),
              text: "Iniciar con Google",
              style: AuthButtonStyle(
                buttonColor: googleButtonColor,
                textStyle: theme.textTheme.bodyLarge,
                iconSize: 20,
                width: double.infinity,
                height: 45,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppleAuthButton(
              text: "Iniciar con Apple",
              onPressed: () => authHandler
                  .handleAppleSignIn(), // Call the Apple Sign-In method
              style: AuthButtonStyle(
                buttonColor: appleButtonColor,
                iconColor: appleIconColor,
                textStyle: theme.textTheme.bodyLarge,
                iconSize: 20,
                width: double.infinity,
                height: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
