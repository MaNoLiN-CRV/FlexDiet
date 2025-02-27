import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

class Meal {
  String id; // UUID
  String? name;
  String? protein;
  String? carbs;
  String? image;

  Meal({
    required this.id,
    this.name,
    this.protein,
    this.carbs,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'protein': protein,
      'carbs': carbs,
      'image': image,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json, String id) {
    return Meal(
      id: id,
      name: json['name'],
      protein: json['protein'],
      carbs: json['carbs'],
      image: json['image'],
    );
  }

  // Métodos Firestore para Meal
  static CollectionReference<Meal> get collection =>
      firestore.collection('meals').withConverter<Meal>(
            fromFirestore: (snapshot, _) =>
                Meal.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (meal, _) => meal.toJson(),
          );

  static Future<Meal> getMeal(String mealId) async {
      final docSnap = await collection.doc(mealId).get();
      return docSnap.data()!;
  }

  static Future<bool> createMeal(Meal meal) async {
    try {
      await collection.doc(meal.id).set(meal);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateMeal(Meal meal) async {
    try {
      await collection.doc(meal.id).update(meal.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteMeal(String mealId) async {
    try {
      await collection.doc(mealId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}

