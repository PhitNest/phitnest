part of home_page;

extension _ExploreOnPressDown on _ExploreBloc {
  void onPressDown(_ExplorePressDownEvent event, Emitter<_IExploreState> emit) {
    if (state is _ExploreLoadedState) {
      final state = this.state as _ExploreLoadedState;
      if (state.userExploreResponse.isNotEmpty) {
        emit(
          _ExploreHoldingState(
            userExploreResponse: state.userExploreResponse,
            countdown: 3,
            incrementCountdown: CancelableOperation.fromFuture(
              Future.delayed(
                const Duration(seconds: 1),
                () {},
              ),
            )..then((_) => add(const _ExploreIncrementCountdownEvent())),
          ),
        );
      }
    } else if (state is _ExploreReloadingState) {
      final state = this.state as _ExploreReloadingState;
      if (state.userExploreResponse.isNotEmpty) {
        emit(
          _ExploreHoldingReloadingState(
            userExploreResponse: state.userExploreResponse,
            countdown: 3,
            incrementCountdown: CancelableOperation.fromFuture(
              Future.delayed(
                const Duration(seconds: 1),
                () {},
              ),
            )..then((_) => add(const _ExploreIncrementCountdownEvent())),
            explore: state.explore,
          ),
        );
      }
    }
  }
}
