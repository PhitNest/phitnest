part of friends_page;

class _LoadingState extends _IFriendsState with _ILoadingState {
  final CancelableOperation<Either<FriendsAndRequestsResponse, Failure>>
      friendsAndRequests;

  const _LoadingState({
    required this.friendsAndRequests,
  }) : super();
}
