part of 'forgot_password.dart';

sealed class SendForgotPasswordResponse extends Equatable {
  const SendForgotPasswordResponse() : super();
}

final class SendForgotPasswordSuccess extends SendForgotPasswordResponse {
  final CognitoUser user;

  const SendForgotPasswordSuccess(this.user) : super();

  @override
  List<Object?> get props => [user];
}

enum SendForgotPasswordFailure {
  invalidUserPool,
  invalidEmail,
  noSuchUser;

  String get message => switch (this) {
        SendForgotPasswordFailure.invalidUserPool => 'Invalid user pool',
        SendForgotPasswordFailure.invalidEmail => 'Invalid email',
        SendForgotPasswordFailure.noSuchUser => 'No such user',
      };
}

sealed class SendForgotPasswordFailureResponse
    extends SendForgotPasswordResponse {
  String get message;

  const SendForgotPasswordFailureResponse() : super();
}

final class SendForgotPasswordKnownFailure
    extends SendForgotPasswordFailureResponse {
  @override
  String get message => type.message;

  final SendForgotPasswordFailure type;

  const SendForgotPasswordKnownFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class SendForgotPasswordUnknownFailure
    extends SendForgotPasswordFailureResponse {
  @override
  final String message;

  const SendForgotPasswordUnknownFailure({
    required String? message,
  })  : message = message ?? 'An unknown error occurred.',
        super();

  @override
  List<Object?> get props => [message];
}

enum SubmitForgotPasswordFailure {
  invalidUserPool,
  invalidEmail,
  invalidPassword,
  noSuchUser,
  invalidCodeOrPassword,
  invalidCode,
  expiredCode,
  unknown;

  String get message => switch (this) {
        SubmitForgotPasswordFailure.invalidUserPool => 'Invalid user pool.',
        SubmitForgotPasswordFailure.invalidEmail => 'Invalid email.',
        SubmitForgotPasswordFailure.invalidPassword => 'Invalid password.',
        SubmitForgotPasswordFailure.noSuchUser => 'No such user.',
        SubmitForgotPasswordFailure.unknown => 'An unknown error occurred.',
        SubmitForgotPasswordFailure.invalidCodeOrPassword =>
          'Invalid code or password.',
        SubmitForgotPasswordFailure.invalidCode => 'Invalid code.',
        SubmitForgotPasswordFailure.expiredCode => 'Expired code.',
      };
}
