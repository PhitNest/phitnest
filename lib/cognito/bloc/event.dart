part of '../cognito.dart';

sealed class CognitoEvent extends Equatable {
  const CognitoEvent() : super();
}

class CognitoPreviousSessionEvent extends CognitoEvent {
  final Session? session;

  const CognitoPreviousSessionEvent({
    required this.session,
  }) : super();

  @override
  List<Object?> get props => [session];
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
