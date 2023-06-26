part of '../cognito.dart';

sealed class CognitoEvent extends Equatable {
  const CognitoEvent() : super();
}

class CognitoPreviousSessionEvent extends CognitoEvent {
  final Session? session;
  final String? identityPoolId;

  const CognitoPreviousSessionEvent({
    required this.session,
    required this.identityPoolId,
  }) : super();

  @override
  List<Object?> get props => [session, identityPoolId];
}

class CognitoPoolsResponseEvent extends CognitoEvent {
  final HttpResponse<Pools> response;

  const CognitoPoolsResponseEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

sealed class CognitoQueableEvent extends CognitoEvent {
  const CognitoQueableEvent() : super();
}

class CognitoLoginEvent extends CognitoQueableEvent {
  final String email;
  final String password;

  const CognitoLoginEvent({
    required this.email,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [email, password];
}

class CognitoRegisterEvent extends CognitoQueableEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String inviterEmail;

  const CognitoRegisterEvent({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.inviterEmail,
  }) : super();

  @override
  List<Object?> get props =>
      [email, password, firstName, lastName, inviterEmail];
}

class CognitoRegisterResponseEvent extends CognitoQueableEvent {
  final RegisterResponse response;

  const CognitoRegisterResponseEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

class CognitoLoginResponseEvent extends CognitoEvent {
  final LoginResponse response;

  const CognitoLoginResponseEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

class CognitoChangePasswordEvent extends CognitoQueableEvent {
  final String newPassword;
  final String email;

  const CognitoChangePasswordEvent({
    required this.newPassword,
    required this.email,
  }) : super();

  @override
  List<Object?> get props => [newPassword, email];
}

class CognitoChangePasswordResponseEvent extends CognitoEvent {
  final ChangePasswordResponse response;

  const CognitoChangePasswordResponseEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

class CognitoCancelRequestEvent extends CognitoEvent {
  const CognitoCancelRequestEvent() : super();

  @override
  List<Object?> get props => [];
}

class CognitoLogoutEvent extends CognitoEvent {
  const CognitoLogoutEvent() : super();

  @override
  List<Object?> get props => [];
}

class CognitoLogoutResponseEvent extends CognitoEvent {
  const CognitoLogoutResponseEvent() : super();

  @override
  List<Object?> get props => [];
}

class CognitoConfirmEmailEvent extends CognitoEvent {
  final String confirmationCode;

  const CognitoConfirmEmailEvent({
    required this.confirmationCode,
  }) : super();

  @override
  List<Object?> get props => [confirmationCode];
}

class CognitoConfirmEmailFailedEvent extends CognitoEvent {
  const CognitoConfirmEmailFailedEvent() : super();

  @override
  List<Object?> get props => [];
}

class CognitoResendConfirmEmailEvent extends CognitoEvent {
  const CognitoResendConfirmEmailEvent() : super();

  @override
  List<Object?> get props => [];
}

class CognitoResendConfirmEmailResponseEvent extends CognitoEvent {
  final bool resent;

  const CognitoResendConfirmEmailResponseEvent({
    required this.resent,
  }) : super();

  @override
  List<Object?> get props => [resent];
}
