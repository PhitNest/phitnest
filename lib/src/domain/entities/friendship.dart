part of entities;

class FriendshipEntity extends Equatable with Serializable {
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

  @override
  List<Object?> get props => [id, userCognitoIds, createdAt];
}

class PopulatedFriendshipEntity extends FriendshipEntity {
  final Tuple2<PublicUserEntity, PublicUserEntity> friends;

  PublicUserEntity notMe(String myCognitoId) =>
      friends.value1.cognitoId == myCognitoId ? friends.value2 : friends.value1;

  PopulatedFriendshipEntity({
    required super.id,
    required super.userCognitoIds,
    required super.createdAt,
    required this.friends,
  }) : super();

  @override
  factory PopulatedFriendshipEntity.fromJson(Map<String, dynamic> json) =>
      PopulatedFriendshipEntity(
        id: json['_id'],
        userCognitoIds: List<String>.from(json['userCognitoIds']),
        createdAt: DateTime.parse(json['createdAt']),
        friends: Tuple2(PublicUserEntity.fromJson(json['friends'][0]),
            PublicUserEntity.fromJson(json['friends'][1])),
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'friends': [friends.value1.toJson(), friends.value2.toJson()],
      };

  @override
  List<Object?> get props => [super.props, friends];
}
