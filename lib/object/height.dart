import 'package:cloud_firestore/cloud_firestore.dart';

class Height {
  Height(this.height, this.date);
  final num height;
  final DateTime date;

  Height.fromJsonFireBase(Map<String, dynamic> json, DocumentSnapshot snapshot)
      : height = json["height"].toDouble(),
        date = json["timestamp"].toDate();

  Map<String, dynamic> toJsonFireBase() => {
        'height': height,
        'timestamp': date,
      };
}
