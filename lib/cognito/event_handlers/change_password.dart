part of '../cognito.dart';

Future<ChangePasswordResponse> _changePassword({
  required String newPassword,
  required CognitoUser user,
  required String identityPoolId,
  required String userBucketName,
  required bool admin,
}) async {
  try {
    final session = await user.sendNewPasswordRequiredAnswer(
      newPassword,
    );
    if (session != null) {
      await _cacheEmail(user.username!);
      final credentials = CognitoCredentials(
        identityPoolId,
        user.pool,
      );
      if (!admin) {
        await credentials.getAwsCredentials(
          session.getIdToken().getJwtToken(),
        );
      }
      await cacheString(kUserBucketJsonKey, userBucketName);
      return ChangePasswordSuccess(
        Session(
          user: user,
          session: session,
          credentials: credentials,
          identityPoolId: identityPoolId,
          userBucketName: userBucketName,
          userId: session.getAccessToken().getSub()!,
        ),
      );
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
  bool admin,
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
    case CognitoLoginFailureState(
        pool: final pool,
        failure: final failure,
        userBucketName: final userBucketName,
        identityPoolId: final identityPoolId,
      ):
      switch (failure) {
        case LoginChangePasswordRequired(
                user: final user,
              ) ||
              CognitoChangePasswordFailureState(user: final user):
          emit(
            CognitoChangePasswordLoadingState(
              pool: pool,
              user: user,
              userBucketName: userBucketName,
              identityPoolId: identityPoolId,
              loadingOperation: CancelableOperation.fromFuture(
                _changePassword(
                  newPassword: event.newPassword,
                  user: user,
                  userBucketName: userBucketName,
                  identityPoolId: identityPoolId,
                  admin: admin,
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
    case CognitoChangePasswordFailureState(
        user: final user,
        userBucketName: final userBucketName,
        pool: final pool,
        identityPoolId: final identityPoolId,
      ):
      CognitoChangePasswordLoadingState(
        pool: pool,
        userBucketName: userBucketName,
        user: user,
        identityPoolId: identityPoolId,
        loadingOperation: CancelableOperation.fromFuture(
          _changePassword(
            admin: admin,
            newPassword: event.newPassword,
            user: user,
            userBucketName: userBucketName,
            identityPoolId: identityPoolId,
          ),
        )..then(
            (response) => add(
              CognitoChangePasswordResponseEvent(response: response),
            ),
          ),
      );
  }
}
