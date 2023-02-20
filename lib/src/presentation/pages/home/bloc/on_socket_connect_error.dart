part of home_page;

extension _OnSocketConnectError on _HomeBloc {
  void onSocketConnectError(
    _SocketConnectErrorEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _InitialState(
          darkMode: false,
          currentPage: state.currentPage,
          logoPress: state.logoPress,
          logoPressBroadcast: state.logoPressBroadcast,
          logoPressListener: state.logoPressListener,
          freezeLogoAnimation: state.freezeLogoAnimation,
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
