import 'entities.dart';

class DirectMessageEntity extends Entity<DirectMessageEntity> {
  static final kEmpty = DirectMessageEntity(
    id: "",
    text: "",
    senderCognitoId: "",
    friendshipId: "",
    createdAt: DateTime.now(),
  );

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
  DirectMessageEntity fromJson(Map<String, dynamic> json) =>
      DirectMessageEntity(
        id: json['_id'],
        text: json['text'],
        senderCognitoId: json['senderCognitoId'],
        friendshipId: json['friendshipId'],
        createdAt: json['createdAt'],
      );

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
