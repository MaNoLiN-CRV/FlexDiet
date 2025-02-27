import '../../firebase_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirestoreService.firestore;

class Client {
  String id; // UUID en el esquema, Firestore genera el ID automáticamente
  String username;
  String? dietId; // Diet reference
  String? sex;
  double? bodyweight;
  double? height;
  String? description;

  Client({
    required this.id,
    required this.username,
    this.dietId,
    this.sex,
    this.bodyweight,
    this.height,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'dietId': dietId,
      'sex': sex,
      'bodyweight': bodyweight,
      'height': height,
      'description': description,
    };
  }

  factory Client.fromJson(Map<String, dynamic> json, String id) {
    return Client(
      id: id,
      username: json['username'] ?? '',
      dietId: json['dietId'],
      sex: json['sex'],
      bodyweight:
          json['bodyweight'] != null ? json['bodyweight'].toDouble() : null,
      height: json['height'] != null ? json['height'].toDouble() : null,
      description: json['description'],
    );
  }

  // Métodos Firestore para Cliente
  static CollectionReference<Client> get collection =>
      firestore.collection('clients').withConverter<Client>(
            fromFirestore: (snapshot, _) =>
                Client.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (client, _) => client.toJson(),
          );

  static Future<Client> getClient(String clientId) async {
    final docSnap = await collection.doc(clientId).get();
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
}

