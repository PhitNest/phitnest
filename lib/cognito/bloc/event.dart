part of '../cognito.dart';

sealed class CognitoEvent extends Equatable {
  const CognitoEvent() : super();

  @override
  List<Object?> get props => [];
}

class CognitoResponseEvent extends CognitoEvent {
  final HttpResponse<Cognito> response;

  const CognitoResponseEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

sealed class CognitoLoadedEvent extends CognitoEvent {
  const CognitoLoadedEvent() : super();
}

class CognitoLoginEvent extends CognitoLoadedEvent {
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

class CognitoChangePasswordEvent extends CognitoLoadedEvent {
  final String newPassword;

  const CognitoChangePasswordEvent({
    required this.newPassword,
  }) : super();

  @override
  List<Object?> get props => [newPassword];
}

class CognitoChangePasswordResponseEvent extends CognitoEvent {
  final ChangePasswordFailure? response;

  const CognitoChangePasswordResponseEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

class CognitoCancelRequestEvent extends CognitoEvent {
  const CognitoCancelRequestEvent() : super();
}
