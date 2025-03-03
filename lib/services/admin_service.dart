import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  bool? _isAdmin;
  String? _currentUserEmail;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _initialized = false;

  factory AdminService() {
    return _instance;
  }

  AdminService._internal() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user == null || user.email != _currentUserEmail) {
        _isAdmin = null;
        _currentUserEmail = null;
        _initialized = false;
      }
    });
  }

  Future<void> initialize() async {
    if (_initialized) return;

    final user = _auth.currentUser;
    if (user?.email != null) {
      await _checkAdminStatus(user!.email!);
    }
    _initialized = true;
  }

  Future<void> _checkAdminStatus(String email) async {
    try {
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .where('email', isEqualTo: email)
          .get();

      _isAdmin = adminDoc.docs.isNotEmpty;
      _currentUserEmail = email;
    } catch (e) {
      print('Error checking admin status: $e');
      _isAdmin = false;
    }
  }

  Future<bool> isUserAdmin() async {
    if (!_initialized) {
      await initialize();
    }

    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      return false;
    }

    if (_isAdmin != null && user.email == _currentUserEmail) {
      return _isAdmin!;
    }

    await _checkAdminStatus(user.email!);
    return _isAdmin ?? false;
  }

  void clearAdminStatus() {
    _isAdmin = null;
    _currentUserEmail = null;
    _initialized = false;
  }
}
