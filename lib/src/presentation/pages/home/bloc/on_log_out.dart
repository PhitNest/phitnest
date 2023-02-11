part of home_page;

extension _OnLogOut on _HomeBloc {
  void onLogOut(
    _LogOutEvent event,
    Emitter<_HomeState> emit,
  ) =>
      emit(
        _LogOutState(
          currentPage: state.currentPage,
          user: state.user,
          gym: state.gym,
          accessToken: state.accessToken,
          password: state.password,
          refreshToken: state.refreshToken,
        ),
      );
}
