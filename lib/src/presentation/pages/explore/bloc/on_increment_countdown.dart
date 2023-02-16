part of explore_page;

extension _OnIncrementCountdown on _ExploreBloc {
  void onIncrementCountdown(
      _IncrementCountdownEvent event, Emitter<_IExploreState> emit) {
    if (state is _HoldingState) {
      final state = this.state as _HoldingState;
      emit(
        state.countdown > 1
            ? _HoldingState(
                userExploreResponse: state.userExploreResponse,
                logoPressSubscription: state.logoPressSubscription,
                countdown: state.countdown - 1,
                incrementCountdown: CancelableOperation.fromFuture(
                  Future.delayed(
                    const Duration(seconds: 1),
                    () => add(const _IncrementCountdownEvent()),
                  ),
                ),
              )
            : _MatchedState(
                userExploreResponse: state.userExploreResponse,
                logoPressSubscription: state.logoPressSubscription,
              ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}
