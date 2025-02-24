import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexdiet/main.dart';
import 'package:flutter_flexdiet/screens/screens.dart';
import 'package:flutter_flexdiet/services/auth/auth_service.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:flutter_flexdiet/widgets/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

// Constants
const String biometricUserIdKey = 'biometricUserId';
const String biometricAuthenticationReason = 'Autentícate para iniciar sesión';
const String userInfoCompletedKey = 'userInfoCompleted';

class AuthHandler {
  final provider.EmailAuth emailAuthService;
  final provider.GoogleAuth googleAuthService;
  final provider.AppleAuthProvider appleAuthService;
  final AuthService authService;
  final BuildContext context;
  final encrypt.Key key = encrypt.Key.fromLength(32);
  final encrypt.IV iv = encrypt.IV.fromLength(16);

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
    return prefs.getBool(userInfoCompletedKey) ?? false;
  }

  Future<void> handleEmailSignIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _showToast(context, 'Por favor, introduce email y contraseña',
          toastType: ToastType.error);
      return;
    }

    try {
      final userCredential =
          await emailAuthService.signIn(email: email, password: password);

      if (userCredential?.user != null) {
        if (context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            promptForBiometricAssociation(userCredential!.user!.uid,
                userCredential.user!.email ?? "user");
          });
          navigateToNextScreen();
        }

        _showToast(context, 'Inicio de sesión correcto',
            toastType: ToastType.success);
      }
    } catch (e) {
      _showToast(context, 'Error al iniciar sesión: $e',
          toastType: ToastType.error);
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
        }

        _showToast(context, 'Inicio de sesión correcto',
            toastType: ToastType.success);
      }
    } catch (e) {
      _showToast(context, 'Error al iniciar sesión con Google: $e',
          toastType: ToastType.error);
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

        _showToast(context, 'Inicio de sesión correcto con Apple',
            toastType: ToastType.success);
      }
    } catch (e) {
      _showToast(context, 'Error al iniciar sesión con Apple: $e',
          toastType: ToastType.error);
    }
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> promptForBiometricAssociation(String uid, String user) async {
    if (!context.mounted) return;

    // Capture a valid parent context
    final parentContext = context;

    final LocalAuthentication auth = LocalAuthentication();
    final isAvailable = await auth.canCheckBiometrics;
    if (!isAvailable) {
      _showToast(context, 'Biometrics not available on this device',
          toastType: ToastType.warning);
      return;
    }

    showDialog(
      context: parentContext, // Use the captured parentContext
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

                  bool didAuthenticate = await auth.authenticate(
                    localizedReason:
                        'Por favor, autentícate con tu huella digital',
                    options: const AuthenticationOptions(
                      biometricOnly: true,
                    ),
                  );

                  if (didAuthenticate) {
                    // Show loading indicator
                    if (parentContext.mounted) {
                      showDialog(
                        context:
                            parentContext, // Use the captured parentContext
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
                      // Call the static method using compute
                      final encryptedId = await compute(
                        AuthHandler._encryptBiometricIdInIsolate,
                        {
                          'uid': uid,
                          'keyBase64': key.base64, // Pass key as base64
                          'ivBase64': iv.base64, // Pass IV as base64
                        },
                      );

                      if (parentContext.mounted) {
                        // Dismiss loading dialog
                        Navigator.of(parentContext).pop();
                      }

                      // Store the encrypted ID in Shared Preferences (on the main isolate)
                      if (encryptedId != null) {
                        await prefs.setString(biometricUserIdKey, encryptedId);
                        await prefs.setString(
                            '${uid}_email', user); // Add this line
                        if (kDebugMode) {
                          print(
                              'Biometric ID stored successfully in shared preferences with key: $biometricUserIdKey');
                          print(
                              'Email stored with key: ${'${uid}_email'} and value: $user'); // Log the stored email
                        }
                      } else {
                        print("Encryption failed, not storing biometric ID");
                      }

                      // Show success or error message
                      if (parentContext.mounted) {
                        _showToast(
                          parentContext,
                          encryptedId != null
                              ? 'Huella digital asociada a la cuenta $user'
                              : 'Error al asociar la huella digital',
                          toastType: encryptedId != null
                              ? ToastType.success
                              : ToastType.error,
                        );
                      }
                    } catch (e) {
                      // Dismiss loading dialog
                      if (parentContext.mounted) {
                        Navigator.of(parentContext).pop();
                      }
                      if (context.mounted) {
                        _showToast(
                          parentContext,
                          'Error al asociar la huella digital: $e',
                          toastType: ToastType.error,
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      _showToast(
                        parentContext,
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

  // Static method to encrypt the biometric ID within the isolate
  static Future<String?> _encryptBiometricIdInIsolate(
      Map<String, dynamic> params) async {
    try {
      // Retrieve parameters
      final String uid = params['uid'] as String;
      final String keyBase64 = params['keyBase64'] as String;
      final String ivBase64 = params['ivBase64'] as String;

      // Recreate key and IV from base64
      final encrypt.Key key = encrypt.Key.fromBase64(keyBase64);
      final encrypt.IV iv = encrypt.IV.fromBase64(ivBase64);

      // Encryption
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypter.encrypt(uid, iv: iv);
      final encryptedBase64 = encrypted.base64;

      if (kDebugMode) {
        print('Encrypted biometric ID: $encryptedBase64');
      }

      return encryptedBase64;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to encrypt biometric ID: $e');
      }
      return null;
    }
  }

  Future<String?> getAssociatedUserId() async {
    // 1. Retrieve the encrypted user ID from SharedPreferences
    final encryptedUserId = prefs.getString(biometricUserIdKey);

    if (encryptedUserId == null) {
      return null; // No biometric ID stored
    }

    try {
      // 2. Decrypt the user ID
      final decryptedUid = decryptUserId(encryptedUserId);
      return decryptedUid;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to decrypt biometric ID: $e');
      }
      return null; // Decryption failed
    }
  }

  String decryptUserId(String encryptedUserId) {
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypt.Encrypted.fromBase64(encryptedUserId);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  void _showToast(BuildContext context, String message,
      {ToastType toastType = ToastType.info}) {
    if (context.mounted) {
      showToast(context, message, toastType: toastType);
    }
  }
}
