part of home_page;

class _ExploreFriendshipResponseEvent extends _IExploreEvent {
  final FriendshipEntity friendship;

  const _ExploreFriendshipResponseEvent(this.friendship) : super();
}
