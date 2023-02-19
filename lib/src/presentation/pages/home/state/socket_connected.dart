part of home_page;

class _SocketConnectedState extends _IHomeState {
  final SocketConnection connection;

  const _SocketConnectedState({
    required super.currentPage,
    required super.logoPress,
    required this.connection,
  }) : super();

  @override
  List<Object> get props => [super.props, connection];
}
