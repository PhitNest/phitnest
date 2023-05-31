part of '../cognito.dart';

Future<HttpResponse<Cognito>> requestServerStatus(bool admin) => request(
      route: '/auth',
      method: HttpMethod.get,
      parser: (status) => Cognito.fromJson(status, admin),
    );

class CognitoBloc extends Bloc<CognitoEvent, CognitoState> {
  final bool admin;

  CognitoBloc(this.admin)
      : super(
          CognitoInitialState(
            loadingOperation:
                CancelableOperation.fromFuture(requestServerStatus(admin)),
          ),
        ) {
    (state as CognitoInitialState).loadingOperation.then(
          (response) => add(
            CognitoResponseEvent(response: response),
          ),
        );
    on<CognitoResponseEvent>(
      (event, emit) {
        switch (event.response) {
          case HttpResponseOk(data: final cognito):
            switch (state) {
              case CognitoInitialState():
                emit(CognitoLoadedInitialState(cognito: cognito));
              case CognitoInitialEventQueuedState(
                  queuedEvent: final queuedEvent
                ):
                emit(CognitoLoadedInitialState(cognito: cognito));
                add(queuedEvent);
              case CognitoLoadedState():
                throw StateException(state, event);
            }
          case HttpResponseFailure():
            loadingOperation() =>
                CancelableOperation.fromFuture(requestServerStatus(admin))
                  ..then(
                    (response) => add(
                      CognitoResponseEvent(response: response),
                    ),
                  );
            switch (state) {
              case CognitoInitialState():
                emit(
                  CognitoInitialState(
                    loadingOperation: loadingOperation(),
                  ),
                );
              case CognitoInitialEventQueuedState(
                  queuedEvent: final queuedEvent
                ):
                emit(
                  CognitoInitialEventQueuedState(
                    loadingOperation: loadingOperation(),
                    queuedEvent: queuedEvent,
                  ),
                );
              case CognitoLoadedState():
                throw StateException(state, event);
            }
        }
      },
    );

    on<CognitoLoginEvent>(
      (event, emit) => switch (state) {
        CognitoLoadingState(loadingOperation: final loadingOperation) => emit(
            CognitoInitialEventQueuedState(
              loadingOperation: loadingOperation,
              queuedEvent: event,
            ),
          ),
        CognitoLoadedState(cognito: final cognito) => switch (
              state as CognitoLoadedState) {
            CognitoLoginLoadingState() => null, // Do nothing
            CognitoLoggedInState() ||
            CognitoChangePasswordLoadingState() =>
              throw StateException(state, event),
            CognitoLoadedInitialState() ||
            CognitoChangedPasswordState() ||
            CognitoChangePasswordFailureState() ||
            CognitoLoginFailureState() =>
              emit(
                CognitoLoginLoadingState(
                  cognito: cognito,
                  loadingOperation: CancelableOperation.fromFuture(
                    cognito.login(
                      event.email,
                      event.password,
                    ),
                  )..then(
                      (response) => add(
                        CognitoLoginResponseEvent(response: response),
                      ),
                    ),
                ),
              ),
          }
      },
    );

    on<CognitoLoginResponseEvent>(
      (event, emit) => switch (state) {
        CognitoLoginLoadingState(cognito: final cognito) => emit(
            switch (event.response) {
              LoginSuccess(userId: final userId) => CognitoLoggedInState(
                  cognito: cognito,
                  userId: userId,
                ),
              LoginCognitoFailure(type: final type, message: final message) ||
              LoginFailure(type: final type, message: final message) =>
                CognitoLoginFailureState(
                  cognito: cognito,
                  type: type,
                  message: message,
                ),
            },
          ),
        _ => throw StateException(state, event),
      },
    );

    on<CognitoCancelRequestEvent>(
      (event, emit) => switch (state) {
        CognitoInitialEventQueuedState(
          loadingOperation: final loadingOperation
        ) =>
          CognitoInitialState(loadingOperation: loadingOperation),
        CognitoInitialState() ||
        CognitoLoginFailureState() =>
          null, // Do nothing
        CognitoLoadedState(cognito: final cognito) => switch (
              state as CognitoLoadedState) {
            CognitoChangePasswordLoadingState(
              loadingOperation: final CancelableOperation<dynamic>
                  loadingOperation
            ) ||
            CognitoLoginLoadingState(
              loadingOperation: final CancelableOperation<dynamic>
                  loadingOperation
            ) =>
              loadingOperation.cancel().then(
                  (_) => emit(CognitoLoadedInitialState(cognito: cognito))),
            CognitoChangePasswordFailureState() ||
            CognitoLoadedInitialState() ||
            CognitoLoggedInState() ||
            CognitoChangedPasswordState() ||
            CognitoLoginFailureState() =>
              null,
          }
      },
    );

    on<CognitoChangePasswordEvent>(
      (event, emit) => switch (state) {
        CognitoInitialState(loadingOperation: final loadingOperation) ||
        CognitoInitialEventQueuedState(
          loadingOperation: final loadingOperation
        ) =>
          emit(
            CognitoInitialEventQueuedState(
              loadingOperation: loadingOperation,
              queuedEvent: event,
            ),
          ),
        CognitoLoadedState(cognito: final cognito) => switch (
              state as CognitoLoadedState) {
            CognitoLoginLoadingState() => throw StateException(state, event),
            CognitoChangePasswordLoadingState() => null, // Do nothing
            CognitoLoadedInitialState() ||
            CognitoLoggedInState() ||
            CognitoChangePasswordFailureState() ||
            CognitoChangedPasswordState() ||
            CognitoLoginFailureState() =>
              emit(
                CognitoChangePasswordLoadingState(
                  cognito: cognito,
                  loadingOperation: CancelableOperation.fromFuture(
                    cognito.changePassword(
                      newPassword: event.newPassword,
                    ),
                  )..then(
                      (response) => add(
                        CognitoChangePasswordResponseEvent(response: response),
                      ),
                    ),
                ),
              ),
          }
      },
    );

    on<CognitoChangePasswordResponseEvent>(
      (event, emit) => switch (state) {
        CognitoChangePasswordLoadingState(cognito: final cognito) => emit(
            switch (event.response) {
              null => CognitoChangedPasswordState(cognito: cognito),
              ChangePasswordCognitoFailure(
                type: final type,
                message: final message
              ) ||
              ChangePasswordFailure(type: final type, message: final message) =>
                CognitoChangePasswordFailureState(
                  cognito: cognito,
                  type: type,
                  message: message,
                ),
            },
          ),
        _ => throw StateException(state, event),
      },
    );
  }

  @override
  Future<void> close() async {
    switch (state) {
      case CognitoLoadingState(
          loadingOperation: final CancelableOperation<dynamic> loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoChangePasswordLoadingState(
          loadingOperation: final CancelableOperation<dynamic> loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoLoginLoadingState(
          loadingOperation: final CancelableOperation<dynamic> loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoInitialState() ||
            CognitoInitialEventQueuedState() ||
            CognitoLoadedState() ||
            CognitoLoadedInitialState() ||
            CognitoLoggedInState() ||
            CognitoChangedPasswordState() ||
            CognitoChangePasswordFailureState() ||
            CognitoLoginFailureState():
    }
    await super.close();
  }
}
