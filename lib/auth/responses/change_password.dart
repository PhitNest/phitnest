import 'package:equatable/equatable.dart';

import 'constants.dart';

enum ChangePasswordFailureType {
  invalidUserPool,
  invalidPassword,
  noSuchUser,
  unknown;

  String get message => switch (this) {
        ChangePasswordFailureType.invalidUserPool => kInvalidPool,
        ChangePasswordFailureType.invalidPassword => kInvalidPassword,
        ChangePasswordFailureType.noSuchUser => kNoSuchUser,
        ChangePasswordFailureType.unknown => kUnknownError,
      };
}

sealed class ChangePasswordFailure extends Equatable {
  String get message;
  ChangePasswordFailureType get type;

  const ChangePasswordFailure();

  @override
  List<Object?> get props => [message, type];
}

class ChangePasswordTypedFailure extends ChangePasswordFailure {
  @override
  String get message => type.message;

  @override
  final ChangePasswordFailureType type;

  const ChangePasswordTypedFailure(this.type);
}

class ChangePasswordCognitoFailure extends ChangePasswordFailure {
  @override
  final String message;

  @override
  ChangePasswordFailureType get type => ChangePasswordFailureType.unknown;

  const ChangePasswordCognitoFailure({String? message})
      : message = message ?? kUnknownError,
        super();
}
