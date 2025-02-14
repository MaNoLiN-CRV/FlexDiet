import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart' as provider;

class GoogleAuthProvider implements provider.AuthProvider {

  final FirebaseAuth _auth;

  GoogleAuthProvider({ required FirebaseAuth auth}):
  _auth = auth;

  @override
  Future<UserCredential?> signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<UserCredential?> signUp() {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<void> singOut() {
    // TODO: implement singOut
    throw UnimplementedError();
  }
}