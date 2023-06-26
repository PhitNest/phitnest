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
  final String userBucketName;
  final String identityPoolId;

  const CognitoLoadedPoolState({
    required this.pool,
    required this.identityPoolId,
    required this.userBucketName,
  }) : super();

  @override
  List<Object?> get props => [pool, identityPoolId, userBucketName];
}

class CognitoLoadedPoolInitialState extends CognitoLoadedPoolState {
  const CognitoLoadedPoolInitialState({
    required super.pool,
    required super.userBucketName,
    required super.identityPoolId,
  }) : super();
}

class CognitoLoginLoadingState extends CognitoLoadedPoolState {
  final CancelableOperation<LoginResponse> loadingOperation;

  const CognitoLoginLoadingState({
    required super.pool,
    required super.identityPoolId,
    required super.userBucketName,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

class CognitoRegisterLoadingState extends CognitoLoadedPoolState {
  final CancelableOperation<RegisterResponse> loadingOperation;

  const CognitoRegisterLoadingState({
    required super.pool,
    required super.userBucketName,
    required super.identityPoolId,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

sealed class CognitoLoadedUserState extends CognitoLoadedPoolState {
  final CognitoUser user;

  const CognitoLoadedUserState({
    required super.pool,
    required super.userBucketName,
    required super.identityPoolId,
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
    required super.userBucketName,
    required super.identityPoolId,
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
    required super.userBucketName,
    required super.identityPoolId,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

class CognitoLoginFailureState extends CognitoLoadedPoolState {
  final LoginFailureResponse failure;

  const CognitoLoginFailureState({
    required super.userBucketName,
    required super.pool,
    required super.identityPoolId,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

class CognitoRegisterFailureState extends CognitoLoadedPoolState {
  final RegisterFailureResponse failure;

  const CognitoRegisterFailureState({
    required super.userBucketName,
    required super.pool,
    required super.identityPoolId,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}

sealed class CognitoLoggedInState extends CognitoState {
  final Session session;
  final String identityPoolId;

  const CognitoLoggedInState({
    required this.session,
    required this.identityPoolId,
  }) : super();

  @override
  List<Object?> get props => [session, identityPoolId];
}

class CognitoLoggedInInitialState extends CognitoLoggedInState {
  const CognitoLoggedInInitialState({
    required super.session,
    required super.identityPoolId,
  }) : super();
}

class CognitoLoggingOutState extends CognitoLoggedInState {
  final CancelableOperation<void> loadingOperation;

  const CognitoLoggingOutState({
    required super.session,
    required super.identityPoolId,
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation];
}

class CognitoConfirmEmailLoadingState extends CognitoLoadedUserState {
  final CancelableOperation<bool> loadingOperation;
  final String password;

  const CognitoConfirmEmailLoadingState({
    required super.pool,
    required super.user,
    required super.userBucketName,
    required super.identityPoolId,
    required this.loadingOperation,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation, password];
}

class CognitoConfirmEmailFailedState extends CognitoLoadedUserState {
  final String password;

  const CognitoConfirmEmailFailedState({
    required super.pool,
    required super.userBucketName,
    required super.user,
    required super.identityPoolId,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [super.props, password];
}

class CognitoResendConfirmEmailLoadingState extends CognitoLoadedUserState {
  final CancelableOperation<bool> loadingOperation;
  final String password;

  const CognitoResendConfirmEmailLoadingState({
    required super.pool,
    required super.user,
    required super.userBucketName,
    required super.identityPoolId,
    required this.loadingOperation,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [super.props, loadingOperation, password];
}

class CognitoResendConfirmEmailResponseState extends CognitoLoadedUserState {
  final bool resent;
  final String password;

  const CognitoResendConfirmEmailResponseState({
    required super.userBucketName,
    required super.pool,
    required super.user,
    required super.identityPoolId,
    required this.resent,
    required this.password,
  }) : super();

  @override
  List<Object?> get props => [super.props, resent, password];
}
