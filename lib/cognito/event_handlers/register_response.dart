part of '../cognito.dart';

void _handleRegisterResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoRegisterResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoRegisterLoadingState(
        pool: final pool,
        identityPoolId: final identityPoolId,
        userBucketName: final userBucketName,
      ):
      emit(
        switch (event.response) {
          RegisterSuccess(user: final user, password: final password) =>
            CognitoLoginLoadingState(
              pool: pool,
              identityPoolId: identityPoolId,
              userBucketName: userBucketName,
              loadingOperation: CancelableOperation.fromFuture(
                _login(
                  email: user.username!,
                  password: password,
                  userBucketName: userBucketName,
                  pool: pool,
                  identityPoolId: identityPoolId,
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
              identityPoolId: identityPoolId,
              failure: event.response as RegisterFailureResponse,
              userBucketName: userBucketName,
            ),
        },
      );
    default:
      throw StateException(state, event);
  }
}
