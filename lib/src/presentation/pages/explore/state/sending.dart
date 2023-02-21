part of explore_page;

class _SendingFriendRequestState extends _Loaded {
  final CancelableOperation<
      Either3<FriendRequestEntity, FriendshipEntity, Failure>> sendRequest;

  const _SendingFriendRequestState({
    required super.logoPressSubscription,
    required super.userExploreResponse,
    required this.sendRequest,
  }) : super();

  @override
  List<Object> get props => [super.props, sendRequest.value];
}
