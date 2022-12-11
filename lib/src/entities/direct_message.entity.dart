import 'package:equatable/equatable.dart';

class DirectMessageEntity extends Equatable {
  final String id;
  final String text;
  final String conversationId;
  final String userCognitoId;
  final DateTime createdAt;

  const DirectMessageEntity({
    required this.id,
    required this.text,
    required this.conversationId,
    required this.userCognitoId,
    required this.createdAt,
  }) : super();

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "conversationId": conversationId,
        "userCognitoId": userCognitoId,
        "createdAt": createdAt.toIso8601String(),
      };

  factory DirectMessageEntity.fromJson(Map<String, dynamic> json) =>
      DirectMessageEntity(
        id: json["_id"],
        text: json["text"],
        conversationId: json["conversationId"],
        userCognitoId: json["userCognitoId"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  @override
  List<Object?> get props =>
      [id, text, conversationId, userCognitoId, createdAt];
}
