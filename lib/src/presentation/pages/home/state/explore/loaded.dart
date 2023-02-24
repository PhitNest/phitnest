part of home_page;

class _ExploreLoadedState extends _IExploreLoadedState {
  @override
  _ExploreLoadedState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreLoadedState(
        currentPageIndex: pageIndex,
      );

  const _ExploreLoadedState({
    required super.currentPageIndex,
  }) : super();
}
