import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthProvider {
  Future<UserCredential?> signIn();
  Future<void> singOut();
}