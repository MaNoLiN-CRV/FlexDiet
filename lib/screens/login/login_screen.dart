import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flexdiet/exceptions/exceptions.dart';
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final AuthService authService = AuthService();

  late final AnimationController _animationController;
  late final Animation<Color?> _backgroundColorAnimation;
  late final provider.EmailAuth emailAuthService;
  late final provider.GoogleAuth googleAuthService;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _setupAuthServices();
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
    emailAuthService = authService.emailAuth() as provider.EmailAuth;
    googleAuthService = authService.googleAuth() as provider.GoogleAuth;
  }

  Future<bool> _hasCompletedUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('userInfoCompleted') ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _handleNavigation(BuildContext context) async {
    final hasCompleted = await _hasCompletedUserInfo();

    if (hasCompleted) {
      // Si ya completó, ve directamente a HomeScreen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoadingScreen(
              targetScreen: HomeScreen(),
              loadingSeconds: 2,
            ),
          ),
        );
      }
    } else {
      // Si no ha completado, ve a UserInfoScreen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserInfoScreen()),
        );
      }
    }
  }

  Future<void> _handleEmailSignIn(BuildContext context) async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ShowToast(context, 'Por favor, rellena todos los campos',
          toastType: ToastType.warning);
      return;
    }

    try {
      await emailAuthService.signIn(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      if (!context.mounted) return;
      ShowToast(context, 'Inicio de sesión correcto',
          toastType: ToastType.success);
      await _handleNavigation(context);
    } on InvalidCredentialsException {
      if (!context.mounted) return;
      ShowToast(context, 'Correo electrónico o contraseña incorrectos',
          toastType: ToastType.error);
    } catch (e) {
      if (!context.mounted) return;
      ShowToast(context, 'Correo electrónico o contraseña incorrectos',
          toastType: ToastType.error);
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      await googleAuthService.signIn();
      if (!context.mounted) return;

      ShowToast(context, 'Inicio de sesión correcto',
          toastType: ToastType.success);
      await _handleNavigation(context);
    } catch (e) {
      if (!context.mounted) return;
      ShowToast(context, 'Error al iniciar sesión con Google',
          toastType: ToastType.error);
    }
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
        ShowToast(context, 'Inicio de sesión correcto',
            toastType: ToastType.success);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInfoScreen()),
        );
      }
    } on PlatformException {
      if (!context.mounted) return;
      ShowToast(context, 'Error en la autenticación biométrica',
          toastType: ToastType.error);
    }
  }

  Widget _buildInputField({
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
          labelText: label,
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

  Widget _buildActionButtons(ThemeData theme) {
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

  Widget _buildSocialButtons(ThemeData theme, double screenWidth) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final googleButtonColor =
        isDarkMode ? backgroundColorDarkBlue : backgroundColorWhite;
    final appleButtonColor =
        isDarkMode ? backgroundColorDarkBlue : backgroundColorWhite;
    final appleIconColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: GoogleAuthButton(
              onPressed: () => _handleGoogleSignIn(context),
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
              onPressed: () {},
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
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
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
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: textDarkBlue,
                              ),
                            ),
                          ),
                          Text(
                            'Tu camino hacia una vida saludable',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: textDarkBlue,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.04),
                          _buildInputField(
                            controller: _usernameController,
                            label: 'Correo electrónico',
                            icon: Icons.email_rounded,
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          _buildInputField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          ElevatedButton(
                            onPressed: () =>
                                _handleNavigation(context), // LOGIN BYPASS
                            style: theme.elevatedButtonTheme.style,
                            child: Text(
                              'Comenzar mi viaje saludable',
                              style: theme.textTheme.labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          _buildActionButtons(theme),
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
                          _buildSocialButtons(theme, screenSize.width),
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

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
