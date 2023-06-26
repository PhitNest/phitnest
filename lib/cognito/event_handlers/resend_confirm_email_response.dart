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
        userBucketName: final userBucketName,
        password: final password,
        identityPoolId: final identityPoolId,
      ):
      emit(
        CognitoResendConfirmEmailResponseState(
          password: password,
          pool: pool,
          user: user,
          userBucketName: userBucketName,
          resent: event.resent,
          identityPoolId: identityPoolId,
        ),
      );
    default:
      throw StateException(state, event);
  }
}
