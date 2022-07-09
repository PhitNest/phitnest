class Relation {
  String relationId;
  String userId;
  String targetId;
  String type;

  /// This can either be DateTime type or Timestamp (from firestore package) type.
  /// This is the timestamp that the relation was authored at
  dynamic timestamp;

  Relation({
    required this.relationId,
    required this.userId,
    required this.targetId,
    required this.type,
    required this.timestamp,
  });

  factory Relation.fromJson(Map<String, dynamic> parsedJson) => Relation(
        relationId: parsedJson['relationId'],
        userId: parsedJson['userId'],
        targetId: parsedJson['targetId'],
        type: parsedJson['type'],
        timestamp: parsedJson['timestamp'],
      );

  Map<String, dynamic> toJson() => {
        'relationId': relationId,
        'userId': userId,
        'targetId': targetId,
        'type': type,
        'timestamp': timestamp,
      };
}