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
            AuthLoadedEvent(response: response),
          ),
        );
    on<AuthLoadedEvent>(
      (event, emit) => switch (state) {
        AuthInitialState() || AuthReloadingState() => emit(
            switch (event.response) {
              HttpResponseOk(data: final auth) =>
                AuthLoadedInitialState(auth: auth),
              HttpResponseFailure(failure: final failure) => AuthReloadingState(
                  loadingOperation:
                      CancelableOperation.fromFuture(requestServerStatus(admin))
                        ..then(
                          (response) => add(
                            AuthLoadedEvent(response: response),
                          ),
                        ),
                  failure: failure,
                ),
            },
          ),
        AuthLoadedState() => throw StateException(state, event),
      },
    );
    on<AuthLoginEvent>(
      (event, emit) => switch (state) {
        AuthLoadingState() ||
        AuthLoginLoadingState() ||
        AuthLoggedInState() =>
          throw StateException(state, event),
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
        AuthLoadingState() ||
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
