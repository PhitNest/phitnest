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
        SubmitForgotPasswordFailure.invalidUserPool => "Invalid user pool.",
        SubmitForgotPasswordFailure.invalidEmail => "Invalid email.",
        SubmitForgotPasswordFailure.invalidPassword => "Invalid password.",
        SubmitForgotPasswordFailure.noSuchUser => "No such user exists.",
        SubmitForgotPasswordFailure.unknown => "An unknown error occurred.",
        SubmitForgotPasswordFailure.invalidCodeOrPassword =>
          "Invalid code or password.",
        SubmitForgotPasswordFailure.invalidCode => "Invalid code.",
        SubmitForgotPasswordFailure.expiredCode => "Expired code.",
      };
}
