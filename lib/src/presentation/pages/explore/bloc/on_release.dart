part of explore_page;

extension _OnRelease on _ExploreBloc {
  void onRelease(_ReleaseEvent event, Emitter<_IExploreState> emit) {
    if (state is _HoldingState) {
      final state = this.state as _HoldingState;
      emit(
        _LoadedState(
          logoPressSubscription: state.logoPressSubscription,
          userExploreResponse: state.userExploreResponse,
        ),
      );
    }
  }
}
