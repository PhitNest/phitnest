part of home_page;

extension _OnSetPage on _HomeBloc {
  void onSetPage(
    _SetPageEvent event,
    Emitter<_IHomeState> emit,
  ) {
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      emit(
        _InitialState(
          darkMode: false,
          currentPage: event.page,
          logoPress: state.logoPress,
          socketConnection: state.socketConnection,
          logoPressBroadcast: state.logoPressBroadcast,
        ),
      );
    } else if (state is _SocketConnectedState) {
      final state = this.state as _SocketConnectedState;
      emit(
        _SocketConnectedState(
          darkMode: false,
          currentPage: event.page,
          logoPress: state.logoPress,
          connection: state.connection,
          logoPressBroadcast: state.logoPressBroadcast,
        ),
      );
    } else if (state is _LogOutState) {
      final state = this.state as _LogOutState;
      emit(
        _LogOutState(
          darkMode: false,
          currentPage: event.page,
          logoPress: state.logoPress,
          logoPressBroadcast: state.logoPressBroadcast,
        ),
      );
    }
  }
}
