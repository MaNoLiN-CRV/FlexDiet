import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/theme/theme.dart';
import 'package:flutter_flexdiet/widgets/custom_toast.dart';
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
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _savePasswordResetRequest(String email) async {
    try {
      final timestamp = Timestamp.now();

      await _firestore.collection('password_reset_logs').add({
        'email': email,
        'timestamp': timestamp,
      });
    } catch (e) {
      print("Error saving password reset request: $e");
    }
  }

  Future<int> _getRequestCount(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('password_reset_logs')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print("Error counting requests: $e");
      return 0;
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showToast(context, "Por favor, introduce un correo electrónico",
          toastType: ToastType.error);
      return;
    }
    final requestCount = await _getRequestCount(email);

    if (requestCount >= 5) {
      showToast(context,
          "Has alcanzado el límite de peticiones diarias (5). Inténtelo de nuevo mañana",
          toastType: ToastType.error);
      return;
    }

    try {
      await _savePasswordResetRequest(email);

      await _auth.sendPasswordResetEmail(email: email);

      if (mounted) {
        showToast(context, "Email enviado", toastType: ToastType.success);
      }
    } on FirebaseAuthException {
      if (mounted) {
        showToast(context, "Email enviado", toastType: ToastType.success);
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Error: ${e.toString()}',
            toastType: ToastType.error);
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
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Volver al inicio de sesión',
                          style: TextStyle(color: textDarkBlue)),
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
