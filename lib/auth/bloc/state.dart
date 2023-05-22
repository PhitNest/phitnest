part of '../auth.dart';

sealed class AuthState extends Equatable {
  const AuthState() : super();

  @override
  List<Object?> get props => [];
}

sealed class AuthLoadingState extends AuthState {
  final CancelableOperation<HttpResponse<Auth>> loadingOperation;

  const AuthLoadingState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class AuthInitialEventQueuedState extends AuthLoadingState {
  final AuthLoadedEvent queuedEvent;

  const AuthInitialEventQueuedState({
    required super.loadingOperation,
    required this.queuedEvent,
  }) : super();

  @override
  List<Object?> get props => [super.props, queuedEvent];
}

class AuthInitialState extends AuthLoadingState {
  const AuthInitialState({
    required super.loadingOperation,
  }) : super();
}

sealed class AuthLoadedState extends AuthState {
  final Auth auth;

  const AuthLoadedState({
    required this.auth,
  }) : super();

  @override
  List<Object?> get props => [auth];
}

class AuthLoadedInitialState extends AuthLoadedState {
  const AuthLoadedInitialState({
    required super.auth,
  }) : super();
}

class AuthLoginLoadingState extends AuthLoadedState {
  final CancelableOperation<LoginResponse> loadingOperation;

  const AuthLoginLoadingState({
    required super.auth,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

class AuthLoggedInState extends AuthLoadedState {
  final String userId;

  const AuthLoggedInState({
    required super.auth,
    required this.userId,
  }) : super();

  @override
  List<Object?> get props => [super.props, userId];
}

class AuthLoginFailureState extends AuthLoadedState {
  final String message;

  const AuthLoginFailureState({
    required super.auth,
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [super.props, message];
}
