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
        userBucketName: final userBucketName,
        password: final password,
        identityPoolId: final identityPoolId,
      ):
      emit(
        CognitoConfirmEmailFailedState(
          pool: pool,
          user: user,
          userBucketName: userBucketName,
          password: password,
          identityPoolId: identityPoolId,
        ),
      );
    default:
      throw StateException(state, event);
  }
}
