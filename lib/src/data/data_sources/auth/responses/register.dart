import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';

class RegisterResponse extends Equatable {
  final String uploadUrl;
  final UserEntity user;

  RegisterResponse({
    required this.user,
    required this.uploadUrl,
  }) : super();

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        user: UserEntity(
          cognitoId: json['cognitoId'],
          id: json['_id'],
          email: json['email'],
          firstName: json['firstName'],
          lastName: json['lastName'],
          gymId: json['gymId'],
          confirmed: json['confirmed'],
        ),
        uploadUrl: json['uploadUrl'],
      );

  @override
  List<Object?> get props => [
        user,
        uploadUrl,
      ];
}
