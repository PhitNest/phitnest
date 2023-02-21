part of explore_page;

extension _OnPressDown on _ExploreBloc {
  void onPressDown(_PressDownEvent event, Emitter<_IExploreState> emit) {
    if (state is _LoadedState) {
      final state = this.state as _LoadedState;
      if (state.userExploreResponse.isNotEmpty) {
        emit(
          _HoldingState(
            userExploreResponse: state.userExploreResponse,
            logoPressSubscription: state.logoPressSubscription,
            countdown: 3,
            incrementCountdown: CancelableOperation.fromFuture(
              Future.delayed(
                const Duration(seconds: 1),
                () {},
              ),
            )..then((_) => add(const _IncrementCountdownEvent())),
          ),
        );
      }
    }
  }
}
