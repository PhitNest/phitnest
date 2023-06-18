part of '../cognito.dart';

sealed class RegisterResponse extends Equatable {
  const RegisterResponse();
}

class RegisterSuccess extends RegisterResponse {
  final CognitoUser user;
  final String password;

  const RegisterSuccess(
    this.user,
    this.password,
  ) : super();

  @override
  List<Object?> get props => [user, password];
}

sealed class RegisterFailureResponse extends RegisterResponse {
  const RegisterFailureResponse() : super();
}

enum RegisterFailureType {
  userExists,
  invalidUserPool;

  String get message => switch (this) {
        RegisterFailureType.userExists =>
          'A user with that email already exists.',
        RegisterFailureType.invalidUserPool => kInvalidPool,
      };
}

class RegisterFailure extends RegisterFailureResponse {
  final RegisterFailureType type;

  const RegisterFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

class ValidationFailure extends RegisterFailureResponse {
  final String message;

  const ValidationFailure(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class RegisterUnknownResponse extends RegisterFailureResponse {
  final String message;

  const RegisterUnknownResponse({String? message})
      : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}
