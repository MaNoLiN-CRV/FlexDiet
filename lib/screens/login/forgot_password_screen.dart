import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/widgets/custom_toast.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _sub;

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

    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.path == '/reset-password') {
        _showResetPasswordDialog();
      }
    }, onError: (Object err) {
      // Handle error
    });
  }

  Future<void> _sendPasswordResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showToast(context, "Por favor, introduce un correo electrónico",
          toastType: ToastType.error);
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (mounted) {
        showToast(context, "Correo electrónico enviado",
            toastType: ToastType.success);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'El formato del correo electrónico es inválido.';
            break;
          case 'user-not-found':
            errorMessage = 'No hay ninguna cuenta registrada con este correo.';
            break;
          default:
            errorMessage = 'Ocurrió un error inesperado. Inténtalo de nuevo.';
        }
        showToast(context, errorMessage, toastType: ToastType.error);
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Error: ${e.toString()}',
            toastType: ToastType.error);
      }
    }
  }

  Future<void> _showResetPasswordDialog() async {
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Restablecer Contraseña'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Nueva Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  hintText: 'Confirmar Nueva Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newPasswordController.text ==
                  confirmPasswordController.text) {
                _resetPassword(newPasswordController.text);
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Las contraseñas no coinciden.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Restablecer'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetPassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      await user?.updatePassword(newPassword);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Contraseña Restablecida'),
            content:
                const Text('Tu contraseña ha sido restablecida exitosamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
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
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: textDarkBlue)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Correo electrónico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _sendPasswordResetEmail,
                      child: const Text('Restablecer contraseña'),
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
