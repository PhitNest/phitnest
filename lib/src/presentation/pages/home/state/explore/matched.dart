part of home_page;

class _ExploreMatchedState extends _IExploreLoadedState
    with _IExploreMatchedState {
  final PopulatedFriendshipEntity friendship;

  @override
  _ExploreMatchedState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreMatchedState(
        currentPageIndex: pageIndex,
        friendship: friendship,
      );

  const _ExploreMatchedState({
    required super.currentPageIndex,
    required this.friendship,
  }) : super();
}
