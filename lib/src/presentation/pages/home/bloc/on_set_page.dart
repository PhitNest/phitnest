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
          currentPage: event.page,
          logoPress: state.logoPress,
          socketConnection: state.socketConnection,
        ),
      );
    } else if (state is _SocketConnectedState) {
      final state = this.state as _SocketConnectedState;
      emit(
        _SocketConnectedState(
          currentPage: event.page,
          logoPress: state.logoPress,
          connection: state.connection,
        ),
      );
    } else if (state is _LogOutState) {
      final state = this.state as _LogOutState;
      emit(
        _LogOutState(
          currentPage: event.page,
          logoPress: state.logoPress,
        ),
      );
    }
  }
}
