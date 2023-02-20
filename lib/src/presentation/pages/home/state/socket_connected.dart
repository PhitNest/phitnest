part of home_page;

class _SocketConnectedState extends _IHomeState {
  final SocketConnection connection;

  _SocketConnectedState({
    required super.currentPage,
    required super.logoPress,
    required super.logoPressBroadcast,
    required super.darkMode,
    required this.connection,
  }) : super();

  _IHomeState copyWithDarkMode(bool darkMode) => _SocketConnectedState(
        currentPage: currentPage,
        logoPress: logoPress,
        logoPressBroadcast: logoPressBroadcast,
        darkMode: darkMode,
        connection: connection,
      );

  @override
  List<Object> get props => [super.props, connection];
}
