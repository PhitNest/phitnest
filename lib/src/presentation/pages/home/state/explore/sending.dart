part of home_page;

class _ExploreSendingFriendRequestState extends _IExploreLoadedState {
  final CancelableOperation<
      Either3<FriendRequestEntity, FriendshipEntity, Failure>> sendRequest;

  const _ExploreSendingFriendRequestState({
    required super.userExploreResponse,
    required this.sendRequest,
  }) : super();

  @override
  List<Object> get props => [super.props, sendRequest.value];
}

class _ExploreSendingFriendRequestReloadingState
    extends _IExploreReloadingState {
  final CancelableOperation<
      Either3<FriendRequestEntity, FriendshipEntity, Failure>> sendRequest;

  const _ExploreSendingFriendRequestReloadingState({
    required super.userExploreResponse,
    required super.explore,
    required this.sendRequest,
  }) : super();

  @override
  List<Object> get props => [super.props, sendRequest.value];
}
