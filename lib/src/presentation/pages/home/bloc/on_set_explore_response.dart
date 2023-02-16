part of home_page;

extension _OnSetExploreResponse on _HomeBloc {
  void onSetExploreResponse(
    _SetExploreResponseEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        _IExploreState(
          logoPress: (state as _IExploreState).logoPress,
          user: state.user,
          gym: state.gym,
          accessToken: state.accessToken,
          password: state.password,
          refreshToken: state.refreshToken,
          userExploreResponse: event.response,
          socketConnection: (state as _IExploreState).socketConnection,
        ),
      );
}
