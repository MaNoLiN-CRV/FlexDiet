

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart' as provider;

class GoogleAuthProvider implements provider.AuthProvider {

  GoogleAuthProvider();

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
}