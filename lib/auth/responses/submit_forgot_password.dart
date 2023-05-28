import 'constants.dart';

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
        SubmitForgotPasswordFailure.invalidUserPool => kInvalidPool,
        SubmitForgotPasswordFailure.invalidEmail => kInvalidEmail,
        SubmitForgotPasswordFailure.invalidPassword => kInvalidPassword,
        SubmitForgotPasswordFailure.noSuchUser => kNoSuchUser,
        SubmitForgotPasswordFailure.unknown => kUnknownError,
        SubmitForgotPasswordFailure.invalidCodeOrPassword =>
          'Invalid code or password.',
        SubmitForgotPasswordFailure.invalidCode => 'Invalid code.',
        SubmitForgotPasswordFailure.expiredCode => 'Expired code.',
      };
}
