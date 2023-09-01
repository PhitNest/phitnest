part of 'login.dart';

sealed class LoginResponse extends Equatable {
  const LoginResponse() : super();
}

final class LoginSuccess extends LoginResponse {
  final Session session;

  const LoginSuccess({
    required this.session,
  }) : super();

  @override
  List<Object?> get props => [session];
}

enum LoginFailureType {
  invalidEmailPassword,
  noSuchUser,
  invalidUserPool;

  String get message => switch (this) {
        LoginFailureType.invalidEmailPassword => 'Invalid email/password.',
        LoginFailureType.noSuchUser => 'No such user.',
        LoginFailureType.invalidUserPool => 'Invalid user pool.',
      };
}

sealed class LoginFailureResponse extends LoginResponse {
  String get message;

  const LoginFailureResponse() : super();
}

final class LoginKnownFailure extends LoginFailureResponse {
  final LoginFailureType type;

  @override
  String get message => type.message;

  const LoginKnownFailure(this.type) : super();

  @override
  List<Object?> get props => [type];
}

final class LoginConfirmationRequired extends LoginFailureResponse {
  @override
  String get message => 'Confirmation required.';

  final CognitoUser user;
  final String password;

  const LoginConfirmationRequired({
    required this.user,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [user, password];
}

final class LoginUnknownResponse extends LoginFailureResponse {
  @override
  final String message;

  const LoginUnknownResponse({
    required String? message,
  })  : message = message ?? 'An unknown error occurred.',
        super();

  @override
  List<Object?> get props => [message];
}

final class LoginChangePasswordRequired extends LoginFailureResponse {
  final CognitoUser user;

  @override
  String get message => 'Change password required.';

  const LoginChangePasswordRequired(this.user) : super();

  @override
  List<Object?> get props => [user];
}
