import 'package:equatable/equatable.dart';

import 'entities.dart';

class FriendRequestEntity extends Equatable {
  final String id;
  final String fromCognitoId;
  final String toCognitoId;
  final bool denied;
  final DateTime createdAt;

  FriendRequestEntity({
    required this.id,
    required this.createdAt,
    required this.denied,
    required this.fromCognitoId,
    required this.toCognitoId,
  }) : super();

  @override
  factory FriendRequestEntity.fromJson(Map<String, dynamic> json) =>
      FriendRequestEntity(
        id: json['_id'],
        createdAt: json['createdAt'],
        denied: json['denied'],
        fromCognitoId: json['fromCognitoId'],
        toCognitoId: json['toCognitoId'],
      );

  @override
  List<Object> get props => [
        id,
        createdAt,
        denied,
        fromCognitoId,
        toCognitoId,
      ];
}

class PopulatedFriendRequestEntity extends FriendRequestEntity {
  final PublicUserEntity fromUser;

  PopulatedFriendRequestEntity({
    required super.id,
    required super.createdAt,
    required super.denied,
    required super.fromCognitoId,
    required super.toCognitoId,
    required this.fromUser,
  }) : super();

  @override
  factory PopulatedFriendRequestEntity.fromJson(Map<String, dynamic> json) =>
      PopulatedFriendRequestEntity(
        id: json['_id'],
        createdAt: json['createdAt'],
        denied: json['denied'],
        fromCognitoId: json['fromCognitoId'],
        toCognitoId: json['toCognitoId'],
        fromUser: PublicUserEntity.fromJson(json['fromUser']),
      );

  @override
  List<Object> get props => [
        super.props,
        fromUser,
      ];
}
