import 'package:equatable/equatable.dart';

class DirectMessageResponse extends Equatable {
  final String id;
  final String text;
  final String senderCognitoId;
  final String friendshipId;
  final DateTime createdAt;

  DirectMessageResponse({
    required this.id,
    required this.text,
    required this.senderCognitoId,
    required this.friendshipId,
    required this.createdAt,
  }) : super();

  factory DirectMessageResponse.fromJson(Map<String, dynamic> json) =>
      DirectMessageResponse(
        id: json['_id'],
        text: json['text'],
        senderCognitoId: json['senderCognitoId'],
        friendshipId: json['friendshipId'],
        createdAt: json['createdAt'],
      );

  @override
  List<Object?> get props => [
        id,
        text,
        senderCognitoId,
        friendshipId,
        createdAt,
      ];
}
