part of explore_page;

class _LoadingErrorState extends _IExploreState {
  final Failure failure;

  const _LoadingErrorState({
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [failure];
}
