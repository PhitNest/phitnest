part of home_page;

extension _OnSetPage on _HomeBloc {
  void onSetPage(
    _SetPageEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(
        event.page == NavbarPage.explore
            ? _IExploreState(
                user: state.user,
                gym: state.gym,
                accessToken: state.accessToken,
                password: state.password,
                refreshToken: state.refreshToken,
                logoPress: StreamController(),
                userExploreResponse: state.userExploreResponse,
                socketConnection: (state as _IExploreState).socketConnection,
              )
            : _ConnectingState(
                currentPage: event.page,
                user: state.user,
                gym: state.gym,
                accessToken: state.accessToken,
                password: state.password,
                refreshToken: state.refreshToken,
                userExploreResponse: state.userExploreResponse,
                socketConnection: (state as _ConnectingState).socketConnection,
              ),
      );
}
