import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart' as provider;

class GoogleAuth implements provider.AuthProvider {

  final FirebaseAuth _auth;
  final GoogleAuthProvider _provider;

  GoogleAuth({ required FirebaseAuth auth}):
  _auth = auth,
  _provider = GoogleAuthProvider();

  @override
  Future<UserCredential?> signIn({ String? email, String? password }) async{
    UserCredential credential = await _auth.
      signInWithPopup(_provider);
    return credential;
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