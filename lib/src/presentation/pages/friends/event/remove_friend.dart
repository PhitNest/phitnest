part of friends_page;

class _RemoveFriendEvent extends _IFriendsEvent {
  final PublicUserEntity friend;

  const _RemoveFriendEvent(this.friend) : super();
}
