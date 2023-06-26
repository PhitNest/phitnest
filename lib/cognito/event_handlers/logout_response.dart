part of '../cognito.dart';

void _handleLogoutResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoLogoutResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoggingOutState(
        session: final session,
        identityPoolId: final identityPoolId,
      ):
      emit(
        CognitoLoadedPoolInitialState(
          pool: session.user.pool,
          identityPoolId: identityPoolId,
          userBucketName: session.userBucketName,
        ),
      );
    default:
      throw StateException(state, event);
  }
}
