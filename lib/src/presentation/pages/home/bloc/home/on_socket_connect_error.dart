part of home_page;

extension _HomeOnSocketConnectError on _HomeBloc {
  void onSocketConnectError(
    _HomeSocketConnectErrorEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _HomeInitialState(
          currentPage: state.currentPage,
          socketConnection: CancelableOperation.fromFuture(
            connectSocket(Cache.auth.accessToken!),
          )..then(
              (either) => add(
                either.fold(
                  (socketConnection) =>
                      _HomeSocketConnectedEvent(socketConnection),
                  (failure) => const _HomeSocketConnectErrorEvent(),
                ),
              ),
            ),
        ),
      );
}
