part of '../cognito.dart';

sealed class CognitoState extends Equatable {
  const CognitoState() : super();
}

sealed class CognitoLoadingState extends CognitoState {
  final CancelableOperation<HttpResponse<Cognito>> loadingOperation;

  const CognitoLoadingState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class CognitoInitialState extends CognitoLoadingState {
  const CognitoInitialState({
    required super.loadingOperation,
  }) : super();
}

class CognitoInitialEventQueuedState extends CognitoLoadingState {
  final CognitoLoadedEvent queuedEvent;

  const CognitoInitialEventQueuedState({
    required super.loadingOperation,
    required this.queuedEvent,
  }) : super();

  @override
  List<Object?> get props => [super.props, queuedEvent];
}

sealed class CognitoLoadedState extends CognitoState {
  final Cognito cognito;

  const CognitoLoadedState({
    required this.cognito,
  }) : super();

  @override
  List<Object?> get props => [Cognito];
}

class CognitoLoadedInitialState extends CognitoLoadedState {
  const CognitoLoadedInitialState({
    required super.cognito,
  }) : super();
}

class CognitoChangePasswordLoadingState extends CognitoLoadedState {
  final CancelableOperation<ChangePasswordFailure?> loadingOperation;

  const CognitoChangePasswordLoadingState({
    required super.cognito,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

class CognitoChangedPasswordState extends CognitoLoadedState {
  const CognitoChangedPasswordState({
    required super.cognito,
  }) : super();
}

class CognitoChangePasswordFailureState extends CognitoLoadedState {
  final ChangePasswordFailureType type;
  final String message;

  const CognitoChangePasswordFailureState({
    required super.cognito,
    required this.type,
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [super.props, type, message];
}

class CognitoLoginLoadingState extends CognitoLoadedState {
  final CancelableOperation<LoginResponse> loadingOperation;

  const CognitoLoginLoadingState({
    required super.cognito,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

class CognitoLoggedInState extends CognitoLoadedState {
  final String userId;

  const CognitoLoggedInState({
    required super.cognito,
    required this.userId,
  }) : super();

  @override
  List<Object?> get props => [super.props, userId];
}

class CognitoLoginFailureState extends CognitoLoadedState {
  final String message;
  final LoginFailureType type;

  const CognitoLoginFailureState({
    required super.cognito,
    required this.message,
    required this.type,
  }) : super();

  @override
  List<Object?> get props => [super.props, message, type];
}
