import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

class UserDiet {
  String id;
  String templateId; // Reference to the template this diet is based on
  List<String> completedMealIds; // Array of completed meals for the current day
  DateTime lastUpdated; // To track when the completed meals were last reset

  UserDiet({
    required this.id,
    required this.templateId,
    List<String>? completedMealIds,
    DateTime? lastUpdated,
  })  : completedMealIds = completedMealIds ?? [],
        lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'templateId': templateId,
      'completedMealIds': completedMealIds,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory UserDiet.fromJson(Map<String, dynamic> json, String id) {
    return UserDiet(
      id: id,
      templateId: json['templateId'],
      completedMealIds: List<String>.from(json['completedMealIds'] ?? []),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  static CollectionReference<UserDiet> get collection =>
      firestore.collection('userDiets').withConverter<UserDiet>(
            fromFirestore: (snapshot, _) =>
                UserDiet.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (userDiet, _) => userDiet.toJson(),
          );

  static Future<UserDiet> getUserDiet(String userDietId) async {
    final docSnap = await collection.doc(userDietId).get();
    return docSnap.data()!;
  }

  static Future<bool> createUserDiet(UserDiet userDiet) async {
    try {
      await collection.doc(userDiet.id).set(userDiet);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateUserDiet(UserDiet userDiet) async {
    try {
      await collection.doc(userDiet.id).update(userDiet.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteUserDiet(String userDietId) async {
    try {
      await collection.doc(userDietId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
