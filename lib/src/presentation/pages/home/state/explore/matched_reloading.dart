part of home_page;

class _ExploreMatchedReloadingState extends _IExploreReloadingState
    with _IExploreMatchedState {
  final FriendshipEntity friendship;

  @override
  _ExploreMatchedReloadingState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreMatchedReloadingState(
        currentPageIndex: pageIndex,
        friendship: friendship,
        explore: explore,
      );

  const _ExploreMatchedReloadingState({
    required super.currentPageIndex,
    required super.explore,
    required this.friendship,
  }) : super();

  @override
  List<Object> get props => [super.props, friendship];
}
