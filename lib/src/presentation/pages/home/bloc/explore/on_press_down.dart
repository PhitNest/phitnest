part of home_page;

extension _ExploreOnPressDown on _ExploreBloc {
  void onPressDown(_ExplorePressDownEvent event, Emitter<_IExploreState> emit) {
    if (state is _IExploreLoadedState) {
      final incrementCountDown = CancelableOperation.fromFuture(
        Future.delayed(
          const Duration(seconds: 1),
          () {},
        ),
      )..then((_) => add(const _ExploreIncrementCountdownEvent()));
      if (state is _ExploreLoadedState) {
        final state = this.state as _ExploreLoadedState;
        if (Cache.user.userExploreResponse!.isNotEmpty) {
          emit(
            _ExploreHoldingState(
              currentPageIndex: state.currentPageIndex,
              countdown: 3,
              incrementCountdown: incrementCountDown,
            ),
          );
        }
      } else if (state is _ExploreReloadingState) {
        final state = this.state as _ExploreReloadingState;
        if (Cache.user.userExploreResponse!.isNotEmpty) {
          emit(
            _ExploreHoldingReloadingState(
              currentPageIndex: state.currentPageIndex,
              countdown: 3,
              incrementCountdown: incrementCountDown,
              explore: state.explore,
            ),
          );
        }
      }
    }
  }
}
