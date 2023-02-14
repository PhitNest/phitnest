part of home_page;

extension _OnLoadedUser on _HomeBloc {
  void onLoadedUser(
    _LoadedUserEvent event,
    Emitter<_HomeState> emit,
  ) =>
      emit(
        state is _ExploreState
            ? _ExploreState(
                user: event.response,
                gym: event.response.gym,
                accessToken: state.accessToken,
                refreshToken: state.refreshToken,
                password: state.password,
                userExploreResponse: state.userExploreResponse,
                logoPress: (state as _ExploreState).logoPress,
              )
            : _InitialState(
                currentPage: state.currentPage,
                user: event.response,
                gym: event.response.gym,
                accessToken: state.accessToken,
                password: state.password,
                refreshToken: state.refreshToken,
                userExploreResponse: state.userExploreResponse,
              ),
      );
}
