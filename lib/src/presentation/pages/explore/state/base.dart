part of explore_page;

abstract class _IExploreState extends Equatable {
  const _IExploreState() : super();

  @override
  List<Object> get props => [];
}

abstract class _Loaded extends _IExploreState {
  final StreamSubscription<void> logoPressSubscription;
  final List<ProfilePicturePublicUserEntity> userExploreResponse;

  const _Loaded({
    required this.logoPressSubscription,
    required this.userExploreResponse,
  }) : super();

  @override
  List<Object> get props => [logoPressSubscription, userExploreResponse];
}
