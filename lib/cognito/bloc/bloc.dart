part of '../cognito.dart';

class CognitoBloc extends Bloc<CognitoEvent, CognitoState> {
  final bool admin;

  CognitoBloc(this.admin)
      : super(
          CognitoLoadingPreviousSessionState(
            loadingOperation:
                CancelableOperation.fromFuture(_restorePreviousSession(admin)),
          ),
        ) {
    (state as CognitoLoadingPreviousSessionState).loadingOperation.then(
          (response) => add(
            CognitoPreviousSessionEvent(
              session: response,
              identityPoolId: response?.identityPoolId,
            ),
          ),
        );

    on<CognitoPreviousSessionEvent>(
        (event, emit) => _handlePreviousSessionLoaded(state, add, event, emit));

    on<CognitoPoolsResponseEvent>(
        (event, emit) => _handlePoolsResponse(state, add, admin, event, emit));

    on<CognitoLoginEvent>(
        (event, emit) => _handleLogin(state, add, event, emit));

    on<CognitoLoginResponseEvent>(
        (event, emit) => _handleLoginResponse(state, add, event, emit));

    on<CognitoCancelRequestEvent>(
        (event, emit) => _handleCancelRequest(state, add, event, emit));

    on<CognitoChangePasswordEvent>(
        (event, emit) => _handleChangePassword(state, add, event, emit));

    on<CognitoChangePasswordResponseEvent>((event, emit) =>
        _handleChangePasswordResponse(state, add, event, emit));

    on<CognitoRegisterEvent>(
      (event, emit) {
        if (admin) {
          throw StateError('Cannot register a user in the admin pool');
        }
        _handleRegister(state, add, event, emit);
      },
    );

    on<CognitoRegisterResponseEvent>(
        (event, emit) => _handleRegisterResponse(state, add, event, emit));

    on<CognitoLogoutEvent>(
        (event, emit) => _handleLogout(state, add, event, emit));

    on<CognitoLogoutResponseEvent>(
        (event, emit) => _handleLogoutResponse(state, add, event, emit));

    on<CognitoConfirmEmailEvent>(
        (event, emit) => _handleConfirmEmail(state, add, event, emit));

    on<CognitoResendConfirmEmailEvent>(
        (event, emit) => _handleResendConfirmEmail(state, add, event, emit));

    on<CognitoConfirmEmailFailedEvent>(
        (event, emit) => _handleConfirmEmailFailed(state, add, event, emit));

    on<CognitoResendConfirmEmailResponseEvent>((event, emit) =>
        _handleResendConfirmEmailResponse(state, add, event, emit));
  }

  @override
  Future<void> close() async {
    switch (state) {
      case CognitoLoggingOutState(loadingOperation: final loadingOperation):
        await loadingOperation.cancel();
      case CognitoLoadingPreviousSessionState(
          loadingOperation: final loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoRegisterLoadingState(
          loadingOperation: final loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoLoadingPoolsState(loadingOperation: final loadingOperation):
        await loadingOperation.cancel();
      case CognitoChangePasswordLoadingState(
          loadingOperation: final loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoLoginLoadingState(loadingOperation: final loadingOperation):
        await loadingOperation.cancel();
      case CognitoConfirmEmailLoadingState(
          loadingOperation: final loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoResendConfirmEmailLoadingState(
          loadingOperation: final loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoLoadingPoolsState() ||
            CognitoLoadedPoolInitialState() ||
            CognitoChangePasswordLoadingState() ||
            CognitoInitialEventQueuedState() ||
            CognitoLoggedInInitialState() ||
            CognitoChangePasswordFailureState() ||
            CognitoRegisterFailureState() ||
            CognitoConfirmEmailFailedState() ||
            CognitoResendConfirmEmailResponseState() ||
            CognitoLoginFailureState():
    }
    await super.close();
  }
}
