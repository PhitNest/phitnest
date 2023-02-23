part of home_page;

class _ExploreLoadedState extends _IExploreLoadedState {
  @override
  _ExploreLoadedState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreLoadedState(
        userExploreResponse: userExploreResponse,
        currentPageIndex: pageIndex,
      );

  const _ExploreLoadedState({
    required super.userExploreResponse,
    required super.currentPageIndex,
  }) : super();
}
