
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart' as provider;

//* This is a service that manages client authentication.
class AuthService {
  // Firebase auth is a class that acts as an access point to the Firebase Authentication SDK. 
  final FirebaseAuth _auth;
  // Controls whether the user is registered or not. May contain null if there is no registered user.
  late final Stream<User?> _user;
  // Singleton
  static AuthService instance = AuthService._privateConstructor();

  //We obtain the auth instance. Once obtained we initialize _user
  AuthService._privateConstructor():
    _auth = FirebaseAuth.instance {
      _user = _auth.authStateChanges();
    }
    
  factory AuthService() {
    return instance;
  }

  // It takes part of Strategy Pattern
  provider.AuthProvider emailAuth() {
    return provider.EmailAuth(
      auth: _auth
    );
  }

  provider.AuthProvider googleAuth() {
    return provider.GoogleAuth(
      auth: _auth
    );
  }
}