part of '../auth.dart';

sealed class AuthState extends Equatable {
  const AuthState() : super();
}

class AuthInitialState extends AuthState {
  final CancelableOperation<HttpResponse<Auth>> loadingOperation;

  const AuthInitialState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class AuthInitialEventQueuedState extends AuthState {
  final CancelableOperation<HttpResponse<Auth>> loadingOperation;
  final AuthLoadedEvent queuedEvent;

  const AuthInitialEventQueuedState({
    required this.loadingOperation,
    required this.queuedEvent,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation, queuedEvent];
}

class AuthLoadedInitialState extends AuthState {
  final Auth auth;

  const AuthLoadedInitialState({
    required this.auth,
  }) : super();

  @override
  List<Object?> get props => [auth];
}

class AuthLoginLoadingState extends AuthState {
  final Auth auth;
  final CancelableOperation<LoginResponse> loadingOperation;

  const AuthLoginLoadingState({
    required this.auth,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [auth, loadingOperation];
}

class AuthLoggedInState extends AuthState {
  final Auth auth;
  final String userId;

  const AuthLoggedInState({
    required this.auth,
    required this.userId,
  }) : super();

  @override
  List<Object?> get props => [auth, userId];
}

class AuthLoginFailureState extends AuthState {
  final Auth auth;
  final String message;

  const AuthLoginFailureState({
    required this.auth,
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [auth, message];
}
