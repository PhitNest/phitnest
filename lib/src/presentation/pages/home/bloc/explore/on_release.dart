part of home_page;

extension _ExploreOnRelease on _ExploreBloc {
  void onRelease(_ExploreReleaseEvent event, Emitter<_IExploreState> emit) {
    if (state is _ExploreHoldingState) {
      final state = this.state as _ExploreHoldingState;
      state.incrementCountdown.cancel();
      emit(
        _ExploreLoadedState(
          userExploreResponse: state.userExploreResponse,
        ),
      );
    } else if (state is _ExploreHoldingReloadingState) {
      final state = this.state as _ExploreHoldingReloadingState;
      state.incrementCountdown.cancel();
      emit(
        _ExploreReloadingState(
          userExploreResponse: state.userExploreResponse,
          explore: state.explore,
        ),
      );
    }
  }
}
