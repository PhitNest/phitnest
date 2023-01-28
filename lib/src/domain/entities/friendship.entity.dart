import 'package:equatable/equatable.dart';

import 'entities.dart';

class FriendshipEntity extends Equatable {
  final String id;
  final List<String> userCognitoIds;
  final DateTime createdAt;

  FriendshipEntity({
    required this.id,
    required this.userCognitoIds,
    required this.createdAt,
  }) : super();

  factory FriendshipEntity.fromJson(Map<String, dynamic> json) =>
      FriendshipEntity(
        id: json['_id'],
        userCognitoIds: json['userCognitoIds'],
        createdAt: json['createdAt'],
      );

  @override
  List<Object?> get props => [id, userCognitoIds, createdAt];
}

class PopulatedFriendshipEntity extends FriendshipEntity {
  final PublicUserEntity friend;

  PopulatedFriendshipEntity({
    required super.id,
    required super.userCognitoIds,
    required super.createdAt,
    required this.friend,
  }) : super();

  factory PopulatedFriendshipEntity.fromJson(Map<String, dynamic> json) =>
      PopulatedFriendshipEntity(
        id: json['_id'],
        userCognitoIds: json['userCognitoIds'],
        createdAt: json['createdAt'],
        friend: PublicUserEntity.fromJson(json['friend']),
      );

  @override
  List<Object> get props => [super.props, friend];
}

class DirectMessageEntity extends Equatable {
  final String id;
  final String text;
  final String senderCognitoId;
  final String friendshipId;
  final DateTime createdAt;

  DirectMessageEntity({
    required this.id,
    required this.text,
    required this.senderCognitoId,
    required this.friendshipId,
    required this.createdAt,
  }) : super();

  factory DirectMessageEntity.fromJson(Map<String, dynamic> json) =>
      DirectMessageEntity(
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
