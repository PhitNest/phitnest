part of explore_page;

extension _OnLoadingError on _ExploreBloc {
  void onLoadingError(_LoadingErrorEvent event, Emitter<_IExploreState> emit) {
    if (state is _ReloadingState) {
      final state = this.state as _ReloadingState;
      emit(
        _ReloadingState(
          logoPressSubscription: state.logoPressSubscription,
          explore: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.user.exploreUsers(
                accessToken: accessToken,
                gymId: Cache.gym!.id,
              ),
            ),
          )..then(
              (either) => add(
                either.fold(
                  (response) => _LoadedEvent(response),
                  (failure) => _LoadingErrorEvent(failure),
                ),
              ),
            ),
          userExploreResponse: state.userExploreResponse,
        ),
      );
    } else {
      StyledErrorBanner.show(event.failure);
      emit(_LoadingState(
        explore: CancelableOperation.fromFuture(
          withAuth(
            (accessToken) => Repositories.user.exploreUsers(
              accessToken: accessToken,
              gymId: Cache.gym!.id,
            ),
          ),
        )..then(
            (either) => add(
              either.fold(
                (response) => _LoadedEvent(response),
                (failure) => _LoadingErrorEvent(failure),
              ),
            ),
          ),
      ));
    }
  }
}
