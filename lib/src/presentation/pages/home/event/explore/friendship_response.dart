part of home_page;

class _ExploreFriendshipResponseEvent extends _IExploreEvent {
  final PopulatedFriendshipEntity friendship;

  const _ExploreFriendshipResponseEvent(this.friendship) : super();
}
