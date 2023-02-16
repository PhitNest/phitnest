part of home_page;

enum PressType { up, down }

class _IExploreState extends _ISocketConnectedState {
  final StreamController<PressType> logoPress;

  const _IExploreState({
    required super.user,
    required super.gym,
    required super.accessToken,
    required super.refreshToken,
    required super.password,
    required super.userExploreResponse,
    required super.socketConnection,
    required this.logoPress,
  }) : super(
          currentPage: NavbarPage.explore,
        );

  @override
  List<Object> get props => [...super.props, logoPress];
}
