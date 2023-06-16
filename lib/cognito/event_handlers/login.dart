part of '../cognito.dart';

Future<LoginResponse> _login({
  required String email,
  required String password,
  required CognitoUserPool pool,
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
        await _cacheEmail(email);
        return LoginSuccess(
          session: Session(user, session),
        );
      }
    }
    return const LoginUnknownResponse();
  } on CognitoUserConfirmationNecessaryException catch (_) {
    return const LoginFailure(LoginFailureType.confirmationRequired);
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

void handleLogin(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoLoginEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoadingPreviousSessionState() || CognitoLoggedInState():
      throw StateException(state, event);
    case CognitoLoadingPoolsState(loadingOperation: final loadingOperation):
      emit(
        CognitoInitialEventQueuedState(
          loadingOperation: loadingOperation,
          queuedEvent: event,
        ),
      );
    case CognitoLoadedPoolState(pool: final pool):
      switch (state) {
        case CognitoLoginLoadingState() ||
              CognitoLoggedInState() ||
              CognitoChangePasswordLoadingState():
          throw StateException(state, event);
        case CognitoLoadedPoolInitialState() ||
              CognitoChangePasswordFailureState() ||
              CognitoLoginFailureState():
          emit(
            CognitoLoginLoadingState(
              pool: pool,
              loadingOperation: CancelableOperation.fromFuture(
                _login(
                  email: event.email,
                  password: event.password,
                  pool: pool,
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
