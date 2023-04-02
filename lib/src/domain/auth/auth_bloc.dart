import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth/auth.dart';
import 'event/event.dart';
import 'state/state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(
          AuthState.loadingServerStatus(
            operation: CancelableOperation.fromFuture(
              getServerStatus(),
            ),
          ),
        ) {
    on<ServerStatusLoaded>(
      (event, emit) => emit(
        AuthState.loadedServerStatus(serverStatus: event.serverStatus),
      ),
    );
    on<AuthEventNetworkFailure>(
      (event, emit) => emit(
        AuthState.loadingServerStatus(
          operation: CancelableOperation.fromFuture(
            getServerStatus(),
          )..then(
              (response) => add(
                response.fold(
                  (serverStatus) => AuthEvent.loadedServerStatus(
                    serverStatus: serverStatus,
                  ),
                  (networkFailure) => const AuthEvent.networkFailure(),
                ),
              ),
            ),
        ),
      ),
    );
    if (state is ServerStatusStateLoading) {
      (state as ServerStatusStateLoading).operation.then(
            (response) => add(
              response.fold(
                (serverStatus) => AuthEvent.loadedServerStatus(
                  serverStatus: serverStatus,
                ),
                (networkFailure) => const AuthEvent.networkFailure(),
              ),
            ),
          );
    }
  }
}
