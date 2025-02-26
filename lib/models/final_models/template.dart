import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';

final firestore = FirestoreService.firestore;

class Template {
  String id; // UUID
  String? dietId;
  List<String>? completedMealIds;

  Template({
    required this.id,
    this.dietId,
    this.completedMealIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'dietId': dietId,
      'completedMealIds': completedMealIds ?? [],
    };
  }

  factory Template.fromJson(Map<String, dynamic> json, String id) {
    return Template(
      id: id,
      dietId: json['dietId'],
      completedMealIds: List<String>.from(json['completedMealIds'] ?? []),
    );
  }

  static CollectionReference<Template> get collection =>
      firestore.collection('templates').withConverter<Template>(
            fromFirestore: (snapshot, _) =>
                Template.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (template, _) => template.toJson(),
          );

  static Future<Template?> getTemplate(String templateId) async {
    final docSnap = await collection.doc(templateId).get();
    return docSnap.data();
  }

  static Future<void> createTemplate(Template template) async {
    await collection.doc(template.id).set(template);
  }

  static Future<void> updateTemplate(Template template) async {
    await collection.doc(template.id).update(template.toJson());
  }

  static Future<void> deleteTemplate(String templateId) async {
    await collection.doc(templateId).delete();
  }
}
