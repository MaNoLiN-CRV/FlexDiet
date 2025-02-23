import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'dart:async'; // Import for StreamController

//* This is a service that manages client authentication.
class AuthService {
  // Firebase auth is a class that acts as an access point to the Firebase Authentication SDK.
  final FirebaseAuth _auth;
  // Controls whether the user is registered or not. May contain null if there is no registered user.
  late final Stream<User?> userStream;
  // Singleton
  static AuthService instance = AuthService._privateConstructor();

  // StreamController for handling sign-out events
  final _signOutController = StreamController<void>.broadcast();
  Stream<void> get signOutStream => _signOutController.stream;

  //We obtain the auth instance. Once obtained we initialize _user
  AuthService._privateConstructor() : _auth = FirebaseAuth.instance {
    userStream = _auth.authStateChanges();
  }

  factory AuthService() {
    return instance;
  }

  // It takes part of Strategy Pattern
  provider.EmailAuth emailAuth() {
    return provider.EmailAuth(auth: _auth);
  }

  provider.GoogleAuth googleAuth() {
    return provider.GoogleAuth(auth: _auth);
  }

  // Sign-out method to invalidate the Firebase Auth state
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _signOutController.add(null); // Notify listeners of sign-out
    } catch (e) {
      print("Error signing out: $e");
      rethrow; // Re-throw the exception for the UI to handle
    }
  }

  void dispose() {
    _signOutController.close();
  }
}
