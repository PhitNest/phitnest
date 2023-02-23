part of home_page;

class _ExploreReloadingState extends _IExploreReloadingState {
  @override
  _ExploreReloadingState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreReloadingState(
        userExploreResponse: userExploreResponse,
        explore: explore,
        currentPageIndex: pageIndex,
      );

  const _ExploreReloadingState({
    required super.userExploreResponse,
    required super.explore,
    required super.currentPageIndex,
  }) : super();
}
