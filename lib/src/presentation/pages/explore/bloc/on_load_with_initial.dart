part of explore_page;

extension _OnLoadWithInitial on _ExploreBloc {
  void onLoadWithInitial(
          _LoadWithInitialEvent event, Emitter<_ExploreState> emit) =>
      emit(
        _ReloadingState(
          logoPressSubscription: logoPressStream.listen(
            (press) {
              if (press == PressType.down) {
                add(const _PressDownEvent());
              } else {
                add(const _ReleaseEvent());
              }
            },
          ),
          userExploreResponse: event.initialData,
          explore: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.user.exploreUsers(
                accessToken: accessToken,
                gymId: gymId,
              ),
            ),
          )..then(
              (either) => either.fold(
                (response) => add(_LoadedEvent(response)),
                (failure) => add(_LoadingErrorEvent(failure)),
              ),
            ),
        ),
      );
}
