part of '../cognito.dart';

Future<RegisterResponse> _register({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required String inviterEmail,
  required CognitoUserPool pool,
}) async {
  try {
    final signUpResult = await pool.signUp(
      email,
      password,
      userAttributes: [
        AttributeArg(name: 'email', value: email),
      ],
      validationData: [
        AttributeArg(name: 'firstName', value: firstName),
        AttributeArg(name: 'lastName', value: lastName),
        AttributeArg(name: 'inviterEmail', value: inviterEmail),
      ],
    );
    if (signUpResult.userSub != null) {
      return RegisterSuccess(
        signUpResult.user,
        password,
      );
    } else {
      return const RegisterUnknownResponse();
    }
  } on CognitoClientException catch (error) {
    return switch (error.code) {
      'ResourceNotFoundException' =>
        const RegisterFailure((RegisterFailureType.invalidUserPool)),
      'UsernameExistsException' =>
        const RegisterFailure(RegisterFailureType.userExists),
      'InvalidPasswordException' => ValidationFailure(
          ValidationFailureType.invalidPassword,
          error.message,
        ),
      'InvalidParameterException' =>
        ValidationFailure(ValidationFailureType.invalidEmail, error.message),
      _ => RegisterUnknownResponse(message: error.message),
    };
  } on ArgumentError catch (_) {
    return const RegisterFailure(RegisterFailureType.invalidUserPool);
  } catch (err) {
    return RegisterUnknownResponse(message: err.toString());
  }
}

void _handleRegister(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoRegisterEvent event,
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
    case CognitoLoadedPoolState(pool: final pool):
      switch (state) {
        case CognitoRegisterLoadingState() ||
              CognitoLoginLoadingState() ||
              CognitoLoggedInInitialState() ||
              CognitoChangePasswordLoadingState():
          throw StateException(state, event);
        case CognitoLoadedPoolInitialState() ||
              CognitoChangePasswordFailureState() ||
              CognitoRegisterFailureState() ||
              CognitoLoginFailureState():
          emit(
            CognitoRegisterLoadingState(
              pool: pool,
              loadingOperation: CancelableOperation.fromFuture(
                _register(
                  email: event.email,
                  password: event.password,
                  firstName: event.firstName,
                  lastName: event.lastName,
                  inviterEmail: event.inviterEmail,
                  pool: pool,
                ),
              )..then(
                  (response) => add(
                    CognitoRegisterResponseEvent(response: response),
                  ),
                ),
            ),
          );
      }
  }
}
