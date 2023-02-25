part of friends_page;

class _DenyRequestErrorEvent extends _IFriendsEvent {
  final PublicUserEntity friend;
  final Failure failure;

  const _DenyRequestErrorEvent({
    required this.friend,
    required this.failure,
  }) : super();
}
