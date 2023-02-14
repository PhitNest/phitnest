part of home_page;

extension _OnSetPage on _HomeBloc {
  void onSetPage(
    _SetPageEvent event,
    Emitter<_HomeState> emit,
  ) =>
      emit(
        event.page == NavbarPage.explore
            ? _ExploreState(
                user: state.user,
                gym: state.gym,
                accessToken: state.accessToken,
                password: state.password,
                refreshToken: state.refreshToken,
                logoPress: StreamController(),
                userExploreResponse: state.userExploreResponse,
              )
            : _InitialState(
                currentPage: event.page,
                user: state.user,
                gym: state.gym,
                accessToken: state.accessToken,
                password: state.password,
                refreshToken: state.refreshToken,
                userExploreResponse: state.userExploreResponse,
              ),
      );
}
