import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

class Meal {
  String id; // UUID
  String? name;
  String? description;
  num? protein;
  num? calories;
  num? carbs;
  String? image;
  String? timeOfDay;
  String? ingredients;

  Meal(
      {required this.id,
      this.name,
      this.description,
      this.protein,
      this.calories,
      this.carbs,
      this.image,
      this.timeOfDay,
      this.ingredients});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'protein': protein,
      'calories': calories,
      'carbs': carbs,
      'image': image,
      'timeOfDay': timeOfDay,
      'description': description,
      'ingredients': ingredients
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json, String id) {
    return Meal(
      id: id,
      name: json['name'],
      protein: json['protein'],
      calories: json['calories'],
      carbs: json['carbs'],
      image: json['image'],
      timeOfDay: json['timeOfDay'],
      description: json['description'],
      ingredients: json['ingredients'],
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

  static Future<List<Meal>> getMeals(List<String> mealIds) async {
    if (mealIds.isEmpty) return [];

    // Get meals in batches of 10 to avoid too many concurrent reads
    const batchSize = 10;
    final batches = <List<String>>[];

    for (var i = 0; i < mealIds.length; i += batchSize) {
      batches.add(mealIds.skip(i).take(batchSize).toList());
    }

    final allMeals = <Meal>[];

    for (final batch in batches) {
      final snapshots =
          await Future.wait(batch.map((id) => collection.doc(id).get()));
      allMeals.addAll(snapshots.map((s) => s.data()!));
    }

    return allMeals;
  }
}
