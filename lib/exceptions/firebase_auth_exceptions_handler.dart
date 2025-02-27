import 'package:flutter/foundation.dart';

class FirebaseAuthExceptionsHandler {
  static final FirebaseAuthExceptionsHandler _instance = FirebaseAuthExceptionsHandler._();
  final authException = {
    'email-already-in-use': 'El correo electrónico ya está en uso',
    'weak-password': 'La contraseña es demasiado débil',
    'invalid-email': 'El correo electrónico no es válido',
  };

  FirebaseAuthExceptionsHandler._();

  factory FirebaseAuthExceptionsHandler() {
    return _instance;
  }

  String getExceptionMessage(String exceptionCode) {
    return authException[exceptionCode] ?? 'Error desconocido';
  }
}