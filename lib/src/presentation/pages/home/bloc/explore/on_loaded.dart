part of home_page;

extension _ExploreOnLoaded on _ExploreBloc {
  void onLoaded(_ExploreLoadedEvent event, Emitter<_IExploreState> emit) {
    if (state is _ExploreHoldingState) {
      final state = this.state as _ExploreHoldingState;
      emit(
        _ExploreHoldingState(
          userExploreResponse: event.response,
          countdown: state.countdown,
          incrementCountdown: state.incrementCountdown,
        ),
      );
    } else {
      emit(
        _ExploreLoadedState(
          userExploreResponse: event.response,
        ),
      );
    }
  }
}
