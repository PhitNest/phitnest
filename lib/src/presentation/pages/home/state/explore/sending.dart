part of home_page;

class _ExploreSendingFriendRequestState extends _IExploreLoadedState
    with _IExploreSendingFriendRequestState {
  final CancelableOperation<
      Either3<FriendRequestEntity, FriendshipEntity, Failure>> sendRequest;

  @override
  _ExploreSendingFriendRequestState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreSendingFriendRequestState(
        currentPageIndex: pageIndex,
        sendRequest: sendRequest,
      );

  const _ExploreSendingFriendRequestState({
    required super.currentPageIndex,
    required this.sendRequest,
  }) : super();

  @override
  List<Object> get props => [super.props, sendRequest.value];
}

class _ExploreSendingFriendRequestReloadingState extends _IExploreReloadingState
    with _IExploreSendingFriendRequestState {
  final CancelableOperation<
      Either3<FriendRequestEntity, FriendshipEntity, Failure>> sendRequest;

  @override
  _ExploreSendingFriendRequestReloadingState copyWithPageIndex(
    int pageIndex,
  ) =>
      _ExploreSendingFriendRequestReloadingState(
        explore: explore,
        currentPageIndex: pageIndex,
        sendRequest: sendRequest,
      );

  const _ExploreSendingFriendRequestReloadingState({
    required super.explore,
    required super.currentPageIndex,
    required this.sendRequest,
  }) : super();

  @override
  List<Object> get props => [super.props, sendRequest.value];
}
