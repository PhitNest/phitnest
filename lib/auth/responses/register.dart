import 'package:equatable/equatable.dart';

import 'constants.dart';

sealed class RegisterResponse extends Equatable {
  const RegisterResponse();
}

class RegisterSuccess extends RegisterResponse {
  final String userId;

  const RegisterSuccess(this.userId);

  @override
  List<Object?> get props => [userId];
}

enum RegisterFailureType {
  userExists,
  invalidUserPool,
  unknown;

  String get message => switch (this) {
        RegisterFailureType.userExists =>
          'A user with that email already exists.',
        RegisterFailureType.invalidUserPool => kInvalidPool,
        RegisterFailureType.unknown => kUnknownError,
      };
}

class RegisterFailure extends RegisterResponse {
  final RegisterFailureType type;

  const RegisterFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

enum ValidationFailureType {
  invalidEmail,
  invalidPassword,
}

class ValidationFailure extends RegisterResponse {
  final ValidationFailureType type;
  final String? issue;

  const ValidationFailure(this.type, this.issue) : super();

  @override
  List<Object?> get props => [type, issue];
}
