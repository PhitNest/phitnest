part of home_page;

extension _OnRefreshSession on _HomeBloc {
  void onRefreshSession(
    _RefreshSessionEvent event,
    Emitter<_IHomeState> emit,
  ) async {
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.socketConnection.cancel();
      emit(
        _InitialState(
          currentPage: state.currentPage,
          logoPress: state.logoPress,
          socketConnection: CancelableOperation.fromFuture(
            connectSocket(event.response.accessToken),
          ),
        ),
      );
    }
  }
}
