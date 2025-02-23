import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:flutter_flexdiet/widgets/auth/login_form.dart';
import 'package:flutter_flexdiet/widgets/auth/social_buttons.dart';
import 'package:flutter_flexdiet/widgets/auth/action_buttons.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_flexdiet/services/auth/auth_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final AuthService authService = AuthService();
  late final provider.EmailAuth emailAuthService;
  late final provider.GoogleAuth googleAuthService;
  late final provider.AppleAuthProvider
      appleAuthService; // Add Apple Auth service
  late final AnimationController _animationController;
  late final Animation<Color?> _backgroundColorAnimation;
  final LocalAuthentication _localAuth = LocalAuthentication();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setupAuthServices();
    _checkBiometricLogin();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundColorAnimation = ColorTween(
      begin: backgroundColorWhite,
      end: const Color.fromARGB(48, 98, 15, 231),
    ).animate(_animationController);
  }

  void _setupAuthServices() {
    emailAuthService = authService.emailAuth();
    googleAuthService = authService.googleAuth();
    appleAuthService = authService.appleAuth();
  }

  Future<bool> isUserInfoCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('userInfoCompleted') ?? false;
  }

  // Check for stored biometric ID and attempt login
  Future<void> _checkBiometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final biometricUserId = prefs.getString('biometricUserId');

    if (biometricUserId != null) {
      if (context.mounted) {
        _handleBiometricAuth(context);
      }
    }
  }

  Future<void> _handleBiometricAuth(BuildContext context) async {
    final canAuthenticate = await _localAuth.canCheckBiometrics ||
        await _localAuth.isDeviceSupported();

    if (!canAuthenticate) {
      if (context.mounted) {
        showToast(context, "Biometric authentication is not available",
            toastType: ToastType.info);
        return;
      }
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Autentícate para iniciar sesión',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated && context.mounted) {
        // Get the biometricUserId from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final biometricUserId = prefs.getString('biometricUserId');

        if (biometricUserId != null) {
          // Check if the user still exists in Firebase
          try {
            final user = authService.currentUser;
            if (user != null && user.uid == biometricUserId) {
              if (context.mounted) {
                showToast(context, 'Inicio de sesión correcto',
                    toastType: ToastType.success);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfoScreen()),
                );
              }
              return;
            } else {
              // User is not logged in with those credentials. Clear the stored biometric ID.
              await prefs.remove('biometricUserId');
              if (context.mounted) {
                showToast(context,
                    'El usuario ha cambiado. Por favor, inicie sesión nuevamente.',
                    toastType: ToastType.warning);
              }
              return;
            }
          } catch (e) {
            // The user may no longer exist in Firebase.
            await prefs.remove('biometricUserId');
            if (context.mounted) {
              showToast(context,
                  'Error al verificar el usuario. Por favor, inicie sesión nuevamente.',
                  toastType: ToastType.error);
            }
            return;
          }
        } else {
          if (context.mounted) {
            showToast(context, 'No se ha encontrado ID biométrico guardado.',
                toastType: ToastType.warning);
          }
          return;
        }
      }
    } on PlatformException {
      if (!context.mounted) return;
      showToast(context, 'Error en la autenticación biométrica',
          toastType: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = screenSize.width * 0.05;
    final authHandler = AuthHandler(
      emailAuthService: emailAuthService,
      googleAuthService: googleAuthService,
      appleAuthService: appleAuthService,
      authService: authService,
      context: context,
    );

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
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: screenSize.height * 0.15,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'FlexDiet',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall
                                  ?.copyWith(color: textDarkBlue),
                            ),
                          ),
                          Text(
                            'Tu camino hacia una vida saludable',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: textDarkBlue),
                          ),
                          SizedBox(height: screenSize.height * 0.04),
                          LoginForm(
                            authHandler: authHandler,
                            usernameController: _usernameController,
                            passwordController: _passwordController,
                          ),
                          ActionButtons(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.02),
                            child: Row(
                              children: [
                                Expanded(child: Divider(color: textDarkBlue)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text('O continúa con',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: textDarkBlue)),
                                ),
                                Expanded(child: Divider(color: textDarkBlue)),
                              ],
                            ),
                          ),
                          SocialLoginButtons(
                            authHandler: authHandler,
                            googleAuthService: googleAuthService,
                          ),
                          IconButton(
                            icon: Icon(Icons.fingerprint,
                                size: 40, color: textDarkBlue),
                            onPressed: () => _handleBiometricAuth(context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
