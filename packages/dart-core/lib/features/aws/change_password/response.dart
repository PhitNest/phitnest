part of 'change_password.dart';

sealed class ChangePasswordResponse extends Equatable {
  const ChangePasswordResponse() : super();
}

final class ChangePasswordSuccess extends ChangePasswordResponse {
  final Session session;

  const ChangePasswordSuccess(this.session) : super();

  @override
  List<Object?> get props => [session];
}

sealed class ChangePasswordFailureResponse extends ChangePasswordResponse {
  String get message;

  const ChangePasswordFailureResponse() : super();
}

enum ChangePasswordFailureType {
  invalidUserPool,
  invalidPassword,
  noSuchUser;

  String get message => switch (this) {
        ChangePasswordFailureType.invalidUserPool => 'Invalid user pool',
        ChangePasswordFailureType.invalidPassword => 'Invalid password',
        ChangePasswordFailureType.noSuchUser => 'No such user',
      };
}

final class ChangePasswordKnownFailure extends ChangePasswordFailureResponse {
  final ChangePasswordFailureType type;

  @override
  String get message => type.message;

  const ChangePasswordKnownFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class ChangePasswordUnknownFailure extends ChangePasswordFailureResponse {
  @override
  final String message;

  const ChangePasswordUnknownFailure({
    required String? message,
  })  : message = message ?? 'An unknown error occurred.',
        super();

  @override
  List<Object?> get props => [message];
}
