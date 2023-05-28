import 'constants.dart';

enum RefreshSessionFailure {
  invalidUserPool,
  noSuchUser,
  invalidToken,
  unknown;

  String get message => switch (this) {
        RefreshSessionFailure.invalidUserPool => kInvalidPool,
        RefreshSessionFailure.noSuchUser => kNoSuchUser,
        RefreshSessionFailure.invalidToken => 'Invalid token.',
        RefreshSessionFailure.unknown => kUnknownError,
      };
}
