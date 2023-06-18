part of '../cognito.dart';

Future<ChangePasswordResponse> _changePassword({
  required String newPassword,
  required CognitoUser user,
}) async {
  try {
    final session = await user.sendNewPasswordRequiredAnswer(
      newPassword,
    );
    if (session != null) {
      await _cacheEmail(user.username!);
      return ChangePasswordSuccess(Session(user, session));
    } else {
      return const ChangePasswordUnknownResponse();
    }
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' => const ChangePasswordFailure(
          ChangePasswordFailureType.invalidUserPool,
        ),
      'NotAuthorizedException' => const ChangePasswordFailure(
          ChangePasswordFailureType.invalidPassword,
        ),
      'UserNotFoundException' => const ChangePasswordFailure(
          ChangePasswordFailureType.noSuchUser,
        ),
      _ => ChangePasswordUnknownResponse(message: error.message),
    };
  } on ArgumentError catch (_) {
    return const ChangePasswordFailure(
      ChangePasswordFailureType.invalidUserPool,
    );
  } catch (err) {
    return ChangePasswordUnknownResponse(message: err.toString());
  }
}

void _handleChangePassword(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoChangePasswordEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoadingPreviousSessionState() ||
          CognitoLoginLoadingState() ||
          CognitoLoadedPoolInitialState() ||
          CognitoChangePasswordLoadingState() ||
          CognitoRegisterFailureState() ||
          CognitoRegisterLoadingState() ||
          CognitoLoggingOutState() ||
          CognitoConfirmEmailLoadingState() ||
          CognitoConfirmEmailFailedState() ||
          CognitoResendConfirmEmailLoadingState() ||
          CognitoResendConfirmEmailResponseState() ||
          CognitoLoggedInInitialState():
      throw StateException(state, event);
    case CognitoLoadingPoolsState(loadingOperation: final loadingOperation) ||
          CognitoInitialEventQueuedState(
            loadingOperation: final loadingOperation
          ):
      emit(
        CognitoInitialEventQueuedState(
          loadingOperation: loadingOperation,
          queuedEvent: event,
        ),
      );
    case CognitoLoginFailureState(pool: final pool, failure: final failure):
      switch (failure) {
        case LoginChangePasswordRequired(user: final user) ||
              CognitoChangePasswordFailureState(user: final user):
          emit(
            CognitoChangePasswordLoadingState(
              pool: pool,
              user: user,
              loadingOperation: CancelableOperation.fromFuture(
                _changePassword(
                  newPassword: event.newPassword,
                  user: user,
                ),
              )..then(
                  (response) => add(
                    CognitoChangePasswordResponseEvent(response: response),
                  ),
                ),
            ),
          );
        default:
          throw StateException(state, event);
      }
    case CognitoChangePasswordFailureState(user: final user, pool: final pool):
      CognitoChangePasswordLoadingState(
        pool: pool,
        user: user,
        loadingOperation: CancelableOperation.fromFuture(
          _changePassword(
            newPassword: event.newPassword,
            user: user,
          ),
        )..then(
            (response) => add(
              CognitoChangePasswordResponseEvent(response: response),
            ),
          ),
      );
  }
}
