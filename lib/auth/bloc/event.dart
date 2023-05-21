part of '../auth.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent() : super();
}

class AuthLoadedEvent extends AuthEvent {
  final HttpResponse<Auth> response;

  const AuthLoadedEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({
    required this.email,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [email, password];
}

class AuthLoginResponseEvent extends AuthEvent {
  final LoginResponse response;

  const AuthLoginResponseEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}
