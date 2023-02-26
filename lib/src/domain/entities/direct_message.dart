part of entities;

class DirectMessageEntity extends Equatable with Serializable {
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

  @override
  List<Object?> get props =>
      [id, text, senderCognitoId, friendshipId, createdAt];
}

class PopulatedDirectMessageEntity extends DirectMessageEntity {
  final PublicUserEntity sender;
  final PublicUserEntity recipient;

  const PopulatedDirectMessageEntity({
    required super.createdAt,
    required super.friendshipId,
    required super.id,
    required super.senderCognitoId,
    required super.text,
    required this.sender,
    required this.recipient,
  }) : super();

  @override
  factory PopulatedDirectMessageEntity.fromJson(Map<String, dynamic> json) =>
      PopulatedDirectMessageEntity(
        id: json['_id'],
        text: json['text'],
        senderCognitoId: json['senderCognitoId'],
        friendshipId: json['friendshipId'],
        createdAt: DateTime.parse(json['createdAt']),
        sender: PublicUserEntity.fromJson(json['sender']),
        recipient: PublicUserEntity.fromJson(json['recipient']),
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'sender': sender.toJson(),
        'recipient': recipient.toJson(),
      };

  @override
  List<Object?> get props => [...super.props, sender, recipient];
}
