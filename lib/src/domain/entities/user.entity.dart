import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String cognitoId;
  final String gymId;
  final bool confirmed;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.cognitoId,
    required this.gymId,
    required this.confirmed,
  }) : super();

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['_id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        cognitoId: json['cognitoId'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'cognitoId': cognitoId,
        'gymId': gymId,
        'confirmed': confirmed,
      };

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        cognitoId,
        gymId,
        confirmed,
      ];
}
