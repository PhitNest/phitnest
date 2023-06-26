part of '../cognito.dart';

Future<LoginResponse> _login({
  required String email,
  required String password,
  required CognitoUserPool pool,
  required String identityPoolId,
  required String userBucketName,
  required bool admin,
}) async {
  final user = CognitoUser(email, pool);
  try {
    final session = await user.authenticateUser(
      AuthenticationDetails(
        username: email,
        password: password,
      ),
    );
    if (session != null) {
      final userId = session.accessToken.getSub();
      if (userId != null) {
        final credentials = CognitoCredentials(identityPoolId, pool);
        if (admin) {
          await credentials
              .getAwsCredentials(session.getIdToken().getJwtToken());
        }
        await _cacheEmail(email);
        await cacheString(kUserBucketJsonKey, userBucketName);
        return LoginSuccess(
          session: Session(
            user: user,
            session: session,
            credentials: credentials,
            identityPoolId: identityPoolId,
            userId: userId,
            userBucketName: userBucketName,
          ),
        );
      }
    }
    return const LoginUnknownResponse();
  } on CognitoUserConfirmationNecessaryException catch (_) {
    return LoginConfirmationRequired(user: user, password: password);
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' =>
        const LoginFailure(LoginFailureType.invalidUserPool),
      'NotAuthorizedException' =>
        const LoginFailure(LoginFailureType.invalidEmailPassword),
      'UserNotFoundException' =>
        const LoginFailure(LoginFailureType.noSuchUser),
      _ => LoginUnknownResponse(message: error.message),
    };
  } on ArgumentError catch (_) {
    return const LoginFailure(LoginFailureType.invalidUserPool);
  } on CognitoUserNewPasswordRequiredException {
    return LoginChangePasswordRequired(user);
  } catch (err) {
    return LoginUnknownResponse(message: err.toString());
  }
}

void _handleLogin(
  CognitoState state,
  bool admin,
  void Function(CognitoEvent) add,
  CognitoLoginEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoadingPreviousSessionState() ||
          CognitoLoggedInInitialState() ||
          CognitoLoggingOutState():
      throw StateException(state, event);
    case CognitoLoadingPoolsState(loadingOperation: final loadingOperation):
      emit(
        CognitoInitialEventQueuedState(
          loadingOperation: loadingOperation,
          queuedEvent: event,
        ),
      );
    case CognitoLoadedPoolState(
        pool: final pool,
        identityPoolId: final identityPoolId,
        userBucketName: final userBucketName,
      ):
      switch (state) {
        case CognitoLoginLoadingState() ||
              CognitoLoggedInInitialState() ||
              CognitoRegisterLoadingState() ||
              CognitoResendConfirmEmailLoadingState() ||
              CognitoChangePasswordLoadingState():
          throw StateException(state, event);
        case CognitoLoadedPoolInitialState() ||
              CognitoChangePasswordFailureState() ||
              CognitoRegisterFailureState() ||
              CognitoLoginFailureState() ||
              CognitoResendConfirmEmailResponseState() ||
              CognitoConfirmEmailLoadingState() ||
              CognitoConfirmEmailFailedState():
          emit(
            CognitoLoginLoadingState(
              pool: pool,
              identityPoolId: identityPoolId,
              userBucketName: userBucketName,
              loadingOperation: CancelableOperation.fromFuture(
                _login(
                  admin: admin,
                  email: event.email,
                  password: event.password,
                  pool: pool,
                  userBucketName: userBucketName,
                  identityPoolId: identityPoolId,
                ),
              )..then(
                  (response) => add(
                    CognitoLoginResponseEvent(response: response),
                  ),
                ),
            ),
          );
      }
  }
}
