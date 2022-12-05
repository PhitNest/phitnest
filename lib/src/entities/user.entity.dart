import 'package:equatable/equatable.dart';

class ExploreUserEntity extends Equatable {
  final String id;
  final String cognitoId;
  final String firstName;
  final String lastName;

  const ExploreUserEntity({
    required this.id,
    required this.cognitoId,
    required this.firstName,
    required this.lastName,
  });

  factory ExploreUserEntity.fromJson(Map<String, dynamic> json) =>
      ExploreUserEntity(
        id: json['_id'],
        cognitoId: json['cognitoId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'cognitoId': cognitoId,
        'firstName': firstName,
        'lastName': lastName,
      };

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, cognitoId, firstName, lastName];
}

class PublicUserEntity extends ExploreUserEntity {
  final String gymId;

  const PublicUserEntity({
    required super.id,
    required super.cognitoId,
    required super.firstName,
    required super.lastName,
    required this.gymId,
  }) : super();

  factory PublicUserEntity.fromJson(Map<String, dynamic> json) =>
      PublicUserEntity(
        id: json['_id'],
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

  const UserEntity({
    required super.id,
    required super.cognitoId,
    required super.firstName,
    required super.lastName,
    required super.gymId,
    required this.email,
  }) : super();

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['_id'],
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
