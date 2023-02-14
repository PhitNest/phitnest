part of home_page;

extension _OnSetExploreResponse on _HomeBloc {
  void onSetExploreResponse(
    _SetExploreResponseEvent event,
    Emitter<_HomeState> emit,
  ) =>
      emit(
        _ExploreState(
          logoPress: (state as _ExploreState).logoPress,
          user: state.user,
          gym: state.gym,
          accessToken: state.accessToken,
          password: state.password,
          refreshToken: state.refreshToken,
          userExploreResponse: event.response,
        ),
      );
}
