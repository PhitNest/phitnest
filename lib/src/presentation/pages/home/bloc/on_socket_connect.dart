part of home_page;

extension _OnSocketConnected on _HomeBloc {
  void onSocketConnected(
    _SocketConnectedEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _SocketConnectedState(
          darkMode: false,
          currentPage: state.currentPage,
          logoPress: state.logoPress,
          connection: event.connection,
          logoPressBroadcast: state.logoPressBroadcast,
        ),
      );
}
