part of '../cognito.dart';

void _handleChangePasswordResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoChangePasswordResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoChangePasswordLoadingState(pool: final pool, user: final user):
      emit(switch (event.response) {
        ChangePasswordSuccess(session: final session) =>
          CognitoLoggedInInitialState(session: session),
        ChangePasswordFailureResponse() => CognitoChangePasswordFailureState(
            pool: pool,
            user: user,
            failure: event.response as ChangePasswordFailureResponse,
          ),
      });
    default:
      throw StateException(state, event);
  }
}
