part of home_page;

extension _OnRefreshSession on _HomeBloc {
  void onRefreshSession(
    _RefreshSessionEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _ConnectingState(
          currentPage: state.currentPage,
          user: state.user,
          gym: state.gym,
          accessToken: event.response.accessToken,
          password: state.password,
          refreshToken: state.refreshToken,
          userExploreResponse: state.userExploreResponse,
          socketConnection: (state as _ConnectingState).socketConnection,
        ),
      );
}
