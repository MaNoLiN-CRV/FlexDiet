import 'package:cloud_firestore/cloud_firestore.dart';

class HistoricalBodyweight {
  final DateTime date;
  final double weight;

  HistoricalBodyweight({
    required this.date,
    required this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': Timestamp.fromDate(date),
      'weight': weight,
    };
  }

  factory HistoricalBodyweight.fromJson(Map<String, dynamic> json) {
    return HistoricalBodyweight(
      date: (json['date'] as Timestamp).toDate(),
      weight: json['weight']?.toDouble() ?? 0.0,
    );
  }
}
