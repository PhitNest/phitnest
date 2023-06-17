part of '../cognito.dart';

void _handleLogoutResponse(
  CognitoState state,
  void Function(CognitoEvent) add,
  CognitoLogoutResponseEvent event,
  Emitter<CognitoState> emit,
) {
  switch (state) {
    case CognitoLoggingOutState(session: final session):
      emit(
        CognitoLoadedPoolInitialState(
          pool: session.user.pool,
        ),
      );
    default:
      throw StateException(state, event);
  }
}
