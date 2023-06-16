part of '../cognito.dart';

void handlePreviousSessionLoaded(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoPreviousSessionEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoadingPreviousSessionState():
      emit(
        event.session == null
            ? CognitoLoadingPoolsInitialState(
                loadingOperation: CancelableOperation.fromFuture(
                  _requestPools(),
                )..then(
                    (cognito) => add(
                      CognitoPoolsResponseEvent(response: cognito),
                    ),
                  ),
              )
            : CognitoLoggedInState(session: event.session!),
      );
    default:
      throw StateException(state, event);
  }
}
