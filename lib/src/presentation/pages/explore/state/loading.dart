part of explore_page;

class _LoadingState extends _IExploreState {
  final CancelableOperation<Either<UserExploreResponse, Failure>> explore;

  const _LoadingState({
    required this.explore,
  }) : super();

  @override
  List<Object> get props => [explore.value];
}
