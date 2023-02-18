part of home_page;

extension _OnLogOut on _HomeBloc {
  void onLogOut(
    _LogOutEvent event,
    Emitter<_IHomeState> emit,
  ) async {
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.socketConnection.cancel();
      emit(
        _LogOutState(
          currentPage: state.currentPage,
          logoPress: state.logoPress,
        ),
      );
    }
  }
}
