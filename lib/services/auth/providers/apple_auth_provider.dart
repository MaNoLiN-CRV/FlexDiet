import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/auth_provider.dart'
    as provider;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthProvider implements provider.AuthProvider {
  FirebaseAuth _auth;

  AppleAuthProvider(FirebaseAuth auth) : _auth = auth;

  @override
  Future<UserCredential?> signIn({String? email, String? password}) async {
    // Iniciar sesión con GoogleSignIn
    final AuthorizationCredentialAppleID appleCredentials =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Obtener credenciales de firebase a partir del registro con google
    final credential = await _getFirebaseCredential(appleCredentials);

    //Accedemos
    return await _auth.signInWithCredential(credential);
  }

  Future<AuthCredential> _getFirebaseCredential(
      AuthorizationCredentialAppleID? appleUser) async {
    // Obtener las credenciales de autenticación de Google, te lleva a una zona de registro con google si el
    // usuario inicia sesión te devuelve GoogleSignInAuthentication. Si no null
    if (appleUser == null) {
      return throw Exception('Error');
    }

    return GoogleAuthProvider.credential(
      accessToken: appleUser.identityToken,
      idToken: appleUser.authorizationCode,
    );
  }

  @override
  Future<void> singOut() {
    // TODO: implement singOut
    throw UnimplementedError();
  }
}
