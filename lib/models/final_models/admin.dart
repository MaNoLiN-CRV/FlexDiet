import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

class Admin {
  String id; // UUID en el esquema

  String username;

  Admin({
    required this.id,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json, String id) {
    return Admin(
      id: id,
      username: json['username'] ?? '',
    );
  }

  static CollectionReference<Admin> get collection =>
      firestore.collection('admins').withConverter<Admin>(
            fromFirestore: (snapshot, _) =>
                Admin.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (admin, _) => admin.toJson(),
          );

  static Future<Admin> getAdmin(String adminId) async {
    final docSnap = await collection.doc(adminId).get();
    return docSnap.data()!;
  }

  static Future<bool> createAdmin(Admin admin) async {
    try {
      await collection.doc(admin.id).set(admin);
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  static Future<bool> updateAdmin(Admin admin) async {
    try {
      await collection.doc(admin.id).update(admin.toJson());
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  static Future<bool> deleteAdmin(String adminId) async {
    try {
      await collection.doc(adminId).delete();
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }
}

