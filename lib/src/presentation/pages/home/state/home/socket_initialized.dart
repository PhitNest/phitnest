part of home_page;

class _HomeSocketInitializedState extends _IHomeSocketConnectedState {
  final StreamSubscription<void> onDataUpdated;

  _HomeSocketInitializedState({
    required super.currentPage,
    required super.connection,
    required super.onDisconnect,
    required this.onDataUpdated,
  }) : super();
}
