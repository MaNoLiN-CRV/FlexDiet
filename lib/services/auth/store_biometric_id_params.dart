import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

// Constants
const String biometricUserIdKey = 'biometricUserId';

// This function MUST be run in the background
Future<bool> storeBiometricId(StoreBiometricIdParams params) async {
  try {
    // Initialize SharedPreferences *within* the function
    final prefs = await SharedPreferences.getInstance();

    // Encryption
    final encrypter =
        encrypt.Encrypter(encrypt.AES(params.key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(params.uid, iv: params.iv);
    final encryptedBase64 = encrypted.base64; // Store in variable for logging

    if (kDebugMode) {
      print('Encrypted biometric ID: $encryptedBase64');
    }

    // Access global SharedPreferences instance
    await prefs.setString(biometricUserIdKey, encryptedBase64);

    if (kDebugMode) {
      print(
          'Biometric ID stored successfully in shared preferences with key: $biometricUserIdKey');
    }

    return true;
  } catch (e) {
    if (kDebugMode) {
      print('Failed to store biometric ID: $e');
    }
    return false;
  }
}

class StoreBiometricIdParams {
  final String uid;
  final encrypt.Key key;
  final encrypt.IV iv;

  StoreBiometricIdParams({
    required this.uid,
    required this.key,
    required this.iv,
  });
}
