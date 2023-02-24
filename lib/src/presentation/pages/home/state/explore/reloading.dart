part of home_page;

class _ExploreReloadingState extends _IExploreReloadingState {
  @override
  _ExploreReloadingState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreReloadingState(
        explore: explore,
        currentPageIndex: pageIndex,
      );

  const _ExploreReloadingState({
    required super.explore,
    required super.currentPageIndex,
  }) : super();
}
