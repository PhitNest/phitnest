part of '../cognito.dart';

sealed class LoginResponse extends Equatable {
  const LoginResponse() : super();
}

class LoginSuccess extends LoginResponse {
  final Session session;

  const LoginSuccess({
    required this.session,
  }) : super();

  @override
  List<Object?> get props => [session];
}

enum LoginFailureType {
  invalidEmailPassword,
  confirmationRequired,
  noSuchUser,
  invalidUserPool;

  String get message => switch (this) {
        LoginFailureType.invalidEmailPassword => 'Invalid email/password.',
        LoginFailureType.confirmationRequired => 'Confirmation required.',
        LoginFailureType.noSuchUser => kNoSuchUser,
        LoginFailureType.invalidUserPool => kInvalidPool,
      };
}

sealed class LoginFailureResponse extends LoginResponse {
  String get message;

  const LoginFailureResponse() : super();
}

class LoginFailure extends LoginFailureResponse {
  final LoginFailureType type;

  @override
  String get message => type.message;

  const LoginFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

class LoginUnknownResponse extends LoginFailureResponse {
  @override
  final String message;

  const LoginUnknownResponse({String? message})
      : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}

class LoginChangePasswordRequired extends LoginFailureResponse {
  final CognitoUser user;

  @override
  String get message => throw UnimplementedError();

  const LoginChangePasswordRequired(this.user) : super();

  @override
  List<Object?> get props => [user];
}
