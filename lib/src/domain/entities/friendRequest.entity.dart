import 'package:equatable/equatable.dart';

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

  factory FriendRequestEntity.fromJson(Map<String, dynamic> json) =>
      FriendRequestEntity(
        id: json['_id'],
        createdAt: json['createdAt'],
        denied: json['denied'],
        fromCognitoId: json['fromCognitoId'],
        toCognitoId: json['toCognitoId'],
      );

  @override
  List<Object?> get props => [
        id,
        createdAt,
        denied,
        fromCognitoId,
        toCognitoId,
      ];
}
