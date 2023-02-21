part of home_page;

extension _OnLogOut on _HomeBloc {
  void onLogOut(
    _LogOutEvent event,
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
      _LogOutState(
        darkMode: false,
        currentPage: state.currentPage,
        logoPress: state.logoPress,
        logoPressBroadcast: state.logoPressBroadcast,
        logoPressListener: state.logoPressListener,
        freezeLogoAnimation: true,
      ),
    );
  }
}
