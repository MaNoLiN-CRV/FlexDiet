import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;

class LoginForm extends StatefulWidget {
  final provider.EmailAuth emailAuthService;
  final AuthService authService;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Future<void> Function(BuildContext) handleGoogleSignIn;
  final Future<void> Function(BuildContext) handleEmailSignIn;
  const LoginForm({
    super.key,
    required this.emailAuthService,
    required this.authService,
    required this.usernameController,
    required this.passwordController,
    required this.handleGoogleSignIn,
    required this.handleEmailSignIn,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        _buildInputField(
          context: context,
          controller: widget.usernameController,
          label: 'Correo electrónico',
          icon: Icons.email_rounded,
        ),
        SizedBox(height: screenSize.height * 0.02),
        _buildInputField(
          context: context,
          controller: widget.passwordController,
          label: 'Contraseña',
          icon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(height: screenSize.height * 0.02),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => widget.handleEmailSignIn(context),
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                  ),
                ),
            child: Text(
              'Comenzar mi viaje saludable',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CustomInputText(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        keyboardType: !isPassword ? TextInputType.emailAddress : null,
        decoration: InputDecoration(
          hintText: label,
          labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
          border: InputBorder.none,
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
