part of home_page;

extension _OnRefreshSession on _HomeBloc {
  void onRefreshSession(
    _RefreshSessionEvent event,
    Emitter<_HomeState> emit,
  ) =>
      emit(
        _InitialState(
          currentPage: state.currentPage,
          user: state.user,
          gym: state.gym,
          accessToken: event.response.accessToken,
          password: state.password,
          refreshToken: state.refreshToken,
        ),
      );
}
