import 'package:equatable/equatable.dart';

abstract class _User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String cognitoId;
  final String gymId;
  final bool confirmed;

  const _User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.cognitoId,
    required this.gymId,
    required this.confirmed,
  }) : super();

  @override
  List<Object> get props => [
        id,
        firstName,
        lastName,
        cognitoId,
        gymId,
        confirmed,
      ];

  String get fullName => '$firstName $lastName';
}

class UserEntity extends _User {
  final String email;

  const UserEntity({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.cognitoId,
    required super.confirmed,
    required super.gymId,
    required this.email,
  }) : super();

  @override
  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['_id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
      );

  @override
  List<Object> get props => [
        super.props,
        email,
      ];
}

class PublicUserEntity extends _User {
  const PublicUserEntity({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.cognitoId,
    required super.gymId,
    required super.confirmed,
  }) : super();

  @override
  factory PublicUserEntity.fromJson(Map<String, dynamic> json) =>
      PublicUserEntity(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
      );
}

class ProfilePictureUserEntity extends UserEntity {
  final String profilePictureUrl;

  ProfilePictureUserEntity({
    required super.id,
    required super.email,
    required super.cognitoId,
    required super.confirmed,
    required super.firstName,
    required super.gymId,
    required super.lastName,
    required this.profilePictureUrl,
  }) : super();

  @override
  factory ProfilePictureUserEntity.fromJson(Map<String, dynamic> json) =>
      ProfilePictureUserEntity(
        id: json['_id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
        profilePictureUrl: json['profilePictureUrl'],
      );

  factory ProfilePictureUserEntity.fromUserEntity(
    UserEntity user,
    String profilePictureUrl,
  ) =>
      ProfilePictureUserEntity(
        id: user.id,
        email: user.email,
        cognitoId: user.cognitoId,
        confirmed: user.confirmed,
        firstName: user.firstName,
        gymId: user.gymId,
        lastName: user.lastName,
        profilePictureUrl: profilePictureUrl,
      );

  @override
  List<Object> get props => [super.props, profilePictureUrl];
}

class ProfilePicturePublicUserEntity extends PublicUserEntity {
  final String profilePictureUrl;

  ProfilePicturePublicUserEntity({
    required super.id,
    required super.cognitoId,
    required super.confirmed,
    required super.firstName,
    required super.gymId,
    required super.lastName,
    required this.profilePictureUrl,
  }) : super();

  @override
  factory ProfilePicturePublicUserEntity.fromJson(Map<String, dynamic> json) =>
      ProfilePicturePublicUserEntity(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
        profilePictureUrl: json['profilePictureUrl'],
      );

  @override
  List<Object> get props => [super.props, profilePictureUrl];
}
