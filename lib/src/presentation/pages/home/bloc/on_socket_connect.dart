part of home_page;

extension _OnSocketConnectError on _HomeBloc {
  void onSocketConnected(
    _SocketConnectedEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _SocketConnectedState(
          currentPage: state.currentPage,
          logoPress: state.logoPress,
          connection: event.connection,
        ),
      );
}
