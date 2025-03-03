import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

class Template {
  String id;
  String name;
  String description;
  List<String> dayIds; // References to Day entities
  int calories;
  String type; // e.g., "muscle_gain", "weight_loss",

  Template({
    required this.id,
    required this.name,
    required this.description,
    required this.dayIds,
    required this.calories,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'dayIds': dayIds,
      'calories': calories,
      'type': type,
    };
  }

  factory Template.fromJson(Map<String, dynamic> json, String id) {
    return Template(
      id: id,
      name: json['name'],
      description: json['description'],
      dayIds: List<String>.from(json['dayIds'] ?? []),
      calories: json['calories'],
      type: json['type'],
    );
  }

  static CollectionReference<Template> get collection =>
      firestore.collection('templates').withConverter<Template>(
            fromFirestore: (snapshot, _) =>
                Template.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (template, _) => template.toJson(),
          );

  static Future<Template> getTemplate(String templateId) async {
    final docSnap = await collection.doc(templateId).get();
    return docSnap.data()!;
  }

  static Future<bool> createTemplate(Template template) async {
    try {
      await collection.doc(template.id).set(template);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateTemplate(Template template) async {
    try {
      await collection.doc(template.id).update(template.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteTemplate(String templateId) async {
    try {
      await collection.doc(templateId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
