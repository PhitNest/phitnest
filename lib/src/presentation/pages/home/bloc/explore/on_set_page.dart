part of home_page;

extension _ExploreOnSetPage on _ExploreBloc {
  void onSetPage(_ExploreSetPageEvent event, Emitter<_IExploreState> emit) =>
      emit((state as _IExploreLoadedState).copyWithPageIndex(event.pageIndex));
}
