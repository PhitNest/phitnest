part of explore_page;

class _ReloadingState extends _Loaded {
  final CancelableOperation<Either<UserExploreResponse, Failure>> explore;

  const _ReloadingState({
    required super.logoPressSubscription,
    required super.userExploreResponse,
    required this.explore,
  }) : super();

  @override
  List<Object> get props => [super.props, explore.value];
}
