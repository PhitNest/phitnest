part of home_page;

class _ExploreMatchedReloadingState extends _IExploreReloadingState
    with _IExploreMatchedState {
  final PopulatedFriendshipEntity friendship;

  const _ExploreMatchedReloadingState({
    required super.explore,
    required this.friendship,
  }) : super();
}
