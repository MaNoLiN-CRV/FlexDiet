import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/exceptions/invalid_credentials_exception.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;

class EmailAuth implements provider.AuthProvider {
  final FirebaseAuth _auth;

  EmailAuth({required FirebaseAuth auth}) : _auth = auth;

  @override
  Future<UserCredential?> signIn({String? email, String? password}) async {
    if (email == null || password == null) throw InvalidCredentialsException();
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential;
  }

  @override
  Future<void> singOut() {
    throw UnimplementedError();
  }

  Future<UserCredential> signUp(
      {required String email, required String password}) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential;
  }
}
