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
          (response) => add(CognitoPreviousSessionEvent(session: response)),
        );

    on<CognitoPreviousSessionEvent>(
        (event, emit) => handlePreviousSessionLoaded(state, add, event, emit));

    on<CognitoPoolsResponseEvent>(
        (event, emit) => handlePoolsResponse(state, add, admin, event, emit));

    on<CognitoLoginEvent>(
        (event, emit) => handleLogin(state, add, event, emit));

    on<CognitoLoginResponseEvent>(
        (event, emit) => handleLoginResponse(state, add, event, emit));

    on<CognitoCancelRequestEvent>(
        (event, emit) => handleCancelRequest(state, add, event, emit));

    on<CognitoChangePasswordEvent>(
        (event, emit) => handleChangePassword(state, add, event, emit));

    on<CognitoChangePasswordResponseEvent>(
        (event, emit) => handleChangePasswordResponse(state, add, event, emit));
  }

  @override
  Future<void> close() async {
    switch (state) {
      case CognitoLoadingPreviousSessionState(
          loadingOperation: final CancelableOperation<Session?> loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoLoadingPoolsState(
          loadingOperation: final CancelableOperation<HttpResponse<Pools>>
              loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoChangePasswordLoadingState(
          loadingOperation: final CancelableOperation<ChangePasswordFailure?>
              loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoLoginLoadingState(
          loadingOperation: final CancelableOperation<LoginResponse>
              loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoLoadingPoolsState() ||
            CognitoLoadedPoolInitialState() ||
            CognitoChangePasswordLoadingState() ||
            CognitoInitialEventQueuedState() ||
            CognitoLoggedInState() ||
            CognitoChangePasswordFailureState() ||
            CognitoLoginFailureState():
    }
    await super.close();
  }
}
