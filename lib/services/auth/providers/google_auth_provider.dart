import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth implements provider.AuthProvider {
  final FirebaseAuth _auth;
  final GoogleSignIn _provider;

  GoogleAuth({required FirebaseAuth auth})
      : _auth = auth,
        _provider = GoogleSignIn();

  @override
  Future<UserCredential?> signIn({String? email, String? password}) async {
    // Iniciar sesión con GoogleSignIn
    final GoogleSignInAccount? googleUser = await _provider.signIn();

    // Obtener credenciales de firebase a partir del registro con google
    final credential = await _getFirebaseCredential(googleUser);

    //Accedemos
    return await _auth.signInWithCredential(credential);
  }

  Future<AuthCredential> _getFirebaseCredential(
      GoogleSignInAccount? googleUser) async {
    // Obtener las credenciales de autenticación de Google, te lleva a una zona de registro con google si el
    // usuario inicia sesión te devuelve GoogleSignInAuthentication. Si no null
    if (googleUser == null) {
      return throw Exception('Jodido');
    }

    // Contiene accessToken que nos permite acceder a los servicios de google y idToken que sirve para acceder a firebase
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Creamos una credencial de Firebase con las credenciales de Google
    if (googleAuth == null) {
      return throw Exception('Jodido');
    }
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  @override
  Future<void> singOut() {
    // TODO: implement singOut
    throw UnimplementedError();
  }
}
