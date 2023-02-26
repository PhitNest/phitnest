part of home_page;

class _ExploreMatchedState extends _IExploreLoadedState
    with _IExploreMatchedState {
  final PopulatedFriendshipEntity friendship;

  const _ExploreMatchedState({
    required this.friendship,
  }) : super();
}
