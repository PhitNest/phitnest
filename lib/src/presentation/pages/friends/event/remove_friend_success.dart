part of friends_page;

class _RemoveFriendSuccessEvent extends _IFriendsEvent {
  final PublicUserEntity friend;

  const _RemoveFriendSuccessEvent(this.friend) : super();
}
