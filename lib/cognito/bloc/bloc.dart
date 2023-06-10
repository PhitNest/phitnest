part of '../cognito.dart';

Future<HttpResponse<Cognito>> requestServerAuthMode(bool admin) => request(
      route: '/auth',
      method: HttpMethod.get,
      parser: (status) =>
          admin ? Cognito.fromAdminJson(status) : Cognito.fromJson(status),
    );

const kCachedSessionDetailsCacheKey = 'cachedSessionDetails';

Future<Cognito?> restorePreviousSession() async {
  try {
    final cachedSession = getCachedObject(
        kCachedSessionDetailsCacheKey, _CachedSessionDetails.fromJson);
    if (cachedSession != null) {
      final pool =
          CognitoUserPool(cachedSession.poolId, cachedSession.clientId);
      final user = CognitoUser(cachedSession.username, pool);
      final session = await user.getSession();
      if (session != null) {
        final state = _CognitoState(user, session);
        return Cognito._fromSession(state: state, pool: pool);
      }
    }
  } catch (_) {
    // Do nothing
  }
  return null;
}

class CognitoBloc extends Bloc<CognitoEvent, CognitoState> {
  final bool admin;

  CognitoBloc(this.admin)
      : super(
          CognitoLoadingPreviousSessionState(
              loadingOperation:
                  CancelableOperation.fromFuture(restorePreviousSession())),
        ) {
    (state as CognitoLoadingPreviousSessionState).loadingOperation.then(
          (response) =>
              add(CognitoPreviousSessionEvent(cachedSession: response)),
        );

    on<CognitoPreviousSessionEvent>(
      (event, emit) {
        switch (state) {
          case CognitoLoadingPreviousSessionState():
            emit(
              event.cachedSession == null
                  ? CognitoLoadingModeInitialState(
                      loadingOperation: CancelableOperation.fromFuture(
                        requestServerAuthMode(admin),
                      )..then((cognito) =>
                          add(CognitoResponseEvent(response: cognito))),
                    )
                  : CognitoLoadedInitialState(cognito: event.cachedSession!),
            );
          default:
            throw StateException(state, event);
        }
      },
    );

    on<CognitoResponseEvent>(
      (event, emit) {
        switch (event.response) {
          case HttpResponseOk(data: final cognito):
            switch (state) {
              case CognitoLoadingModeInitialState():
                emit(CognitoLoadedInitialState(cognito: cognito));
              case CognitoInitialEventQueuedState(
                  queuedEvent: final queuedEvent
                ):
                emit(CognitoLoadedInitialState(cognito: cognito));
                add(queuedEvent);
              case CognitoLoadedState() || CognitoLoadingPreviousSessionState():
                throw StateException(state, event);
            }
          case HttpResponseFailure():
            loadingOperation() =>
                CancelableOperation.fromFuture(requestServerAuthMode(admin))
                  ..then(
                    (response) => add(
                      CognitoResponseEvent(response: response),
                    ),
                  );
            switch (state) {
              case CognitoLoadingModeInitialState():
                emit(
                  CognitoLoadingModeInitialState(
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
              case CognitoLoadedState() || CognitoLoadingPreviousSessionState():
                throw StateException(state, event);
            }
        }
      },
    );

    on<CognitoLoginEvent>(
      (event, emit) => switch (state) {
        CognitoLoadingPreviousSessionState() =>
          throw StateException(state, event),
        CognitoLoadingModeState(loadingOperation: final loadingOperation) =>
          emit(
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
        CognitoLoadingPreviousSessionState() =>
          throw StateException(state, event),
        CognitoInitialEventQueuedState(
          loadingOperation: final loadingOperation
        ) =>
          CognitoLoadingModeInitialState(loadingOperation: loadingOperation),
        CognitoLoadingModeInitialState() ||
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
        CognitoLoadingPreviousSessionState() =>
          throw StateException(state, event),
        CognitoLoadingModeInitialState(
          loadingOperation: final loadingOperation
        ) ||
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
      case CognitoLoadingPreviousSessionState(
          loadingOperation: final CancelableOperation<Cognito?> loadingOperation
        ):
        await loadingOperation.cancel();
      case CognitoLoadingModeState(
          loadingOperation: final CancelableOperation<HttpResponse<Cognito>>
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
      case CognitoLoadingModeInitialState() ||
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
