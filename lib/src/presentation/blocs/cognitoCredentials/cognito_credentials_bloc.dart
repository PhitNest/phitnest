import 'package:async/async.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phitnest_utils/utils.dart';

import '../../../common/cache_keys.dart';
import '../../../common/invalid_state_event.dart';
import '../../../data/auth/auth.dart';
import '../../../entities/entities.dart';
import 'event/event.dart';
import 'state/state.dart';

class CognitoCredentialsBloc
    extends Bloc<CognitoCredentialsEvent, CognitoCredentialsState> {
  static CognitoCredentialsState get initialState {
    final cachedCredentials = getCachedObject(
        kCognitoCredentialsCacheKey, CognitoCredentialsEntity.fromJson);
    return cachedCredentials != null
        ? CognitoCredentialsState.loaded(credentials: cachedCredentials)
        : const CognitoCredentialsState.initial();
  }

  CancelableOperation<
          Either<CognitoCredentialsEntity, NetworkConnectionFailure>>
      load() => CancelableOperation.fromFuture(
            getCognitoCredentials().then(
              (res) => res.fold(
                (credentials) async => Left(
                  (await credentials
                          .whenOrNull<Future<CognitoCredentialsEntity?>>(
                        (_, __) => cacheObject(
                          kCognitoCredentialsCacheKey,
                          credentials,
                        ).then(
                          (_) => credentials,
                        ),
                      )) ??
                      credentials,
                ),
                (networkFailure) => Right(networkFailure),
              ),
            ),
          )..then(
              (res) => add(
                res.fold(
                  (credentials) =>
                      CognitoCredentialsEvent.loaded(response: credentials),
                  (networkFailure) =>
                      const CognitoCredentialsEvent.networkFailure(),
                ),
              ),
            );

  CognitoCredentialsBloc() : super(initialState) {
    on<CognitoCredentialsLoadedEvent>(
      (event, emit) => state.maybeWhen(
        loading: (_) =>
            emit(CognitoCredentialsState.loaded(credentials: event.response)),
        reloading: (_, __) =>
            emit(CognitoCredentialsState.loaded(credentials: event.response)),
        orElse: () => throw InvalidStateEventException(state, event),
      ),
    );
    on<CognitoCredentialsLoadEvent>(
      (event, emit) => state.maybeWhen(
        loaded: (credentials) => emit(
          CognitoCredentialsState.reloading(
            credentials: credentials,
            operation: load(),
          ),
        ),
        initial: () => emit(CognitoCredentialsState.loading(operation: load())),
        orElse: () => throw InvalidStateEventException(state, event),
      ),
    );
    on<CognitoCredentialsNetworkFailureEvent>(
      (event, emit) => state.maybeWhen(
        loading: (operation) {
          return emit(CognitoCredentialsState.loading(operation: load()));
        },
        reloading: (credentials, operation) {
          return emit(CognitoCredentialsState.reloading(
              credentials: credentials, operation: load()));
        },
        orElse: () => throw InvalidStateEventException(state, event),
      ),
    );
    if (state is CognitoCredentialsInitialState) {
      add(const CognitoCredentialsEvent.load());
    }
  }
}
