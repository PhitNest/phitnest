import '../../common/utils/utils.dart';

abstract class User with Serializable {
  final String id;
  final String firstName;
  final String lastName;
  final String cognitoId;
  final String gymId;
  final bool confirmed;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.cognitoId,
    required this.gymId,
    required this.confirmed,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'cognitoId': cognitoId,
        'gymId': gymId,
        'confirmed': confirmed,
      };

  String get fullName => '$firstName $lastName';
}

class UserEntity extends User {
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
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'email': email,
      };
}

class PublicUserEntity extends User with Serializable {
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

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'profilePictureUrl': profilePictureUrl,
      };
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
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'profilePictureUrl': profilePictureUrl,
      };
}
