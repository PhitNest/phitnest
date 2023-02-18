part of home_page;

class _InitialState extends _IHomeState {
  final CancelableOperation<Either<SocketConnection, Failure>> socketConnection;

  const _InitialState({
    required super.currentPage,
    required super.logoPress,
    required this.socketConnection,
  }) : super();

  @override
  List<Object> get props => [super.props, socketConnection.value];
}
