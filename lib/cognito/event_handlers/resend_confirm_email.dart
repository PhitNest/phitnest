part of '../cognito.dart';

Future<bool> _resendConfirmationEmail({
  required CognitoUser user,
}) async {
  try {
    await user.resendConfirmationCode();
    return true;
  } catch (_) {
    return false;
  }
}

void _handleResendConfirmEmail(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoResendConfirmEmailEvent event,
  Emitter<CognitoState> emit,
) {
  resendConfirmation({
    required CognitoUser user,
    required String password,
    required String identityPoolId,
    required String userBucketName,
  }) =>
      emit(
        CognitoResendConfirmEmailLoadingState(
          pool: user.pool,
          user: user,
          userBucketName: userBucketName,
          password: password,
          identityPoolId: identityPoolId,
          loadingOperation: CancelableOperation.fromFuture(
            _resendConfirmationEmail(
              user: user,
            ),
          )..then(
              (response) => add(
                CognitoResendConfirmEmailResponseEvent(resent: response),
              ),
            ),
        ),
      );

  switch (state) {
    case CognitoResendConfirmEmailResponseState(
            user: final user,
            password: final password,
            userBucketName: final userBucketName,
            identityPoolId: final identityPoolId,
          ) ||
          CognitoConfirmEmailFailedState(
            user: final user,
            password: final password,
            identityPoolId: final identityPoolId,
            userBucketName: final userBucketName,
          ):
      resendConfirmation(
        user: user,
        password: password,
        identityPoolId: identityPoolId,
        userBucketName: userBucketName,
      );
    case CognitoLoginFailureState(
        failure: final failure,
        userBucketName: final userBucketName,
        identityPoolId: final identityPoolId,
      ):
      switch (failure) {
        case LoginConfirmationRequired(
            user: final user,
            password: final password,
          ):
          resendConfirmation(
            user: user,
            password: password,
            identityPoolId: identityPoolId,
            userBucketName: userBucketName,
          );
        default:
          throw StateException(state, event);
      }
    default:
      throw StateException(state, event);
  }
}
