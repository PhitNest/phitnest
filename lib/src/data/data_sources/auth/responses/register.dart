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
        user: UserEntity.fromJson(json['user']),
        uploadUrl: json['uploadUrl'],
      );

  @override
  List<Object?> get props => [user, uploadUrl];
}
