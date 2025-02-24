import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  }

  Future<void> _navigateToNextScreen(BuildContext context) async {
    bool userInfoCompleted = await isUserInfoCompleted();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
            targetScreen:
                userInfoCompleted ? const HomeScreen() : const UserInfoScreen(),
            loadingSeconds: 2,
          ),
        ),
      );
    }
  }

  Future<bool> isUserInfoCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('userInfoCompleted') ?? false;
  }

  Future<void> _handleBiometricAuth(BuildContext context) async {
    final canAuthenticate = await _localAuth.canCheckBiometrics ||
        await _localAuth.isDeviceSupported();

    if (!canAuthenticate) return;

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Autentícate para iniciar sesión',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated && context.mounted) {
        showToast(context, 'Inicio de sesión correcto',
            toastType: ToastType.success);
        await _navigateToNextScreen(context);
      }
    } on PlatformException {
      if (!context.mounted) return;
      showToast(context, 'Error en la autenticación biométrica',
          toastType: ToastType.error);
    }
  }

  Future<void> _handleEmailSignIn(BuildContext context) async {
    try {
      final email = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        showToast(context, 'Por favor, introduce email y contraseña',
            toastType: ToastType.error);
        return;
      }

      final userCredential =
          await emailAuthService.signIn(email: email, password: password);

      if (userCredential?.user != null) {
        if (context.mounted) {
          await _navigateToNextScreen(context);
        }
      }

      if (!context.mounted) return;
      showToast(context, 'Inicio de sesión correcto',
          toastType: ToastType.success);
    } catch (e) {
      if (mounted) {
        showToast(context, 'Error inesperado: $e', toastType: ToastType.error);
      }
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final userCredential = await googleAuthService.signIn();
      final user = userCredential?.user;
      if (user != null) {
        if (context.mounted) {
          await _navigateToNextScreen(context);
        }
      }
      if (!context.mounted) return;

      showToast(context, 'Inicio de sesión correcto',
          toastType: ToastType.success);
    } catch (e) {
      if (!context.mounted) return;
      showToast(context, 'Error al iniciar sesión con Google: $e',
          toastType: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final horizontalPadding = screenSize.width * 0.05;

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
                            emailAuthService: emailAuthService,
                            authService: authService,
                            usernameController: _usernameController,
                            passwordController: _passwordController,
                            handleGoogleSignIn: _handleGoogleSignIn,
                            handleEmailSignIn: _handleEmailSignIn,
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
                            googleAuthService: googleAuthService,
                            handleGoogleSignIn: _handleGoogleSignIn,
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
