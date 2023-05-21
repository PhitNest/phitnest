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

class AuthReloadingState extends AuthLoadingState {
  final Failure failure;

  const AuthReloadingState({
    required super.loadingOperation,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

class AuthLoadedState extends AuthState {
  final Auth auth;

  const AuthLoadedState({
    required this.auth,
  }) : super();

  @override
  List<Object?> get props => [auth];
}
