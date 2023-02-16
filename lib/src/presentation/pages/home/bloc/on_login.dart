part of home_page;

extension _OnLogin on _HomeBloc {
  void onLogin(
    _LoginEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _ConnectingState(
          currentPage: state.currentPage,
          user: event.response.user,
          gym: event.response.gym,
          accessToken: event.response.accessToken,
          password: state.password,
          refreshToken: event.response.refreshToken,
          userExploreResponse: state.userExploreResponse,
          socketConnection: (state as _ConnectingState).socketConnection,
        ),
      );
}
