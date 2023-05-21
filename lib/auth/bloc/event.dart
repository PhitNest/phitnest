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
