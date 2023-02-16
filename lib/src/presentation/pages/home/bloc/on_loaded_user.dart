part of home_page;

extension _OnLoadedUser on _HomeBloc {
  void onLoadedUser(
    _LoadedUserEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        state is _IExploreState
            ? _IExploreState(
                user: event.response,
                gym: event.response.gym,
                accessToken: state.accessToken,
                refreshToken: state.refreshToken,
                password: state.password,
                userExploreResponse: state.userExploreResponse,
                logoPress: (state as _IExploreState).logoPress,
                socketConnection: (state as _IExploreState).socketConnection,
              )
            : _ConnectingState(
                currentPage: state.currentPage,
                user: event.response,
                gym: event.response.gym,
                accessToken: state.accessToken,
                password: state.password,
                refreshToken: state.refreshToken,
                userExploreResponse: state.userExploreResponse,
                socketConnection: (state as _ConnectingState).socketConnection,
              ),
      );
}
