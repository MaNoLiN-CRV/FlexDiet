import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart' as provider;

class EmailAuthProvider implements provider.AuthProvider {

  final FirebaseAuth _auth;

  EmailAuthProvider({ required FirebaseAuth auth }):
  _auth = auth;

  @override
  Future<UserCredential?> signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> singOut() {
    // TODO: implement singOut
    throw UnimplementedError();
  }

  Future<UserCredential> signUp({ required String email, required String password }) async {
      UserCredential credential = await _auth.
      createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      return credential;
  }
}