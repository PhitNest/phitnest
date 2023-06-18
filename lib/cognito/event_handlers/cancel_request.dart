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
        pool: final pool
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(pool: pool));
        },
      );
    case CognitoConfirmEmailLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(pool: pool));
        },
      );
    case CognitoResendConfirmEmailLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(pool: pool));
        },
      );
    case CognitoLoginLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(pool: pool));
        },
      );
    case CognitoRegisterLoadingState(
        loadingOperation: final loadingOperation,
        pool: final pool
      ):
      loadingOperation.cancel().then(
        (_) async {
          await _cacheEmail(null);
          await pool.storage.clear();
          emit(CognitoLoadedPoolInitialState(pool: pool));
        },
      );
    case CognitoLoginFailureState(failure: final failure):
      switch (failure) {
        case LoginChangePasswordRequired(user: final user):
          emit(CognitoLoadedPoolInitialState(pool: user.pool));
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
