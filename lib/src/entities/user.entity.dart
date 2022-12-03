import 'package:equatable/equatable.dart';

class ExploreUserEntity extends Equatable {
  final String cognitoId;
  final String firstName;
  final String lastName;

  ExploreUserEntity({
    required this.cognitoId,
    required this.firstName,
    required this.lastName,
  });

  factory ExploreUserEntity.fromJson(Map<String, dynamic> json) =>
      ExploreUserEntity(
        cognitoId: json['cognitoId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
      );

  Map<String, dynamic> toJson() => {
        'cognitoId': cognitoId,
        'firstName': firstName,
        'lastName': lastName,
      };

  @override
  List<Object?> get props => [cognitoId, firstName, lastName];
}

class PublicUserEntity extends ExploreUserEntity {
  final String gymId;

  PublicUserEntity({
    required super.cognitoId,
    required super.firstName,
    required super.lastName,
    required this.gymId,
  }) : super();

  factory PublicUserEntity.fromJson(Map<String, dynamic> json) =>
      PublicUserEntity(
        cognitoId: json['cognitoId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gymId: json['gymId'],
      );

  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'gymId': gymId,
      };

  @override
  List<Object?> get props => [...super.props, gymId];
}

class UserEntity extends PublicUserEntity {
  final String email;

  UserEntity({
    required super.cognitoId,
    required super.firstName,
    required super.lastName,
    required super.gymId,
    required this.email,
  }) : super();

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        cognitoId: json['cognitoId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gymId: json['gymId'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'email': email,
      };

  @override
  List<Object?> get props => [...super.props, email];
}
