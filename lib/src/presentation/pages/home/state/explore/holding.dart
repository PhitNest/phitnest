part of home_page;

class _ExploreHoldingState extends _IExploreLoadedState
    with _IExploreHoldingState {
  final int countdown;
  final CancelableOperation<void> incrementCountdown;

  @override
  _ExploreHoldingState copyWithPageIndex(int pageIndex) => _ExploreHoldingState(
        currentPageIndex: pageIndex,
        countdown: countdown,
        incrementCountdown: incrementCountdown,
      );

  const _ExploreHoldingState({
    required super.currentPageIndex,
    required this.countdown,
    required this.incrementCountdown,
  }) : super();
}

class _ExploreHoldingReloadingState extends _IExploreReloadingState
    with _IExploreHoldingState {
  final int countdown;
  final CancelableOperation<void> incrementCountdown;

  @override
  _ExploreHoldingReloadingState copyWithPageIndex(int pageIndex) =>
      _ExploreHoldingReloadingState(
        explore: explore,
        currentPageIndex: pageIndex,
        countdown: countdown,
        incrementCountdown: incrementCountdown,
      );

  const _ExploreHoldingReloadingState({
    required super.explore,
    required super.currentPageIndex,
    required this.countdown,
    required this.incrementCountdown,
  }) : super();
}
