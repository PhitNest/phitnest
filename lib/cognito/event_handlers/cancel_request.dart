part of '../cognito.dart';

void _handleCancelRequest(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoCancelRequestEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoInitialEventQueuedState(
        loadingOperation: final loadingOperation
      ):
      emit(CognitoLoadingPoolsInitialState(loadingOperation: loadingOperation));
    case CognitoChangePasswordLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool,
        userBucketName: final userBucketName,
        identityPoolId: final identityPoolId,
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(
            pool: pool,
            identityPoolId: identityPoolId,
            userBucketName: userBucketName,
          ));
        },
      );
    case CognitoConfirmEmailLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool,
        userBucketName: final userBucketName,
        identityPoolId: final identityPoolId,
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(
            pool: pool,
            userBucketName: userBucketName,
            identityPoolId: identityPoolId,
          ));
        },
      );
    case CognitoResendConfirmEmailLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool,
        userBucketName: final userBucketName,
        identityPoolId: final identityPoolId,
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(
            pool: pool,
            userBucketName: userBucketName,
            identityPoolId: identityPoolId,
          ));
        },
      );
    case CognitoLoginLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool,
        userBucketName: final userBucketName,
        identityPoolId: final identityPoolId,
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(
            pool: pool,
            userBucketName: userBucketName,
            identityPoolId: identityPoolId,
          ));
        },
      );
    case CognitoRegisterLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool,
        identityPoolId: final identityPoolId,
        userBucketName: final userBucketName,
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(
            pool: pool,
            identityPoolId: identityPoolId,
            userBucketName: userBucketName,
          ));
        },
      );
    case CognitoLoginFailureState(
        failure: final failure,
        identityPoolId: final identityPoolId,
        userBucketName: final userBucketName,
      ):
      switch (failure) {
        case LoginChangePasswordRequired(user: final user):
          emit(CognitoLoadedPoolInitialState(
            pool: user.pool,
            userBucketName: userBucketName,
            identityPoolId: identityPoolId,
          ));
        default:
      }
    case CognitoChangePasswordFailureState() ||
          CognitoLoggedInInitialState() ||
          CognitoLoadingPoolsInitialState() ||
          CognitoLoadedPoolInitialState() ||
          CognitoRegisterFailureState() ||
          CognitoLoggingOutState() ||
          CognitoConfirmEmailFailedState() ||
          CognitoResendConfirmEmailResponseState() ||
          CognitoLoadingPreviousSessionState():
  }
}
