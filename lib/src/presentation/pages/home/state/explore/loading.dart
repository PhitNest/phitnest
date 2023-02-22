part of home_page;

class _ExploreLoadingState extends _IExploreState with _IExploreLoadingState {
  final CancelableOperation<
      Either<List<ProfilePicturePublicUserEntity>, Failure>> explore;

  const _ExploreLoadingState({
    required this.explore,
  }) : super();

  @override
  List<Object> get props => [explore.value];
}
