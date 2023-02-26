part of entities;

class FriendshipEntity with Serializable {
  final String id;
  final List<String> userCognitoIds;
  final DateTime createdAt;

  FriendshipEntity({
    required this.id,
    required this.userCognitoIds,
    required this.createdAt,
  }) : super();

  @override
  factory FriendshipEntity.fromJson(Map<String, dynamic> json) =>
      FriendshipEntity(
        id: json['_id'],
        userCognitoIds: List<String>.from(json['userCognitoIds']),
        createdAt: DateTime.parse(json['createdAt']),
      );

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'userCognitoIds': userCognitoIds,
        'createdAt': createdAt.toIso8601String(),
      };
}

class PopulatedFriendshipEntity extends FriendshipEntity {
  final PublicUserEntity friend;

  PopulatedFriendshipEntity({
    required super.id,
    required super.userCognitoIds,
    required super.createdAt,
    required this.friend,
  }) : super();

  @override
  factory PopulatedFriendshipEntity.fromJson(Map<String, dynamic> json) =>
      PopulatedFriendshipEntity(
        id: json['_id'],
        userCognitoIds: List<String>.from(json['userCognitoIds']),
        createdAt: DateTime.parse(json['createdAt']),
        friend: PublicUserEntity.fromJson(json['friend']),
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'friend': friend.toJson(),
      };
}
