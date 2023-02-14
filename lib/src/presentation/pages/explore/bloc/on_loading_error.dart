part of explore_page;

extension _OnLoadingError on _ExploreBloc {
  void onLoadingError(_LoadingErrorEvent event, Emitter<_ExploreState> emit) {
    if (state is _ReloadingState) {
      final state = this.state as _ReloadingState;
      emit(
        _LoadedState(
          logoPressSubscription: state.logoPressSubscription,
          userExploreResponse: state.userExploreResponse,
        ),
      );
    } else {
      emit(_LoadingErrorState(failure: event.failure));
    }
  }
}
