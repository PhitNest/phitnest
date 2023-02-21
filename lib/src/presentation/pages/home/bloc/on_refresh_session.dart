part of home_page;

extension _OnRefreshSession on _HomeBloc {
  void onRefreshSession(
    _RefreshSessionEvent event,
    Emitter<_IHomeState> emit,
  ) async {
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.socketConnection.cancel();
    }
    if (state is _SocketConnectedState) {
      final state = this.state as _SocketConnectedState;
      state.connection.disconnect();
    }
    emit(
      _InitialState(
        darkMode: state.darkMode,
        currentPage: state.currentPage,
        logoPress: state.logoPress,
        logoPressBroadcast: state.logoPressBroadcast,
        logoPressListener: state.logoPressListener,
        freezeLogoAnimation: state.freezeLogoAnimation,
        socketConnection: CancelableOperation.fromFuture(
          connectSocket(event.response.accessToken),
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
}
