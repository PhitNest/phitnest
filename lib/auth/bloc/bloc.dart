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
              case AuthLoadedInitialState() ||
                    AuthLoginFailureState() ||
                    AuthLoggedInState() ||
                    AuthLoginLoadingState():
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
                AuthInitialEventQueuedState(
                  loadingOperation: loadingOperation(),
                  queuedEvent: queuedEvent,
                );
              case AuthLoadedInitialState() ||
                    AuthLoginFailureState() ||
                    AuthLoggedInState() ||
                    AuthLoginLoadingState():
                throw StateException(state, event);
            }
        }
      },
    );

    on<AuthLoginEvent>(
      (event, emit) => switch (state) {
        AuthLoginLoadingState() => null, // Do nothing
        AuthLoggedInState() => throw StateException(state, event),
        AuthInitialState(loadingOperation: final loadingOperation) ||
        AuthInitialEventQueuedState(loadingOperation: final loadingOperation) =>
          AuthInitialEventQueuedState(
            loadingOperation: loadingOperation,
            queuedEvent: event,
          ),
        AuthLoadedInitialState(auth: final auth) ||
        AuthLoginFailureState(auth: final auth) =>
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
      },
    );
    on<AuthLoginResponseEvent>(
      (event, emit) => switch (state) {
        AuthInitialState() ||
        AuthInitialEventQueuedState() ||
        AuthLoadedInitialState() ||
        AuthLoginFailureState() ||
        AuthLoggedInState() =>
          throw StateException(state, event),
        AuthLoginLoadingState(auth: final auth) => switch (event.response) {
            LoginSuccess(userId: final userId) => AuthLoggedInState(
                auth: auth,
                userId: userId,
              ),
            LoginFailure(type: final type) => AuthLoginFailureState(
                auth: auth,
                message: type.message,
              ),
          },
      },
    );
  }
}
