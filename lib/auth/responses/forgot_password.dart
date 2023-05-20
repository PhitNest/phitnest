enum ForgotPasswordFailure {
  invalidUserPool,
  invalidEmail,
  noSuchUser,
  unknown;

  String get message => switch (this) {
        ForgotPasswordFailure.invalidUserPool => "Invalid user pool.",
        ForgotPasswordFailure.invalidEmail => "Invalid email.",
        ForgotPasswordFailure.noSuchUser => "No such user exists.",
        ForgotPasswordFailure.unknown => "An unknown error occurred.",
      };
}
