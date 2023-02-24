part of home_page;

class _ExploreMatchedState extends _IExploreLoadedState
    with _IExploreMatchedState {
  final FriendshipEntity friendship;

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

  @override
  List<Object> get props => [super.props, friendship];
}
