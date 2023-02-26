part of home_page;

class _ExploreHoldingState extends _IExploreLoadedState
    with _IExploreHoldingState {
  final int countdown;
  final CancelableOperation<void> incrementCountdown;

  const _ExploreHoldingState({
    required this.countdown,
    required this.incrementCountdown,
  }) : super();
}

class _ExploreHoldingReloadingState extends _IExploreReloadingState
    with _IExploreHoldingState {
  final int countdown;
  final CancelableOperation<void> incrementCountdown;

  const _ExploreHoldingReloadingState({
    required super.explore,
    required this.countdown,
    required this.incrementCountdown,
  }) : super();
}
