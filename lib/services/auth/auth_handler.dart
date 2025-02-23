import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Top-level function for compute
Future<bool> storeBiometricId(String uid) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('biometricUserId', uid);
    return true;
  } catch (e) {
    return false;
  }
}

class AuthHandler {
  final provider.EmailAuth emailAuthService;
  final provider.GoogleAuth googleAuthService;
  final provider.AppleAuthProvider appleAuthService;
  final AuthService authService;
  final BuildContext context;

  AuthHandler({
    required this.emailAuthService,
    required this.googleAuthService,
    required this.appleAuthService,
    required this.authService,
    required this.context,
  });

  Future<void> navigateToNextScreen() async {
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

  Future<void> handleEmailSignIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showToast(context, 'Por favor, introduce email y contraseña',
          toastType: ToastType.error);
      return;
    }

    final userCredential =
        await emailAuthService.signIn(email: email, password: password);

    if (userCredential?.user != null) {
      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          promptForBiometricAssociation(
              userCredential!.user!.uid, userCredential.user!.email ?? "user");
        });
        navigateToNextScreen();
      }
      if (context.mounted) {
        showToast(context, 'Inicio de sesión correcto',
            toastType: ToastType.success);
      }
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      final userCredential = await googleAuthService.signIn();
      final user = userCredential?.user;

      if (user != null) {
        if (context.mounted) {
          promptForBiometricAssociation(user.uid, user.email ?? "user");
          navigateToNextScreen();

          showToast(context, 'Inicio de sesión correcto',
              toastType: ToastType.success);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showToast(context, 'Error al iniciar sesión con Google',
            toastType: ToastType.error);
      }
    }
  }

  Future<void> handleAppleSignIn() async {
    try {
      final userCredential = await appleAuthService.signIn();
      final user = userCredential?.user;

      if (user != null) {
        if (context.mounted) {
          promptForBiometricAssociation(user.uid, user.email ?? "user");
          navigateToNextScreen();
        }
        if (context.mounted) {
          showToast(context, 'Inicio de sesión correcto con Apple',
              toastType: ToastType.success);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showToast(context, 'Error al iniciar sesión con Apple',
            toastType: ToastType.error);
      }
    }
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> promptForBiometricAssociation(String uid, String user) async {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Asociar biometría'),
            content: const Text(
                '¿Quieres asociar tu huella digital a esta cuenta para iniciar sesión más rápido la próxima vez?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              TextButton(
                child: const Text('Sí'),
                onPressed: () async {
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }

                  // 🔹 Autenticación biométrica antes de almacenar el ID
                  bool didAuthenticate = await auth.authenticate(
                    localizedReason:
                        'Por favor, autentícate con tu huella digital',
                    options: const AuthenticationOptions(
                      biometricOnly: true, // Solo huella digital o Face ID
                    ),
                  );

                  if (didAuthenticate) {
                    // 🔹 Mostrar carga mientras se almacena la huella
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext loadingContext) {
                          return PopScope(
                            canPop: false,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      );
                    }

                    try {
                      final success = await compute(storeBiometricId, uid);

                      if (context.mounted && Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                        showToast(
                          context,
                          success
                              ? 'Huella digital asociada a la cuenta $user'
                              : 'Error al asociar la huella digital',
                          toastType:
                              success ? ToastType.success : ToastType.error,
                        );
                      }
                    } catch (e) {
                      if (context.mounted && Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }

                      if (context.mounted) {
                        showToast(
                          context,
                          'Error al asociar la huella digital: $e',
                          toastType: ToastType.error,
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      showToast(
                        context,
                        'Autenticación biométrica cancelada',
                        toastType: ToastType.warning,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
