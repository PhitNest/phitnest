part of '../auth.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent() : super();
}

class AuthResponseEvent extends AuthEvent {
  final HttpResponse<Auth> response;

  const AuthResponseEvent({
    required this.response,
  }) : super();

  @override
  List<Object?> get props => [response];
}

sealed class AuthLoadedEvent extends AuthEvent {
  const AuthLoadedEvent() : super();
}

class AuthLoginEvent extends AuthLoadedEvent {
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
