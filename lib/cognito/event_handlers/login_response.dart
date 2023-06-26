part of '../cognito.dart';

void _handleLoginResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoLoginResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoginLoadingState(
        pool: final pool,
        identityPoolId: final identityPoolId,
        userBucketName: final userBucketName,
      ):
      emit(
        switch (event.response) {
          LoginSuccess(session: final session) => CognitoLoggedInInitialState(
              session: session,
              identityPoolId: identityPoolId,
            ),
          LoginFailureResponse() => CognitoLoginFailureState(
              pool: pool,
              identityPoolId: identityPoolId,
              userBucketName: userBucketName,
              failure: event.response as LoginFailureResponse,
            ),
        },
      );
    default:
      throw StateException(state, event);
  }
}
