part of home_page;

extension _OnLoadedUser on _HomeBloc {
  void onLoadedUser(
    _LoadedUserEvent event,
    Emitter<_HomeState> emit,
  ) =>
      emit(
        _InitialState(
          user: event.response,
          gym: event.response.gym,
          accessToken: state.accessToken,
          refreshToken: state.refreshToken,
        ),
      );
}
