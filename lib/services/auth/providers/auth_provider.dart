import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthProvider {
  Future<UserCredential?> signIn({ String? email, String? password });
  Future<void> singOut();
}