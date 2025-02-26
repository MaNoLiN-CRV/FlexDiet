import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

class Day {
  String id; // UUID
  String? dietId; // Diet reference UUID
  String? name;
  List<String>? mealIds; // Meal reference UUIDs
  Day({
    required this.id,
    this.dietId,
    this.name,
    this.mealIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'dietId': dietId,
      'name': name,
      'mealIds': mealIds ?? [],
    };
  }

  factory Day.fromJson(Map<String, dynamic> json, String id) {
    return Day(
      id: id,
      dietId: json['dietId'],
      name: json['name'],
      mealIds: List<String>.from(json['mealIds'] ?? []),
    );
  }

  // Métodos Firestore para Day
  static CollectionReference<Day> get collection =>
      firestore.collection('days').withConverter<Day>(
            fromFirestore: (snapshot, _) =>
                Day.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (day, _) => day.toJson(),
          );

  static Future<Day?> getDay(String dayId) async {
    final docSnap = await collection.doc(dayId).get();
    return docSnap.data();
  }

  static Future<void> createDay(Day day) async {
    await collection.doc(day.id).set(day);
  }

  static Future<void> updateDay(Day day) async {
    await collection.doc(day.id).update(day.toJson());
  }

  static Future<void> deleteDay(String dayId) async {
    await collection.doc(dayId).delete();
  }
}
