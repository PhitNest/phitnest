part of home_page;

class _HomeSocketInitializingState extends _IHomeSocketConnectedState {
  final CancelableOperation<Either<Stream<void>, Failure>> initializingStream;

  _HomeSocketInitializingState({
    required super.currentPage,
    required super.connection,
    required super.onDisconnect,
    required this.initializingStream,
  }) : super();
}
