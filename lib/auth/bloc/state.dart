part of '../auth.dart';

sealed class AuthState extends Equatable {
  const AuthState() : super();
}

sealed class AuthLoadingState extends AuthState {
  final CancelableOperation<HttpResponse<Auth>> loadingOperation;

  const AuthLoadingState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class AuthInitialState extends AuthLoadingState {
  const AuthInitialState({
    required super.loadingOperation,
  }) : super();
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

class AuthChangePasswordLoadingState extends AuthLoadedState {
  final CancelableOperation<ChangePasswordFailure?> loadingOperation;

  const AuthChangePasswordLoadingState({
    required super.auth,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

class AuthChangedPasswordState extends AuthLoadedState {
  const AuthChangedPasswordState({
    required super.auth,
  }) : super();
}

class AuthChangePasswordFailureState extends AuthLoadedState {
  final ChangePasswordFailureType type;
  final String message;

  const AuthChangePasswordFailureState({
    required super.auth,
    required this.type,
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [super.props, type, message];
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
  final LoginFailureType type;

  const AuthLoginFailureState({
    required super.auth,
    required this.message,
    required this.type,
  }) : super();

  @override
  List<Object?> get props => [super.props, message, type];
}
