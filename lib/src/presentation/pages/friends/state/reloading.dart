part of friends_page;

class _ReloadingState extends _ILoadedState with _ILoadingState {
  final CancelableOperation<Either<FriendsAndRequestsResponse, Failure>>
      friendsAndRequests;

  const _ReloadingState({
    required super.searchController,
    required this.friendsAndRequests,
  }) : super();
}
