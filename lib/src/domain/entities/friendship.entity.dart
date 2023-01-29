import 'entities.dart';

class FriendshipEntity extends Entity<FriendshipEntity> {
  static final kEmpty = FriendshipEntity(
    id: "",
    userCognitoIds: [],
    createdAt: DateTime.now(),
  );

  final String id;
  final List<String> userCognitoIds;
  final DateTime createdAt;

  FriendshipEntity({
    required this.id,
    required this.userCognitoIds,
    required this.createdAt,
  }) : super();

  @override
  FriendshipEntity fromJson(Map<String, dynamic> json) => FriendshipEntity(
        id: json['_id'],
        userCognitoIds: json['userCognitoIds'],
        createdAt: json['createdAt'],
      );

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'userCognitoIds': userCognitoIds,
        'createdAt': createdAt,
      };

  @override
  List<Object?> get props => [id, userCognitoIds, createdAt];
}

class PopulatedFriendshipEntity extends FriendshipEntity {
  static final kEmpty = PopulatedFriendshipEntity(
    id: "",
    userCognitoIds: [],
    createdAt: DateTime.now(),
    friend: PublicUserEntity.kEmpty,
  );

  final PublicUserEntity friend;

  PopulatedFriendshipEntity({
    required super.id,
    required super.userCognitoIds,
    required super.createdAt,
    required this.friend,
  }) : super();

  @override
  PopulatedFriendshipEntity fromJson(Map<String, dynamic> json) =>
      PopulatedFriendshipEntity(
        id: json['_id'],
        userCognitoIds: json['userCognitoIds'],
        createdAt: json['createdAt'],
        friend: Entities.fromJson(json['friend']),
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'friend': friend.toJson(),
      };

  @override
  List<Object> get props => [super.props, friend];
}
