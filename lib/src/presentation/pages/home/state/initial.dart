part of home_page;

class _InitialState extends _IHomeState {
  final CancelableOperation<Either<SocketConnection, Failure>> socketConnection;

  _IHomeState copyWithDarkMode(bool darkMode) => _InitialState(
        currentPage: currentPage,
        logoPress: logoPress,
        logoPressBroadcast: logoPressBroadcast,
        darkMode: darkMode,
        socketConnection: socketConnection,
      );

  _InitialState({
    required super.currentPage,
    required super.logoPress,
    required super.logoPressBroadcast,
    required super.darkMode,
    required this.socketConnection,
  }) : super();

  @override
  List<Object> get props => [super.props, socketConnection.value];
}
