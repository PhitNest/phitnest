part of explore_page;

class _LoadingState extends _IExploreState {
  final CancelableOperation<
      Either<List<ProfilePicturePublicUserEntity>, Failure>> explore;

  const _LoadingState({
    required this.explore,
  }) : super();

  @override
  List<Object> get props => [explore.value];
}
