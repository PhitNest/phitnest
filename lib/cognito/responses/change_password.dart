part of '../cognito.dart';

sealed class ChangePasswordResponse extends Equatable {
  const ChangePasswordResponse() : super();
}

class ChangePasswordSuccess extends ChangePasswordResponse {
  final Session session;

  const ChangePasswordSuccess(this.session) : super();

  @override
  List<Object?> get props => [session];
}

enum ChangePasswordFailureType {
  invalidUserPool,
  invalidPassword,
  noSuchUser;

  String get message => switch (this) {
        ChangePasswordFailureType.invalidUserPool => kInvalidPool,
        ChangePasswordFailureType.invalidPassword => kInvalidPassword,
        ChangePasswordFailureType.noSuchUser => kNoSuchUser,
      };
}

sealed class ChangePasswordFailureResponse extends ChangePasswordResponse {
  String get message;

  const ChangePasswordFailureResponse() : super();
}

class ChangePasswordFailure extends ChangePasswordFailureResponse {
  final ChangePasswordFailureType type;

  @override
  String get message => type.message;

  const ChangePasswordFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

class ChangePasswordUnknownResponse extends ChangePasswordFailureResponse {
  @override
  final String message;

  const ChangePasswordUnknownResponse({String? message})
      : message = message ?? kUnknownError,
        super();

  @override
  List<Object?> get props => [message];
}
