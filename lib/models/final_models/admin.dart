import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

/// Entidad Admin
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

  static Future<Admin?> getAdmin(String adminId) async {
    final docSnap = await collection.doc(adminId).get();
    return docSnap.data();
  }

  static Future<void> createAdmin(Admin admin) async {
    await collection.doc(admin.id).set(admin);
  }

  static Future<void> updateAdmin(Admin admin) async {
    await collection.doc(admin.id).update(admin.toJson());
  }

  static Future<void> deleteAdmin(String adminId) async {
    await collection.doc(adminId).delete();
  }
}
