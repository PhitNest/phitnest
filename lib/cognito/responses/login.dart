import 'package:equatable/equatable.dart';

import 'constants.dart';

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
  changePasswordRequired,
  unknown;

  String get message => switch (this) {
        LoginFailureType.invalidEmailPassword => 'Invalid email/password.',
        LoginFailureType.confirmationRequired => 'Confirmation required.',
        LoginFailureType.noSuchUser => kNoSuchUser,
        LoginFailureType.invalidUserPool => kInvalidPool,
        LoginFailureType.changePasswordRequired => 'Change password required.',
        LoginFailureType.unknown => kUnknownError,
      };
}

class LoginFailure extends LoginResponse {
  final LoginFailureType type;
  String get message => type.message;

  const LoginFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

class LoginCognitoFailure extends LoginResponse {
  LoginFailureType get type => LoginFailureType.unknown;

  final String message;

  const LoginCognitoFailure({String? message})
      : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}
