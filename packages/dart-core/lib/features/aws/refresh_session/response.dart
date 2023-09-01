part of 'refresh_session.dart';

sealed class RefreshSessionResponse extends Equatable {
  const RefreshSessionResponse();
}

final class RefreshSessionSuccess extends RefreshSessionResponse {
  final Session newSession;

  const RefreshSessionSuccess(this.newSession) : super();

  @override
  List<Object?> get props => [newSession];
}

sealed class RefreshSessionFailureResponse extends RefreshSessionResponse {
  String get message;

  const RefreshSessionFailureResponse() : super();
}

final class SessionEnded extends RefreshSessionFailureResponse {
  @override
  String get message => 'You have been logged out.';

  const SessionEnded() : super();

  @override
  List<Object?> get props => [];
}

enum RefreshSessionFailureType {
  invalidUserPool,
  noSuchUser,
  invalidToken;

  String get message => switch (this) {
        RefreshSessionFailureType.invalidUserPool => 'Invalid user pool.',
        RefreshSessionFailureType.noSuchUser => 'No such user.',
        RefreshSessionFailureType.invalidToken => 'Invalid token.'
      };
}

final class RefreshSessionKnownFailure extends RefreshSessionFailureResponse {
  @override
  String get message => type.message;

  final RefreshSessionFailureType type;

  const RefreshSessionKnownFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class RefreshSessionUnknownFailure extends RefreshSessionFailureResponse {
  @override
  final String message;

  const RefreshSessionUnknownFailure({
    required String? message,
  })  : message = message ?? 'An unknown error occurred.',
        super();

  @override
  List<Object?> get props => [message];
}
