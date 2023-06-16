part of '../cognito.dart';

void handleCancelRequest(
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
        loadingOperation: final CancelableOperation<ChangePasswordResponse>
            loadingOperation,
        pool: final pool
      ):
      loadingOperation
          .cancel()
          .then((_) => emit(CognitoLoadedPoolInitialState(pool: pool)));
    case CognitoLoginLoadingState(
        loadingOperation: final CancelableOperation<LoginResponse>
            loadingOperation,
        pool: final pool
      ):
      loadingOperation
          .cancel()
          .then((_) => emit(CognitoLoadedPoolInitialState(pool: pool)));
    case CognitoChangePasswordFailureState() ||
          CognitoLoggedInState() ||
          CognitoLoginFailureState() ||
          CognitoLoadingPoolsInitialState() ||
          CognitoLoginFailureState() ||
          CognitoLoadedPoolInitialState() ||
          CognitoLoadingPreviousSessionState():
  }
}
