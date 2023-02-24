part of home_page;

abstract class _IExploreState extends Equatable {
  const _IExploreState() : super();

  @override
  List<Object> get props => [];
}

mixin _IExploreLoadingState on _IExploreState {
  CancelableOperation<Either<List<ProfilePicturePublicUserEntity>, Failure>>
      get explore;
}

abstract class _IExploreLoadedState extends _IExploreState {
  final int currentPageIndex;

  _IExploreLoadedState copyWithPageIndex(int pageIndex);

  const _IExploreLoadedState({
    required this.currentPageIndex,
  }) : super();

  @override
  List<Object> get props =>
      [Cache.user.userExploreResponse ?? "", currentPageIndex];
}

mixin _IExploreHoldingState on _IExploreLoadedState {
  int get countdown;
  CancelableOperation<void> get incrementCountdown;
}

mixin _IExploreSendingFriendRequestState on _IExploreLoadedState {
  CancelableOperation<Either3<FriendRequestEntity, FriendshipEntity, Failure>>
      get sendRequest;
}

mixin _IExploreMatchedState on _IExploreLoadedState {
  FriendshipEntity get friendship;
}

abstract class _IExploreReloadingState extends _IExploreLoadedState
    with _IExploreLoadingState {
  final CancelableOperation<
      Either<List<ProfilePicturePublicUserEntity>, Failure>> explore;

  _IExploreReloadingState copyWithPageIndex(int pageIndex);

  const _IExploreReloadingState({
    required super.currentPageIndex,
    required this.explore,
  }) : super();

  @override
  List<Object> get props => [super.props, explore.value];
}
