part of '../cognito.dart';

void _handleRegisterResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoRegisterResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoRegisterLoadingState(pool: final pool):
      emit(
        switch (event.response) {
          RegisterSuccess(user: final user, password: final password) =>
            CognitoLoginLoadingState(
              pool: pool,
              loadingOperation: CancelableOperation.fromFuture(
                _login(
                  email: user.username!,
                  password: password,
                  pool: pool,
                ),
              )..then(
                  (res) => add(
                    CognitoLoginResponseEvent(
                      response: res,
                    ),
                  ),
                ),
            ),
          RegisterFailureResponse() => CognitoRegisterFailureState(
              pool: pool,
              failure: event.response as RegisterFailureResponse,
            ),
        },
      );
    default:
      throw StateException(state, event);
  }
}
