part of friends_page;

class _LoadingErrorEvent extends _IFriendsEvent {
  final Failure failure;

  const _LoadingErrorEvent(this.failure) : super();
}
