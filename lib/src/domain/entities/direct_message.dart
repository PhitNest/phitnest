import 'package:equatable/equatable.dart';

class DirectMessageEntity extends Equatable {
  final String id;
  final String text;
  final String senderCognitoId;
  final String friendshipId;
  final DateTime createdAt;

  const DirectMessageEntity({
    required this.id,
    required this.text,
    required this.senderCognitoId,
    required this.friendshipId,
    required this.createdAt,
  }) : super();

  @override
  factory DirectMessageEntity.fromJson(Map<String, dynamic> json) =>
      DirectMessageEntity(
        id: json['_id'],
        text: json['text'],
        senderCognitoId: json['senderCognitoId'],
        friendshipId: json['friendshipId'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  @override
  List<Object> get props => [
        id,
        text,
        senderCognitoId,
        friendshipId,
        createdAt,
      ];
}
