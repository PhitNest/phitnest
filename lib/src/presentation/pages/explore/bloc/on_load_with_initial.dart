part of explore_page;

extension _OnLoadWithInitial on _ExploreBloc {
  void onLoadWithInitial(
          _LoadWithInitialEvent event, Emitter<_IExploreState> emit) =>
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
                gymId: Cache.gym!.id,
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
