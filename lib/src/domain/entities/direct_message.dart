import '../../common/utils/utils.dart';

class DirectMessageEntity with Serializable {
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
  Map<String, dynamic> toJson() => {
        '_id': id,
        'text': text,
        'senderCognitoId': senderCognitoId,
        'friendshipId': friendshipId,
        'createdAt': createdAt.toIso8601String(),
      };
}

class PopulatedDirectMessageEntity extends DirectMessageEntity {
  const PopulatedDirectMessageEntity({
    required super.createdAt,
    required super.friendshipId,
    required super.id,
    required super.senderCognitoId,
    required super.text,
  }) : super();

  @override
  factory PopulatedDirectMessageEntity.fromJson(Map<String, dynamic> json) =>
      PopulatedDirectMessageEntity(
        id: json['_id'],
        text: json['text'],
        senderCognitoId: json['senderCognitoId'],
        friendshipId: json['friendshipId'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'text': text,
        'senderCognitoId': senderCognitoId,
        'friendshipId': friendshipId,
        'createdAt': createdAt.toIso8601String(),
      };
}
