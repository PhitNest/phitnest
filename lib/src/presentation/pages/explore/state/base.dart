part of explore_page;

abstract class _ExploreState extends Equatable {
  const _ExploreState() : super();

  @override
  List<Object> get props => [];
}

abstract class _Loaded extends _ExploreState {
  final StreamSubscription<void> logoPressSubscription;
  final UserExploreResponse userExploreResponse;

  const _Loaded({
    required this.logoPressSubscription,
    required this.userExploreResponse,
  }) : super();

  @override
  List<Object> get props => [logoPressSubscription, userExploreResponse];
}
