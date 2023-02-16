part of home_page;

extension _OnLogOut on _HomeBloc {
  void onLogOut(
    _LogOutEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _LogOutConnectedState(
          currentPage: state.currentPage,
          user: state.user,
          gym: state.gym,
          accessToken: state.accessToken,
          password: state.password,
          refreshToken: state.refreshToken,
          userExploreResponse: state.userExploreResponse,
          socketConnection: (state as _SocketConnectedState).socketConnection,
        ),
      );
}
