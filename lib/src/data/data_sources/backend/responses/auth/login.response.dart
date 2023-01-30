import 'package:equatable/equatable.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../domain/entities/entities.dart';

class LoginResponseParser extends Parser<LoginResponse> {
  const LoginResponseParser() : super();

  @override
  LoginResponse fromJson(Map<String, dynamic> json) => LoginResponse(
        session: AuthParser().fromJson(json['session']),
        user: UserParser().fromJson(json['user']),
      );
}

class LoginResponse extends Equatable {
  final AuthEntity session;
  final UserEntity user;

  const LoginResponse({
    required this.session,
    required this.user,
  }) : super();

  @override
  List<Object?> get props => [session, user];
}
