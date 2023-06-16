part of '../cognito.dart';

void handlePoolsResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  bool admin,
  CognitoPoolsResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (event.response) {
    case HttpResponseOk(data: final cognito):
      switch (state) {
        case CognitoLoadingPoolsInitialState():
          emit(
            CognitoLoadedPoolInitialState(
              pool: admin ? cognito.adminPool : cognito.userPool,
            ),
          );
        case CognitoInitialEventQueuedState(queuedEvent: final queuedEvent):
          emit(
            CognitoLoadedPoolInitialState(
              pool: admin ? cognito.adminPool : cognito.userPool,
            ),
          );
          add(queuedEvent);
        case CognitoLoadedPoolState() ||
              CognitoLoadingPreviousSessionState() ||
              CognitoLoggedInState():
          throw StateException(state, event);
      }
    case HttpResponseFailure():
      loadingOperation() => CancelableOperation.fromFuture(_requestPools())
        ..then(
          (response) => add(
            CognitoPoolsResponseEvent(response: response),
          ),
        );
      switch (state) {
        case CognitoLoadingPoolsInitialState():
          emit(
            CognitoLoadingPoolsInitialState(
              loadingOperation: loadingOperation(),
            ),
          );
        case CognitoInitialEventQueuedState(queuedEvent: final queuedEvent):
          emit(
            CognitoInitialEventQueuedState(
              loadingOperation: loadingOperation(),
              queuedEvent: queuedEvent,
            ),
          );
        case CognitoLoadedPoolState() ||
              CognitoLoadingPreviousSessionState() ||
              CognitoLoggedInState():
          throw StateException(state, event);
      }
  }
}
