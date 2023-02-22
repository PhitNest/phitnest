part of home_page;

extension _ExploreOnLoadingError on _ExploreBloc {
  void onLoadingError(
      _ExploreLoadingErrorEvent event, Emitter<_IExploreState> emit) {
    StyledErrorBanner.show(event.failure);
    if (state is _ExploreHoldingReloadingState) {
      final state = this.state as _ExploreHoldingReloadingState;
      emit(
        _ExploreHoldingReloadingState(
          explore: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.user.exploreUsers(
                accessToken: accessToken,
                gymId: Cache.gym.gym!.id,
              ),
            ),
          )..then(
              (either) => add(
                either.fold(
                  (response) => _ExploreLoadedEvent(response),
                  (failure) => _ExploreLoadingErrorEvent(failure),
                ),
              ),
            ),
          userExploreResponse: state.userExploreResponse,
          countdown: state.countdown,
          incrementCountdown: state.incrementCountdown,
        ),
      );
    } else if (state is _ExploreReloadingState) {
      final state = this.state as _ExploreReloadingState;
      emit(
        _ExploreReloadingState(
          explore: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.user.exploreUsers(
                accessToken: accessToken,
                gymId: Cache.gym.gym!.id,
              ),
            ),
          )..then(
              (either) => add(
                either.fold(
                  (response) => _ExploreLoadedEvent(response),
                  (failure) => _ExploreLoadingErrorEvent(failure),
                ),
              ),
            ),
          userExploreResponse: state.userExploreResponse,
        ),
      );
    } else {
      emit(
        _ExploreLoadingState(
          explore: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.user.exploreUsers(
                accessToken: accessToken,
                gymId: Cache.gym.gym!.id,
              ),
            ),
          )..then(
              (either) => add(
                either.fold(
                  (response) => _ExploreLoadedEvent(response),
                  (failure) => _ExploreLoadingErrorEvent(failure),
                ),
              ),
            ),
        ),
      );
    }
  }
}
