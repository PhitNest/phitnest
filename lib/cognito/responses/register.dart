part of '../cognito.dart';

sealed class RegisterResponse extends Equatable {
  const RegisterResponse();
}

class RegisterSuccess extends RegisterResponse {
  final CognitoUser user;

  const RegisterSuccess(this.user) : super();

  @override
  List<Object?> get props => [user];
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

enum ValidationFailureType {
  invalidEmail,
  invalidPassword,
}

class ValidationFailure extends RegisterFailureResponse {
  final ValidationFailureType type;
  final String? issue;

  const ValidationFailure(this.type, this.issue) : super();

  @override
  List<Object?> get props => [type, issue];
}

class RegisterUnknownResponse extends RegisterFailureResponse {
  final String message;

  const RegisterUnknownResponse({String? message})
      : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}
