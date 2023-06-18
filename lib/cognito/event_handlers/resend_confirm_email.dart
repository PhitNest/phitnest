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
  resendConfirmation(CognitoUser user, String password) => emit(
        CognitoResendConfirmEmailLoadingState(
          pool: user.pool,
          user: user,
          password: password,
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
          ) ||
          CognitoConfirmEmailFailedState(
            user: final user,
            password: final password,
          ):
      resendConfirmation(user, password);
    case CognitoLoginFailureState(failure: final failure):
      switch (failure) {
        case LoginConfirmationRequired(
            user: final user,
            password: final password,
          ):
          resendConfirmation(user, password);
        default:
          throw StateException(state, event);
      }
    default:
      throw StateException(state, event);
  }
}
