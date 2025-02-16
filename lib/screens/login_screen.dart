import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flexdiet/exceptions/exceptions.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:flutter_flexdiet/theme/app_theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart'; // Importa el ShowToast
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;

  final AuthService authService = AuthService();
  late provider.EmailAuth emailAuthService =
      authService.emailAuth() as provider.EmailAuth;
  late provider.GoogleAuth googleAuthService =
      authService.googleAuth() as provider.GoogleAuth;

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
    _usernameController.dispose();
    _passwordController.dispose();
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
              image: const DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                opacity: 0.4,
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
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
                      'Tu camino hacia una vida saludable',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 50),
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
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
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
                    ElevatedButton(
                      onPressed: () async {
                        // Validación de campos vacíos
                        if (_usernameController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ShowToast(
                            context,
                            'Por favor, rellena todos los campos',
                            toastType: ToastType.warning,
                          );
                          return;
                        }

                        try {
                          await emailAuthService.signIn(
                            email: _usernameController.text,
                            password: _passwordController.text,
                          );

                          if (context.mounted) {
                            ShowToast(context, 'Inicio de sesión correcto',
                                toastType: ToastType.success);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserInfoScreen(),
                              ),
                            );
                          }
                        } on InvalidCredentialsException {
                          if (context.mounted) {
                            ShowToast(
                              context,
                              'Correo electrónico o contraseña incorrectos',
                              toastType: ToastType.error,
                            );
                          }
                        } on Exception catch (exception) {
                          if (context.mounted) {
                            ShowToast(
                              context,
                              'Correo electrónico o contraseña incorrectos',
                              toastType: ToastType.error,
                            );
                            print('Otro error: ${exception.toString()}');
                          }
                        }
                      },
                      style: theme.elevatedButtonTheme.style,
                      child: Text('Comenzar mi viaje saludable',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          )),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Únete ahora',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                              color: theme.colorScheme.onSurface,
                              thickness: 0.5),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'O continúa con',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.colorScheme.onSurface),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                              color: theme.colorScheme.onSurface,
                              thickness: 0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GoogleAuthButton(
                            onPressed: () async {
                              try {
                                if (_usernameController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  ShowToast(
                                    context,
                                    'Por favor, rellena todos los campos',
                                    toastType: ToastType.warning,
                                  );
                                  return;
                                }
                                await googleAuthService.signIn();
                                if (context.mounted) {
                                  ShowToast(
                                      context, 'Inicio de sesión correcto',
                                      toastType: ToastType.success);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserInfoScreen(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ShowToast(
                                    context,
                                    'Error al iniciar sesión con Google',
                                    toastType: ToastType.error,
                                  );
                                }
                              }
                            },
                            text: "Inicia sesión con Google",
                            style: AuthButtonStyle(
                              buttonColor: theme.colorScheme.surface,
                              borderRadius: 12,
                              textStyle: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface),
                              iconSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: AppleAuthButton(
                            text: "Inicia sesión con Apple",
                            onPressed: () {},
                            style: AuthButtonStyle(
                              buttonColor: theme.colorScheme.surface,
                              borderRadius: 12,
                              textStyle: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface),
                              iconSize: 20,
                              iconColor: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.fingerprint,
                          size: 40,
                          color: theme.colorScheme.onSurface,
                        ),
                        onPressed: () async {
                          // Validación de campos vacíos
                          if (_usernameController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            ShowToast(
                              context,
                              'Por favor, rellena todos los campos',
                              toastType: ToastType.warning,
                            );
                            return;
                          }
                          bool canAuthenticate =
                              await _localAuth.canCheckBiometrics ||
                                  await _localAuth.isDeviceSupported();
                          if (canAuthenticate) {
                            try {
                              await _localAuth.authenticate(
                                localizedReason:
                                    'Autentícate para iniciar sesión',
                                options: const AuthenticationOptions(
                                    biometricOnly: true),
                              );
                              if (context.mounted) {
                                ShowToast(context, 'Inicio de sesión correcto',
                                    toastType: ToastType.success);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UserInfoScreen(),
                                  ),
                                );
                              }
                            } on PlatformException catch (e) {
                              if (context.mounted) {
                                ShowToast(
                                  context,
                                  'Error en la autenticación biométrica',
                                  toastType: ToastType.error,
                                );
                                print('Error en autenticación: $e');
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
