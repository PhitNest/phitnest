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
  final List<ProfilePicturePublicUserEntity> userExploreResponse;

  const _IExploreLoadedState({
    required this.userExploreResponse,
  }) : super();

  @override
  List<Object> get props => [userExploreResponse];
}

mixin _IExploreHoldingState on _IExploreLoadedState {
  int get countdown;
  CancelableOperation<void> get incrementCountdown;
}

abstract class _IExploreReloadingState extends _IExploreLoadedState
    with _IExploreLoadingState {
  final CancelableOperation<
      Either<List<ProfilePicturePublicUserEntity>, Failure>> explore;

  const _IExploreReloadingState({
    required super.userExploreResponse,
    required this.explore,
  }) : super();

  @override
  List<Object> get props => [super.props, explore.value];
}
