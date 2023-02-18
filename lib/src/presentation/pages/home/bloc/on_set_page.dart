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
    }
  }
}
