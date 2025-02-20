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
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
              decoration: _buildBackground(_backgroundColorAnimation),
              child: _buildPrincipalContainer(
                  context,
                  myFormKey,
                  screenSize,
                  theme,
                  _usernameController,
                  _emailController,
                  _isPasswordVisible,
                  _isConfirmPasswordVisible,
                  _passwordController,
                  _confirmPasswordController,
                  emailAuthService, () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }, () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              }));
        },
      ),
    );
  }
}

Decoration _buildBackground(Animation<Color?> backgroundColorAnimation) {
  return BoxDecoration(
    color: backgroundColorAnimation.value,
    image: DecorationImage(
      image: AssetImage('assets/images/background.jpg'),
      opacity: 0.4,
      fit: BoxFit.cover,
    ),
  );
}

Widget _buildPrincipalContainer(
  BuildContext context,
  GlobalKey<FormState> myFormKey,
  Size screenSize,
  ThemeData theme,
  TextEditingController usernameController,
  TextEditingController emailController,
  bool isPasswordVisible,
  bool isConfirmPasswordVisible,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
  provider.EmailAuth emailAuthService,
  void Function()? onPasswordVisibilityChanged,
  void Function()? onConfirmPasswordVisibilityChanged,
) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Form(
        key: myFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildUpContainer(screenSize, theme),

            const SizedBox(height: 50),
            _buildForm(
                theme,
                usernameController,
                emailController,
                passwordController,
                confirmPasswordController,
                isPasswordVisible,
                isConfirmPasswordVisible,
                onPasswordVisibilityChanged,
                onConfirmPasswordVisibilityChanged),
            const SizedBox(height: 30),
            // Sign Up button
            ElevatedButton(
              onPressed: () async {
                if (usernameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  if (context.mounted) {
                    showToast(context, 'Por favor, rellena todos los campos.',
                        toastType: ToastType.warning);
                  }
                }

                if (passwordController.text != confirmPasswordController.text) {
                  if (context.mounted) {
                    showToast(context, 'Las contraseñas no coinciden.',
                        toastType: ToastType.error);
                  }
                }

                try {
                  await emailAuthService.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  if (context.mounted) {
                    showToast(context, 'Has sido registrado correctamente.',
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
                      showToast(context, 'El correo ya está en uso.',
                          toastType: ToastType.error);
                    }
                  } else {
                    if (e.code == 'weak-password') {
                      if (context.mounted) {
                        showToast(context,
                            'La contraseña debe de tener al menos 6 caracteres.',
                            toastType: ToastType.error);
                      }
                    } else if (e.code == 'invalid-email') {
                      if (context.mounted) {
                        showToast(context, 'El email es inválido',
                            toastType: ToastType.error);
                      }
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    showToast(context, 'Ocurrió un error inesperado.',
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
  );
}

Widget _buildUpContainer(Size screenSize, ThemeData theme) {
  return Column(
    children: [
      Image.asset(
        'assets/images/logo.png',
        height: screenSize.height * 0.18,
      ),
      Text(
        'FlexDiet',
        textAlign: TextAlign.center,
        style: theme.textTheme.displayMedium?.copyWith(color: textDarkBlue),
      ),
      const SizedBox(height: 8),
      Text(
        'Regístrate para empezar tu viaje saludable',
        textAlign: TextAlign.center,
        style: theme.textTheme.titleMedium?.copyWith(color: textDarkBlue),
      ),
    ],
  );
}

Widget _buildForm(
  ThemeData theme,
  TextEditingController usernameController,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
  bool isPasswordVisible,
  bool isConfirmPasswordVisible,
  void Function()? onPasswordVisibilityChanged,
  void Function()? onConfirmPasswordVisibilityChanged,
) {
  return Column(
    children: [
      // Username input
      Container(
        decoration: _buildDecorationContainer(theme),
        child: CustomInputText(
            controller: usernameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingresa un nombre de usuario';
              }
              return null;
            },
            decoration: _buildDecoration(
                theme, 'Nombre de usuario', Icons.person_outline)),
      ),

      const SizedBox(height: 20),
      Container(
        decoration: _buildDecorationContainer(theme),
        child: CustomInputText(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _buildDecoration(
                theme, 'Correo electrónico', Icons.email_rounded)),
      ),
      const SizedBox(height: 20),
      // Password input
      Container(
        decoration: _buildDecorationContainer(theme),
        child: CustomInputText(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            validator: (value) {
              if (value!.length < 8) return 'Mínimo 8 caracteres';
              return null;
            },
            decoration: _buildDecoration(
                theme,
                'Contraseña',
                Icons.lock_outline,
                IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: onPasswordVisibilityChanged,
                ))),
      ),
      const SizedBox(height: 20),
      // Confirm Password input
      Container(
        decoration: _buildDecorationContainer(theme),
        child: CustomInputText(
            controller: confirmPasswordController,
            obscureText: !isConfirmPasswordVisible,
            validator: (value) {
              if (value!.length < 8) return 'Mínimo 8 caracteres';
              return null;
            },
            decoration: _buildDecoration(
                theme,
                'Repita su contraseña',
                Icons.lock_outline,
                IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: onPasswordVisibilityChanged,
                ))),
      ),
    ],
  );
}

BoxDecoration _buildDecorationContainer(ThemeData theme) {
  return BoxDecoration(
    color: theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Colors.black,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );
}

InputDecoration _buildDecoration(
    ThemeData theme, String labelText, IconData icon,
    [IconButton? suffix]) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: theme.inputDecorationTheme.labelStyle,
    border: InputBorder.none,
    prefixIcon: Icon(
      icon,
    ),
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  );
}
