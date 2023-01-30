import '../../common/utils/utils.dart';
import 'entities.dart';

class DirectMessageParser extends Parser<DirectMessageEntity> {
  const DirectMessageParser() : super();

  @override
  DirectMessageEntity fromJson(Map<String, dynamic> json) =>
      DirectMessageEntity(
        id: json['_id'],
        text: json['text'],
        senderCognitoId: json['senderCognitoId'],
        friendshipId: json['friendshipId'],
        createdAt: json['createdAt'],
      );
}

class DirectMessageEntity extends Entity {
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
  Map<String, dynamic> toJson() => {
        '_id': id,
        'text': text,
        'senderCognitoId': senderCognitoId,
        'friendshipId': friendshipId,
        'createdAt': createdAt,
      };

  @override
  List<Object?> get props => [
        id,
        text,
        senderCognitoId,
        friendshipId,
        createdAt,
      ];
}
