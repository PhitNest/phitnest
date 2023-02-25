part of friends_page;

class _AddFriendEvent extends _IFriendsEvent {
  final PublicUserEntity friend;

  const _AddFriendEvent(this.friend) : super();
}
