import 'package:cloud_firestore/cloud_firestore.dart';

class SwipeCounter {
  String authorID;

  int count;

  Timestamp createdAt;

  SwipeCounter({this.authorID = '', this.count = 0, createdAt})
      : this.createdAt = createdAt ?? Timestamp.now();

  factory SwipeCounter.fromJson(Map<String, dynamic> parsedJson) {
    return SwipeCounter(
        authorID: parsedJson['authorID'] ?? '',
        count: parsedJson['count'] ?? 0,
        createdAt: parsedJson['createdAt']);
  }

  Map<String, dynamic> toJson() {
    return {
      'authorID': this.authorID,
      'count': this.count,
      'createdAt': this.createdAt
    };
  }
}
