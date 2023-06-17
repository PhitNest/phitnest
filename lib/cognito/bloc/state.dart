part of '../cognito.dart';

sealed class CognitoState extends Equatable {
  const CognitoState() : super();
}

class CognitoLoadingPreviousSessionState extends CognitoState {
  final CancelableOperation<Session?> loadingOperation;

  const CognitoLoadingPreviousSessionState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

sealed class CognitoLoadingPoolsState extends CognitoState {
  final CancelableOperation<HttpResponse<Pools>> loadingOperation;

  const CognitoLoadingPoolsState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class CognitoLoadingPoolsInitialState extends CognitoLoadingPoolsState {
  const CognitoLoadingPoolsInitialState({
    required super.loadingOperation,
  }) : super();
}

class CognitoInitialEventQueuedState extends CognitoLoadingPoolsState {
  final CognitoQueableEvent queuedEvent;

  const CognitoInitialEventQueuedState({
    required super.loadingOperation,
    required this.queuedEvent,
  }) : super();

  @override
  List<Object?> get props => [super.props, queuedEvent];
}

sealed class CognitoLoadedPoolState extends CognitoState {
  final CognitoUserPool pool;

  const CognitoLoadedPoolState({
    required this.pool,
  }) : super();

  @override
  List<Object?> get props => [pool];
}

class CognitoLoadedPoolInitialState extends CognitoLoadedPoolState {
  const CognitoLoadedPoolInitialState({
    required super.pool,
  }) : super();
}

class CognitoLoginLoadingState extends CognitoLoadedPoolState {
  final CancelableOperation<LoginResponse> loadingOperation;

  const CognitoLoginLoadingState({
    required super.pool,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

class CognitoRegisterLoadingState extends CognitoLoadedPoolState {
  final CancelableOperation<RegisterResponse> loadingOperation;

  const CognitoRegisterLoadingState({
    required super.pool,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

sealed class CognitoLoadedUserState extends CognitoLoadedPoolState {
  final CognitoUser user;

  const CognitoLoadedUserState({
    required super.pool,
    required this.user,
  }) : super();

  @override
  List<Object?> get props => [super.props, user];
}

class CognitoChangePasswordLoadingState extends CognitoLoadedUserState {
  final CancelableOperation<ChangePasswordResponse> loadingOperation;

  const CognitoChangePasswordLoadingState({
    required super.pool,
    required super.user,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

class CognitoChangePasswordFailureState extends CognitoLoadedUserState {
  final ChangePasswordFailureResponse failure;

  const CognitoChangePasswordFailureState({
    required super.pool,
    required super.user,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

class CognitoLoginFailureState extends CognitoLoadedPoolState {
  final LoginFailureResponse failure;

  const CognitoLoginFailureState({
    required super.pool,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

class CognitoRegisterFailureState extends CognitoLoadedPoolState {
  final RegisterFailureResponse failure;

  const CognitoRegisterFailureState({
    required super.pool,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

sealed class CognitoLoggedInState extends CognitoState {
  final Session session;

  const CognitoLoggedInState({
    required this.session,
  }) : super();

  @override
  List<Object?> get props => [session];
}

class CognitoLoggedInInitialState extends CognitoLoggedInState {
  const CognitoLoggedInInitialState({
    required super.session,
  }) : super();
}

class CognitoLoggingOutState extends CognitoLoggedInState {
  final CancelableOperation<void> loadingOperation;

  const CognitoLoggingOutState({
    required super.session,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}
