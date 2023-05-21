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
      (event, emit) => switch (event.response) {
        HttpResponseOk(data: final auth) => AuthLoadedState(auth: auth),
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
    );
  }
}
