import 'constants.dart';

enum ForgotPasswordFailure {
  invalidUserPool,
  invalidEmail,
  noSuchUser,
  unknown;

  String get message => switch (this) {
        ForgotPasswordFailure.invalidUserPool => kInvalidPool,
        ForgotPasswordFailure.invalidEmail => kInvalidEmail,
        ForgotPasswordFailure.noSuchUser => kNoSuchUser,
        ForgotPasswordFailure.unknown => kUnknownError,
      };
}
