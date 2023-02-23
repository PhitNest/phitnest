part of home_page;

class _ExploreMatchedState extends _IExploreLoadedState {
  @override
  _ExploreMatchedState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreMatchedState(
        userExploreResponse: userExploreResponse,
        currentPageIndex: pageIndex,
      );

  const _ExploreMatchedState({
    required super.userExploreResponse,
    required super.currentPageIndex,
  }) : super();
}
