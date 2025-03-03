import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_flexdiet/services/auth/providers/providers.dart'
    as provider;
import 'dart:async';
import 'package:flutter_flexdiet/services/admin_service.dart';

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

  AuthService._privateConstructor() : _auth = FirebaseAuth.instance {
    userStream = _auth.authStateChanges();
  }

  factory AuthService() {
    return instance;
  }

  provider.EmailAuth emailAuth() {
    return provider.EmailAuth(auth: _auth);
  }

  provider.GoogleAuth googleAuth() {
    return provider.GoogleAuth(auth: _auth);
  }

  provider.AppleAuthProvider appleAuth() {
    return provider.AppleAuthProvider(_auth);
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      AdminService().clearAdminStatus(); // Clear admin status on logout
      _signOutController.add(null);
    } catch (e) {
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;

  void dispose() {
    _signOutController.close();
  }
}
