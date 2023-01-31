import '../../common/utils/utils.dart';
import 'entities.dart';

abstract class _User<UserType> extends Entity {
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
  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'cognitoId': cognitoId,
        'gymId': gymId,
        'confirmed': confirmed,
      };

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        cognitoId,
        gymId,
        confirmed,
      ];
}

class UserParser extends Parser<UserEntity> {
  const UserParser() : super();

  @override
  UserEntity fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['_id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
      );
}

class UserEntity extends _User<UserEntity> {
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
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'email': email,
      };

  @override
  List<Object?> get props => [
        super.props,
        email,
      ];
}

class PublicUserParser extends Parser<PublicUserEntity> {
  const PublicUserParser() : super();

  @override
  PublicUserEntity fromJson(Map<String, dynamic> json) => PublicUserEntity(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
      );
}

class PublicUserEntity extends _User<PublicUserEntity> {
  const PublicUserEntity({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.cognitoId,
    required super.gymId,
    required super.confirmed,
  }) : super();
}

class ProfilePictureUserParser extends Parser<ProfilePictureUserEntity> {
  const ProfilePictureUserParser() : super();

  @override
  ProfilePictureUserEntity fromJson(Map<String, dynamic> json) =>
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
  List<Object?> get props => [super.props, profilePictureUrl];
}

class ProfilePicturePublicUserParser
    extends Parser<ProfilePicturePublicUserEntity> {
  @override
  ProfilePicturePublicUserEntity fromJson(Map<String, dynamic> json) =>
      ProfilePicturePublicUserEntity(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
        profilePictureUrl: json['profilePictureUrl'],
      );
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
  List<Object?> get props => [super.props, profilePictureUrl];
}
