//auth_handler.dart
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
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'dart:async'; // Import dart:async
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // Import dart:convert

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
          await navigateToNextScreen();
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
          await navigateToNextScreen();
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
          await navigateToNextScreen();
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

    // Captura el contexto padre
    final parentContext = context;

    final LocalAuthentication auth = LocalAuthentication();
    final isAvailable = await auth.canCheckBiometrics;
    if (!isAvailable) {
      _showToast(context, 'Biometrics not available on this device',
          toastType: ToastType.warning);
      return;
    }

    showDialog(
      context: parentContext,
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
                    // Muestra el indicador de carga
                    if (parentContext.mounted) {
                      showDialog(
                        context: parentContext,
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
                      final biometricIdKey = 'biometricId_$uid';

                      await prefs.setString(
                          'biometricUserUid_$uid', uid); // Almacena UID

                      // Usar una clave fija (dummy key) en lugar de generar una aleatoria
                      final String dummyKey =
                          '12345678901234567890123456789012'; // 32 bytes
                      final key = encrypt.Key.fromUtf8(
                          dummyKey); // Convertir a encrypt.Key
                      final iv =
                          encrypt.IV.fromLength(16); // IV fijo de 16 bytes

                      final encrypter = encrypt.Encrypter(
                        encrypt.AES(key,
                            mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
                      );

                      final encrypted = encrypter.encrypt(uid, iv: iv);

                      // Almacenar el IV y los datos encriptados como un JSON
                      final dataToStore = {
                        'iv': base64Encode(iv.bytes),
                        'encryptedData': encrypted.base64,
                      };

                      final jsonData = jsonEncode(dataToStore);

                      await prefs.setString(biometricIdKey, jsonData);
                      await prefs.setString('${uid}_email', user);

                      // Finaliza el proceso de carga
                      if (parentContext.mounted) {
                        Navigator.of(parentContext).pop();
                      }

                      if (kDebugMode) {
                        print(
                            'Biometric ID stored successfully in shared preferences with key: $biometricIdKey');
                        print(
                            'Email stored with key: ${'${uid}_email'} and value: $user');
                      }

                      // Muestra un mensaje de éxito
                      if (parentContext.mounted) {
                        _showToast(
                          parentContext,
                          'Huella digital asociada a la cuenta $user',
                          toastType: ToastType.success,
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

  Future<String?> getAssociatedUserId() async {
    final allPrefs = await SharedPreferences.getInstance();
    final keys = allPrefs.getKeys();
    String? userUid;

    for (String key in keys) {
      if (key.startsWith('biometricUserUid_')) {
        userUid = allPrefs.getString(key);
        break; // Exit loop after finding the UID
      }
    }

    if (userUid == null) {
      return null; // No associated user ID found
    }

    try {
      final biometricIdKey = 'biometricId_$userUid';
      final jsonData = allPrefs.getString(biometricIdKey);

      if (jsonData == null) {
        return null;
      }

      final data = jsonDecode(jsonData);
      final ivBytes = base64Decode(data['iv']); // Decode the base64 IV
      final encryptedData = data['encryptedData'];

      // Debugging logs
      print("IV bytes: $ivBytes");
      print("Encrypted Data: $encryptedData");

      // Ensure the IV is 16 bytes long for AES
      if (ivBytes.length != 16) {
        print("Error: IV length is not 16 bytes!");
        return null;
      }

      // Generate the Encrypter Object
      final key = encrypt.Key.fromLength(
          32); // Use the same key length as in encryption
      final iv = encrypt.IV(ivBytes); // Use the decoded IV

      // Explicitly specify the padding scheme to ensure it's handled correctly
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);

      // Decrypt the data
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      print("Decrypted User ID: $decrypted");

      return decrypted;
    } catch (e) {
      print('Decryption error: $e');
      return null;
    }
  }

  // New Method: Sign in with decrypted user ID
  Future<void> signInWithBiometrics(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userEmailKey = '${userId}_email';
    final userEmail = prefs.getString(userEmailKey);

    if (userEmail == null) {
      _showToast(context, 'Email no encontrado para el usuario asociado',
          toastType: ToastType.error);
      return;
    }

    try {
      // IMPORTANT:  We're only using the email to retrieve the user.
      // We're *not* using a password at this point because the biometric
      // authentication *is* the authentication.

      // You might need to fetch the user's provider info if you need
      // to re-authenticate via Google or Apple.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password:
            'biometric_login', // Dummy password as password isn't needed here
      ); //Use an empty password

      _showToast(context, 'Inicio de sesión con biometría correcto',
          toastType: ToastType.success);
      navigateToNextScreen();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in with biometric user: $e');
      }
      _showToast(context, 'Error al iniciar sesión con biometría: $e',
          toastType: ToastType.error);
    }
  }

  void _showToast(BuildContext context, String message,
      {ToastType toastType = ToastType.info}) {
    if (context.mounted) {
      showToast(context, message, toastType: toastType);
    }
  }
}
