part of home_page;

extension _OnSocketConnectError on _HomeBloc {
  void onSocketConnectError(
    _SocketConnectErrorEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _InitialState(
          currentPage: state.currentPage,
          logoPress: state.logoPress,
          socketConnection: CancelableOperation.fromFuture(
            connectSocket(Cache.accessToken!),
          )..then(
              (either) => add(
                either.fold(
                  (socketConnection) => _SocketConnectedEvent(socketConnection),
                  (failure) => const _SocketConnectErrorEvent(),
                ),
              ),
            ),
        ),
      );
}
