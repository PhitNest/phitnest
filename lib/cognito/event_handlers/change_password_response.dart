part of '../cognito.dart';

void _handleChangePasswordResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoChangePasswordResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoChangePasswordLoadingState(
        pool: final pool,
        user: final user,
        userBucketName: final userBucketName,
        identityPoolId: final identityPoolId,
      ):
      emit(switch (event.response) {
        ChangePasswordSuccess(session: final session) =>
          CognitoLoggedInInitialState(
            session: session,
            identityPoolId: identityPoolId,
          ),
        ChangePasswordFailureResponse() => CognitoChangePasswordFailureState(
            pool: pool,
            user: user,
            failure: event.response as ChangePasswordFailureResponse,
            identityPoolId: identityPoolId,
            userBucketName: userBucketName,
          ),
      });
    default:
      throw StateException(state, event);
  }
}
