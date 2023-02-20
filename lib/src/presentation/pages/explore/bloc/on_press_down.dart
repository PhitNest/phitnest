part of explore_page;

extension _OnPressDown on _ExploreBloc {
  void onPressDown(_PressDownEvent event, Emitter<_IExploreState> emit) {
    final state = this.state as _Loaded;
    if (state.userExploreResponse.users.isNotEmpty) {
      emit(
        _HoldingState(
          userExploreResponse: state.userExploreResponse,
          logoPressSubscription: state.logoPressSubscription,
          countdown: 3,
          incrementCountdown: CancelableOperation.fromFuture(
            Future.delayed(
              const Duration(seconds: 1),
              () => add(const _IncrementCountdownEvent()),
            ),
          ),
        ),
      );
    }
  }
}
