part of explore_page;

class _HoldingState extends _Loaded {
  final int countdown;
  final CancelableOperation<void> incrementCountdown;

  const _HoldingState({
    required super.logoPressSubscription,
    required super.userExploreResponse,
    required this.countdown,
    required this.incrementCountdown,
  }) : super();

  @override
  List<Object> get props => [countdown, incrementCountdown.value];
}
