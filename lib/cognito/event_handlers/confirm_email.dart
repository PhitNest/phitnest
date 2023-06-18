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
  sendConfirmation(CognitoUser user, String password) => emit(
        CognitoConfirmEmailLoadingState(
          pool: user.pool,
          user: user,
          password: password,
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
            password: final password
          ) ||
          CognitoConfirmEmailFailedState(
            user: final user,
            password: final password
          ):
      sendConfirmation(user, password);
    case CognitoLoginFailureState(failure: final failure):
      switch (failure) {
        case LoginConfirmationRequired(
            user: final user,
            password: final password
          ):
          sendConfirmation(user, password);
        default:
          throw StateException(state, event);
      }
    default:
      throw StateException(state, event);
  }
}
