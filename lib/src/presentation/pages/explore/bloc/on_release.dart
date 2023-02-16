part of explore_page;

extension _OnRelease on _ExploreBloc {
  void onRelease(_ReleaseEvent event, Emitter<_IExploreState> emit) =>
      emit(const _InitialState());
}
