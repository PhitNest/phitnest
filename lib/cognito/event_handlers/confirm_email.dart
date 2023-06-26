part of '../cognito.dart';

Future<bool> _confirmEmail({
  required CognitoUser user,
  required String code,
}) async {
  try {
    await user.confirmRegistration(code);
    return true;
  } catch (_) {
    return false;
  }
}

void _handleConfirmEmail(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoConfirmEmailEvent event,
  Emitter<CognitoState> emit,
) {
  sendConfirmation({
    required CognitoUser user,
    required String password,
    required String identityPoolId,
    required String userBucketName,
  }) =>
      emit(
        CognitoConfirmEmailLoadingState(
          pool: user.pool,
          user: user,
          userBucketName: userBucketName,
          password: password,
          identityPoolId: identityPoolId,
          loadingOperation: CancelableOperation.fromFuture(
            _confirmEmail(
              user: user,
              code: event.confirmationCode,
            ),
          )..then(
              (confirmed) => add(
                confirmed
                    ? CognitoLoginEvent(
                        email: user.username!,
                        password: password,
                      )
                    : const CognitoConfirmEmailFailedEvent(),
              ),
            ),
        ),
      );

  switch (state) {
    case CognitoResendConfirmEmailResponseState(
            user: final user,
            password: final password,
            identityPoolId: final identityPoolId,
            userBucketName: final userBucketName,
          ) ||
          CognitoConfirmEmailFailedState(
            user: final user,
            password: final password,
            identityPoolId: final identityPoolId,
            userBucketName: final userBucketName,
          ):
      sendConfirmation(
        user: user,
        password: password,
        identityPoolId: identityPoolId,
        userBucketName: userBucketName,
      );
    case CognitoLoginFailureState(
        failure: final failure,
        identityPoolId: final identityPoolId,
        userBucketName: final userBucketName,
      ):
      switch (failure) {
        case LoginConfirmationRequired(
            user: final user,
            password: final password
          ):
          sendConfirmation(
            user: user,
            userBucketName: userBucketName,
            password: password,
            identityPoolId: identityPoolId,
          );
        default:
          throw StateException(state, event);
      }
    default:
      throw StateException(state, event);
  }
}
