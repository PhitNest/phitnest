enum RefreshSessionFailure {
  invalidUserPool,
  noSuchUser,
  invalidToken,
  unknown;

  String get message => switch (this) {
        RefreshSessionFailure.invalidUserPool => "Invalid user pool.",
        RefreshSessionFailure.noSuchUser => "No such user exists.",
        RefreshSessionFailure.invalidToken => "Invalid token.",
        RefreshSessionFailure.unknown => "An unknown error occurred.",
      };
}
