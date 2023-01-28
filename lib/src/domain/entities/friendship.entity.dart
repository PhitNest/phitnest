import 'package:equatable/equatable.dart';

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
