part of '../cognito.dart';

Future<void> _logout({
  required Session session,
}) async {
  await session.user.signOut();
  await _cacheEmail(null);
  await _cachePools(null);
}

void _handleLogout(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoLogoutEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoggedInInitialState(
        session: final session,
        identityPoolId: final identityPoolId
      ):
      emit(
        CognitoLoggingOutState(
          session: session,
          identityPoolId: identityPoolId,
          loadingOperation: CancelableOperation.fromFuture(
            _logout(session: session),
          )..then(
              (_) => add(
                CognitoLogoutResponseEvent(),
              ),
            ),
        ),
      );
    default:
      throw StateException(state, event);
  }
}
