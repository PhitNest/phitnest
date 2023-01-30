import '../../common/utils/utils.dart';
import 'entities.dart';

class FriendshipParser extends Parser<FriendshipEntity> {
  @override
  FriendshipEntity fromJson(Map<String, dynamic> json) => FriendshipEntity(
        id: json['_id'],
        userCognitoIds: json['userCognitoIds'],
        createdAt: json['createdAt'],
      );
}

class FriendshipEntity extends Entity {
  final String id;
  final List<String> userCognitoIds;
  final DateTime createdAt;

  FriendshipEntity({
    required this.id,
    required this.userCognitoIds,
    required this.createdAt,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'userCognitoIds': userCognitoIds,
        'createdAt': createdAt,
      };

  @override
  List<Object?> get props => [id, userCognitoIds, createdAt];
}

class PopulatedFriendshipParser extends Parser<PopulatedFriendshipEntity> {
  @override
  PopulatedFriendshipEntity fromJson(Map<String, dynamic> json) =>
      PopulatedFriendshipEntity(
        id: json['_id'],
        userCognitoIds: json['userCognitoIds'],
        createdAt: json['createdAt'],
        friend: PublicUserParser().fromJson(json['friend']),
      );
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
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'friend': friend.toJson(),
      };

  @override
  List<Object> get props => [super.props, friend];
}
