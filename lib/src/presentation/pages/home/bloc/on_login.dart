part of home_page;

extension _OnLogin on _HomeBloc {
  void onLogin(
    _LoginEvent event,
    Emitter<_HomeState> emit,
  ) =>
      emit(
        _InitialState(
          user: event.response.user,
          gym: event.response.gym,
          accessToken: event.response.accessToken,
          password: state.password,
          refreshToken: event.response.refreshToken,
        ),
      );
}
