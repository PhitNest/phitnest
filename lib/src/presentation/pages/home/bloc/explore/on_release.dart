part of home_page;

extension _ExploreOnRelease on _ExploreBloc {
  void onRelease(_ExploreReleaseEvent event, Emitter<_IExploreState> emit) {
    if (state is _ExploreHoldingState) {
      final state = this.state as _ExploreHoldingState;
      state.incrementCountdown.cancel();
      emit(const _ExploreLoadedState());
    } else if (state is _ExploreHoldingReloadingState) {
      final state = this.state as _ExploreHoldingReloadingState;
      state.incrementCountdown.cancel();
      emit(_ExploreReloadingState(explore: state.explore));
    }
  }
}
