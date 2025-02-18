import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
    final screenSize = MediaQuery.of(context).size;

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
                  key: myFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: screenSize.height * 0.18,
                      ),
                      Text(
                        'FlexDiet',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium
                            ?.copyWith(color: textDarkBlue),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Regístrate para empezar tu viaje saludable',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: textDarkBlue),
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
                        child: CustomInputText(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, ingresa un nombre de usuario';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Nombre de usuario',
                            labelStyle: theme.inputDecorationTheme.labelStyle,
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
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
                        child: CustomInputText(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            labelStyle: theme.inputDecorationTheme.labelStyle,
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.email_rounded),
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
                        child: CustomInputText(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value!.length < 8) return 'Mínimo 8 caracteres';
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: theme.inputDecorationTheme.labelStyle,
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
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
                        child: CustomInputText(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          validator: (value) {
                            if (value!.length < 8) return 'Mínimo 8 caracteres';
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            labelStyle: theme.inputDecorationTheme.labelStyle,
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
                          // Verificar si todos los campos están llenos
                          if (_usernameController.text.isEmpty ||
                              _emailController.text.isEmpty ||
                              _passwordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty) {
                            if (context.mounted) {
                              ShowToast(context,
                                  'Por favor, rellena todos los campos.',
                                  toastType: ToastType.warning);
                            }
                          }

                          // Verificar si las contraseñas coinciden
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            if (context.mounted) {
                              ShowToast(
                                  context, 'Las contraseñas no coinciden.',
                                  toastType: ToastType.error);
                            }
                          }

                          try {
                            // Intentar registrar al usuario
                            await emailAuthService.signUp(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            // Si el registro es exitoso, navegar a la pantalla de inicio de sesión
                            if (context.mounted) {
                              ShowToast(
                                  context, 'Has sido registrado correctamente.',
                                  toastType: ToastType.success);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'email-already-in-use') {
                              if (context.mounted) {
                                ShowToast(context, 'El correo ya está en uso.',
                                    toastType: ToastType.error);
                              }
                            } else {
                              if (e.code == 'weak-password') {
                                if (context.mounted) {
                                  ShowToast(context,
                                      'La contraseña debe de tener al menos 6 caracteres.',
                                      toastType: ToastType.error);
                                }
                              } else if (e.code == 'invalid-email') {
                                if (context.mounted) {
                                  ShowToast(context, 'El email es inválido',
                                      toastType: ToastType.error);
                                }
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ShowToast(context, 'Ocurrió un error inesperado.',
                                  toastType: ToastType.error);
                            }
                          }
                        },
                        style: theme.elevatedButtonTheme.style,
                        child: Text('Regístrate',
                            style: theme.textTheme.labelMedium
                                ?.copyWith(color: textLightBlue)),
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
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: textDarkBlue),
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
