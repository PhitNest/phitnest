part of '../cognito.dart';

void _handleConfirmEmailFailed(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoConfirmEmailFailedEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoConfirmEmailLoadingState(
        pool: final pool,
        user: final user,
        password: final password,
      ):
      emit(
        CognitoConfirmEmailFailedState(
          pool: pool,
          user: user,
          password: password,
        ),
      );
    default:
      throw StateException(state, event);
  }
}
