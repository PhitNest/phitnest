import 'package:equatable/equatable.dart';

sealed class LoginResponse extends Equatable {
  const LoginResponse() : super();
}

class LoginSuccess extends LoginResponse {
  final String userId;

  const LoginSuccess(this.userId) : super();

  @override
  List<Object?> get props => [userId];
}

enum LoginFailureType {
  invalidEmailPassword,
  confirmationRequired,
  noSuchUser,
  invalidUserPool,
  unknown;

  String get message => switch (this) {
        LoginFailureType.invalidEmailPassword => "Invalid email/password.",
        LoginFailureType.confirmationRequired => "Confirmation required.",
        LoginFailureType.noSuchUser => "No such user exists.",
        LoginFailureType.invalidUserPool => "Invalid user pool.",
        LoginFailureType.unknown => "An unknown error occurred.",
      };
}

class LoginFailure extends LoginResponse {
  final LoginFailureType type;

  const LoginFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}
