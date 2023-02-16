part of explore_page;

extension _OnPressDown on _ExploreBloc {
  void onPressDown(_PressDownEvent event, Emitter<_IExploreState> emit) => emit(
        _HoldingState(
          userExploreResponse: (state as _Loaded).userExploreResponse,
          logoPressSubscription: (state as _Loaded).logoPressSubscription,
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
