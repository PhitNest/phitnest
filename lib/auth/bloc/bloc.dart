part of '../auth.dart';

Future<HttpResponse<Auth>> requestServerStatus(bool admin) => request(
      route: '/auth',
      method: HttpMethod.get,
      parser: (status) => Auth.fromJson(status, admin),
    );

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final bool admin;

  AuthBloc(this.admin)
      : super(
          AuthInitialState(
            loadingOperation:
                CancelableOperation.fromFuture(requestServerStatus(admin)),
          ),
        ) {
    (state as AuthInitialState).loadingOperation.then(
          (response) => add(
            AuthResponseEvent(response: response),
          ),
        );
    on<AuthResponseEvent>(
      (event, emit) {
        switch (event.response) {
          case HttpResponseOk(data: final auth):
            switch (state) {
              case AuthInitialState():
                emit(AuthLoadedInitialState(auth: auth));
              case AuthInitialEventQueuedState(queuedEvent: final queuedEvent):
                emit(AuthLoadedInitialState(auth: auth));
                add(queuedEvent);
              case AuthLoadedState():
                throw StateException(state, event);
            }
          case HttpResponseFailure():
            loadingOperation() =>
                CancelableOperation.fromFuture(requestServerStatus(admin))
                  ..then(
                    (response) => add(
                      AuthResponseEvent(response: response),
                    ),
                  );
            switch (state) {
              case AuthInitialState():
                emit(
                  AuthInitialState(
                    loadingOperation: loadingOperation(),
                  ),
                );
              case AuthInitialEventQueuedState(queuedEvent: final queuedEvent):
                emit(
                  AuthInitialEventQueuedState(
                    loadingOperation: loadingOperation(),
                    queuedEvent: queuedEvent,
                  ),
                );
              case AuthLoadedState():
                throw StateException(state, event);
            }
        }
      },
    );

    on<AuthLoginEvent>(
      (event, emit) => switch (state) {
        AuthLoadingState(loadingOperation: final loadingOperation) => emit(
            AuthInitialEventQueuedState(
              loadingOperation: loadingOperation,
              queuedEvent: event,
            ),
          ),
        AuthLoadedState(auth: final auth) => switch (state as AuthLoadedState) {
            AuthLoginLoadingState() => null, // Do nothing
            AuthLoggedInState() ||
            AuthChangePasswordLoadingState() =>
              throw StateException(state, event),
            AuthLoadedInitialState() ||
            AuthChangedPasswordState() ||
            AuthChangePasswordFailureState() ||
            AuthLoginFailureState() =>
              emit(
                AuthLoginLoadingState(
                  auth: auth,
                  loadingOperation: CancelableOperation.fromFuture(
                    auth.login(
                      event.email,
                      event.password,
                    ),
                  )..then(
                      (response) => add(
                        AuthLoginResponseEvent(response: response),
                      ),
                    ),
                ),
              ),
          }
      },
    );

    on<AuthLoginResponseEvent>(
      (event, emit) => switch (state) {
        AuthLoginLoadingState(auth: final auth) => emit(
            switch (event.response) {
              LoginSuccess(userId: final userId) => AuthLoggedInState(
                  auth: auth,
                  userId: userId,
                ),
              LoginCognitoFailure(type: final type, message: final message) ||
              LoginFailure(type: final type, message: final message) =>
                AuthLoginFailureState(
                  auth: auth,
                  type: type,
                  message: message,
                ),
            },
          ),
        _ => throw StateException(state, event),
      },
    );

    on<AuthCancelRequestEvent>(
      (event, emit) => switch (state) {
        AuthInitialEventQueuedState(loadingOperation: final loadingOperation) =>
          AuthInitialState(loadingOperation: loadingOperation),
        AuthInitialState() || AuthLoginFailureState() => null, // Do nothing
        AuthLoadedState(auth: final auth) => switch (state as AuthLoadedState) {
            AuthChangePasswordLoadingState(
              loadingOperation: final CancelableOperation<dynamic>
                  loadingOperation
            ) ||
            AuthLoginLoadingState(
              loadingOperation: final CancelableOperation<dynamic>
                  loadingOperation
            ) =>
              loadingOperation
                  .cancel()
                  .then((_) => emit(AuthLoadedInitialState(auth: auth))),
            AuthChangePasswordFailureState() ||
            AuthLoadedInitialState() ||
            AuthLoggedInState() ||
            AuthChangedPasswordState() ||
            AuthLoginFailureState() =>
              null,
          }
      },
    );

    on<AuthChangePasswordEvent>(
      (event, emit) => switch (state) {
        AuthInitialState(loadingOperation: final loadingOperation) ||
        AuthInitialEventQueuedState(loadingOperation: final loadingOperation) =>
          emit(
            AuthInitialEventQueuedState(
              loadingOperation: loadingOperation,
              queuedEvent: event,
            ),
          ),
        AuthLoadedState(auth: final auth) => switch (state as AuthLoadedState) {
            AuthLoginLoadingState() => throw StateException(state, event),
            AuthChangePasswordLoadingState() => null, // Do nothing
            AuthLoadedInitialState() ||
            AuthLoggedInState() ||
            AuthChangePasswordFailureState() ||
            AuthChangedPasswordState() ||
            AuthLoginFailureState() =>
              emit(
                AuthChangePasswordLoadingState(
                  auth: auth,
                  loadingOperation: CancelableOperation.fromFuture(
                    auth.changePassword(
                      email: event.email,
                      newPassword: event.newPassword,
                    ),
                  )..then(
                      (response) => add(
                        AuthChangePasswordResponseEvent(response: response),
                      ),
                    ),
                ),
              ),
          }
      },
    );

    on<AuthChangePasswordResponseEvent>(
      (event, emit) => switch (state) {
        AuthChangePasswordLoadingState(auth: final auth) => emit(
            switch (event.response) {
              null => AuthChangedPasswordState(auth: auth),
              ChangePasswordCognitoFailure(
                type: final type,
                message: final message
              ) ||
              ChangePasswordFailure(type: final type, message: final message) =>
                AuthChangePasswordFailureState(
                  auth: auth,
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
      case AuthLoadingState(
          loadingOperation: final CancelableOperation<dynamic> loadingOperation
        ):
        await loadingOperation.cancel();
      case AuthChangePasswordLoadingState(
          loadingOperation: final CancelableOperation<dynamic> loadingOperation
        ):
        await loadingOperation.cancel();
      case AuthLoginLoadingState(
          loadingOperation: final CancelableOperation<dynamic> loadingOperation
        ):
        await loadingOperation.cancel();
      case AuthInitialState() ||
            AuthInitialEventQueuedState() ||
            AuthLoadedState() ||
            AuthLoadedInitialState() ||
            AuthLoggedInState() ||
            AuthChangedPasswordState() ||
            AuthChangePasswordFailureState() ||
            AuthLoginFailureState():
    }
    await super.close();
  }
}
