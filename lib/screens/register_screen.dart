import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:flutter_flexdiet/theme/app_theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;
  final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();
  late provider.EmailAuth emailAuthService =
      authService.emailAuth() as provider.EmailAuth;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundColorAnimation = ColorTween(
      begin: backgroundColorWhite,
      end: const Color.fromARGB(48, 98, 15, 231),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: _backgroundColorAnimation.value,
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                opacity: 0.4,
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Form(
                  child: Column(
                    key: myFormKey,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 150,
                      ),
                      Text(
                        'FlexDiet',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Regístrate para empezar tu viaje saludable',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 50),
                      // Username input

                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomInput(
                          controller: _usernameController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.length < 8) return 'Mínimo 8 caracteres';
                          },
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            labelStyle: theme.inputDecorationTheme.labelStyle
                                ?.copyWith(color: theme.colorScheme.onSurface),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person_outline,
                                color: theme.colorScheme.onSurface),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password input
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomInput(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: theme.inputDecorationTheme.labelStyle
                                ?.copyWith(color: theme.colorScheme.onSurface),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock_outline,
                                color: theme.colorScheme.onSurface),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: theme.colorScheme.onSurface,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Confirm Password input
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomInput(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          validator: (value) {
                            if (value!.length < 8) return 'Mínimo 8 caracteres';
                          },
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            labelStyle: theme.inputDecorationTheme.labelStyle
                                ?.copyWith(color: theme.colorScheme.onSurface),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock_outline,
                                color: theme.colorScheme.onSurface),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: theme.colorScheme.onSurface,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Sign Up button
                      ElevatedButton(
                        onPressed: () async {
                          // Handle registration logic here
                          if (_passwordController.text ==
                              _confirmPasswordController.text) {
                            try {
                              await emailAuthService.signUp(
                                  email: _usernameController.text,
                                  password: _passwordController.text);
                              // If the registration goes well we navigate to HomeScreen
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                            } on FirebaseAuthException {
                              if (context.mounted) {
                                ShowToast(
                                    context, 'El correo se encuentra en uso',
                                    toastType: ToastType.error);
                              }
                            }
                          } else {
                            ShowToast(context,
                                'Las contraseñas no coinciden. ¡Intentalo de nuevo!',
                                toastType: ToastType.error);
                          }
                        },
                        style: theme.elevatedButtonTheme.style,
                        child: Text(
                          'Regístrate',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Already have an account?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '¿Ya tienes cuenta? Inicia sesión',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
