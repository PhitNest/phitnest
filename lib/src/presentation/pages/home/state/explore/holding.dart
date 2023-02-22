part of home_page;

class _ExploreHoldingState extends _IExploreLoadedState
    with _IExploreHoldingState {
  final int countdown;
  final CancelableOperation<void> incrementCountdown;

  const _ExploreHoldingState({
    required super.userExploreResponse,
    required this.countdown,
    required this.incrementCountdown,
  }) : super();

  @override
  List<Object> get props => [super.props, countdown, incrementCountdown.value];
}

class _ExploreHoldingReloadingState extends _IExploreReloadingState
    with _IExploreHoldingState {
  final int countdown;
  final CancelableOperation<void> incrementCountdown;

  const _ExploreHoldingReloadingState({
    required super.userExploreResponse,
    required super.explore,
    required this.countdown,
    required this.incrementCountdown,
  }) : super();

  @override
  List<Object> get props => [super.props, countdown, incrementCountdown.value];
}
