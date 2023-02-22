part of home_page;

extension _ExploreOnIncrementCountdown on _ExploreBloc {
  void onIncrementCountdown(
      _ExploreIncrementCountdownEvent event, Emitter<_IExploreState> emit) {
    if (state is _ExploreHoldingState) {
      final state = this.state as _ExploreHoldingState;
      emit(
        state.countdown > 1
            ? _ExploreHoldingState(
                userExploreResponse: state.userExploreResponse,
                countdown: state.countdown - 1,
                incrementCountdown: CancelableOperation.fromFuture(
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {},
                  ),
                )..then(
                    (_) => add(const _ExploreIncrementCountdownEvent()),
                  ),
              )
            : _ExploreLoadedState(
                userExploreResponse: state.userExploreResponse),
      );
    } else if (state is _ExploreHoldingReloadingState) {
      final state = this.state as _ExploreHoldingReloadingState;
      emit(
        state.countdown > 1
            ? _ExploreHoldingReloadingState(
                userExploreResponse: state.userExploreResponse,
                countdown: state.countdown - 1,
                explore: state.explore,
                incrementCountdown: CancelableOperation.fromFuture(
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {},
                  ),
                )..then(
                    (_) => add(const _ExploreIncrementCountdownEvent()),
                  ),
              )
            : _ExploreReloadingState(
                explore: state.explore,
                userExploreResponse: state.userExploreResponse,
              ),
      );
    }
  }
}
