import 'package:cloud_firestore/cloud_firestore.dart';

class Swipe {
  String id;

  String user1;

  String user2;

  bool hasBeenSeen;

  String type;

  Timestamp createdAt;

  Swipe(
      {this.id = '',
      this.user1 = '',
      this.user2 = '',
      createdAt,
      this.hasBeenSeen = false,
      this.type = 'dislike'})
      : this.createdAt = createdAt ?? Timestamp.now();

  factory Swipe.fromJson(Map<String, dynamic> parsedJson) {
    return Swipe(
        id: parsedJson['id'] ?? '',
        user1: parsedJson['user1'] ?? '',
        user2: parsedJson['user2'] ?? '',
        createdAt: parsedJson['createdAt'] ??
            parsedJson['created_at'] ??
            Timestamp.now(),
        hasBeenSeen: parsedJson['hasBeenSeen'] ?? false,
        type: parsedJson['type'] ?? 'dislike');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'user1': this.user1,
      'user2': this.user2,
      'created_at': this.createdAt,
      'createdAt': this.createdAt,
      'hasBeenSeen': this.hasBeenSeen,
      'type': this.type
    };
  }
}
