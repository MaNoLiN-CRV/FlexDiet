import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

class UserDiet {
  String id; // UUID
  String? dayId; //day UUID
  List<String>?
      completedMealIds; // Completed meal UUIDs, if the user has completed any meal

  UserDiet({
    required this.id,
    this.dayId,
    this.completedMealIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayId': dayId,
      'completedMealIds': completedMealIds ?? [],
    };
  }

  factory UserDiet.fromJson(Map<String, dynamic> json, String id) {
    return UserDiet(
      id: id,
      dayId: json['dayId'],
      completedMealIds: List<String>.from(json['completedMealIds'] ?? []),
    );
  }

  // Métodos Firestore para UserDiet
  static CollectionReference<UserDiet> get collection =>
      firestore.collection('userDiets').withConverter<UserDiet>(
            fromFirestore: (snapshot, _) =>
                UserDiet.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (userDiet, _) => userDiet.toJson(),
          );

  static Future<UserDiet?> getUserDiet(String userDietId) async {
    final docSnap = await collection.doc(userDietId).get();
    return docSnap.data();
  }

  static Future<void> createUserDiet(UserDiet userDiet) async {
    await collection.doc(userDiet.id).set(userDiet);
  }

  static Future<void> updateUserDiet(UserDiet userDiet) async {
    await collection.doc(userDiet.id).update(userDiet.toJson());
  }

  static Future<void> deleteUserDiet(String userDietId) async {
    await collection.doc(userDietId).delete();
  }
}
