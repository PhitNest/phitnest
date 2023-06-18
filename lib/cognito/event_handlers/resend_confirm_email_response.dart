part of '../cognito.dart';

void _handleResendConfirmEmailResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoResendConfirmEmailResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoResendConfirmEmailLoadingState(
        pool: final pool,
        user: final user,
        password: final password,
      ):
      emit(
        CognitoResendConfirmEmailResponseState(
          password: password,
          pool: pool,
          user: user,
          resent: event.resent,
        ),
      );
    default:
      throw StateException(state, event);
  }
}
