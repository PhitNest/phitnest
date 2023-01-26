import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';

class LoginResponse extends Equatable {
  final AuthEntity session;
  final UserEntity user;

  LoginResponse({
    required this.session,
    required this.user,
  }) : super();

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        session: AuthEntity.fromJson(json['session']),
        user: UserEntity.fromJson(json['user']),
      );

  @override
  List<Object?> get props => [session, user];
}
