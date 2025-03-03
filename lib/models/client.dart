import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flexdiet/firebase_firestore.dart';
import 'package:flutter_flexdiet/models/models.dart';

final firestore = FirestoreService.firestore;

class Client {
  String id;
  String username;
  String email;
  String? image;
  String? userDietId;
  String? sex;
  double? bodyweight;
  double? height;
  String? description;
  List<HistoricalBodyweight> bodyweightHistory;

  Client({
    required this.id,
    required this.username,
    required this.email,
    this.image,
    this.userDietId,
    this.sex,
    this.bodyweight,
    this.height,
    this.description,
    List<HistoricalBodyweight>? bodyweightHistory,
  }) : bodyweightHistory = bodyweightHistory ?? [];

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'image': image,
      'userDietId': userDietId,
      'sex': sex,
      'bodyweight': bodyweight,
      'height': height,
      'description': description,
      'bodyweightHistory': bodyweightHistory.map((h) => h.toJson()).toList(),
    };
  }

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    return Client(
      id: id,
      image: json['image'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      userDietId: json['userDietId'],
      sex: json['sex'],
      bodyweight: json['bodyweight']?.toDouble(),
      height: json['height']?.toDouble(),
      description: json['description'],
      bodyweightHistory: (json['bodyweightHistory'] as List<dynamic>?)
              ?.map((h) => HistoricalBodyweight.fromJson(h))
              .toList() ??
          [],
    );
  }

  static CollectionReference<Client> get collection =>
      firestore.collection('clients').withConverter<Client>(
            fromFirestore: (snapshot, _) =>
                Client.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (client, _) => client.toJson(),
          );

  static Future<Client> getClient(String clientId) async {
    final docSnap = await collection.doc(clientId).get();
    print('Joder ${docSnap.data()} / el clientId es $clientId');
    return docSnap.data()!;
  }

  static Future<bool> createClient(Client client) async {
    try {
      await collection.doc(client.id).set(client);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateClient(Client client) async {
    try {
      await collection.doc(client.id).update(client.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteClient(String clientId) async {
    try {
      await collection.doc(clientId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Add method to update bodyweight with history
  Future<bool> updateBodyweight(double newWeight) async {
    try {
      bodyweight = newWeight;
      bodyweightHistory.add(
        HistoricalBodyweight(
          date: DateTime.now(),
          weight: newWeight,
        ),
      );

      // Sort history by date
      bodyweightHistory.sort((a, b) => b.date.compareTo(a.date));

      // Keep only last 8 entries
      if (bodyweightHistory.length > 8) {
        bodyweightHistory = bodyweightHistory.take(8).toList();
      }

      return await updateClient(this);
    } catch (e) {
      print('Error updating bodyweight: $e');
      return false;
    }
  }
}
