part of friends_page;

class _AddFriendSuccessEvent extends _IFriendsEvent {
  final PublicUserEntity friend;

  const _AddFriendSuccessEvent(this.friend) : super();
}
