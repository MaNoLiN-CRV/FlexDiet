import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/theme/app_theme_light.dart';
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/widgets/widgets.dart';

late AnimationController _animationController;
late Animation<Color?> _backgroundColorAnimation;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
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
    final TextEditingController _emailController = TextEditingController();
    final screenSize = MediaQuery.of(context).size;

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
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: screenSize.height * 0.3,
                    ),
                    Text('Recuperar Contraseña',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium
                            ?.copyWith(color: textDarkBlue)),
                    const SizedBox(height: 8),
                    Text(
                        'Ingresa tu correo electrónico para restablecer tu contraseña',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: textDarkBlue)),
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: theme.inputDecorationTheme.labelStyle
                              ?.copyWith(color: theme.colorScheme.onSurface),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email_outlined,
                              color: theme.colorScheme.onSurface),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final email = _emailController.text;
                        if (email.isNotEmpty) {
                          ShowToast(
                            context,
                            'Se ha enviado un correo de recuperación a $email',
                            toastType: ToastType.success,
                          );
                        } else {
                          ShowToast(
                            context,
                            'Por favor, ingresa un correo válido',
                            toastType: ToastType.error,
                          );
                        }
                      },
                      style: theme.elevatedButtonTheme.style,
                      child: Text('Enviar correo de recuperación',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          )),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Volver al inicio de sesión',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: textDarkBlue),
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
