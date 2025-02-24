import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleAuth implements provider.AuthProvider {
  final FirebaseAuth _auth;
  final GoogleSignIn _provider;

  GoogleAuth({required FirebaseAuth auth})
      : _auth = auth,
        _provider = GoogleSignIn();

  @override
  Future<UserCredential?> signIn({String? email, String? password}) async {
    try {
      // Iniciar sesión con GoogleSignIn
      final GoogleSignInAccount? googleUser = await _provider.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in flow
        if (kDebugMode) {
          print("Google Sign-In cancelled by user.");
        }
        return null;
      }

      // Obtener credenciales de firebase a partir del registro con google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Accedemos
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print("Error during Google Sign-In: $e");
      }
      throw e; // Re-throw the error for handling in the UI
    }
  }

  @override
  Future<void> singOut() {
    // TODO: implement singOut
    throw UnimplementedError();
  }
}
