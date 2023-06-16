part of '../cognito.dart';

void handleLoginResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoLoginResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoginLoadingState(pool: final pool):
      emit(
        switch (event.response) {
          LoginSuccess(session: final session) =>
            CognitoLoggedInState(session: session),
          LoginFailureResponse() => CognitoLoginFailureState(
              pool: pool,
              failure: event.response as LoginFailureResponse,
            ),
        },
      );
    default:
      throw StateException(state, event);
  }
}
