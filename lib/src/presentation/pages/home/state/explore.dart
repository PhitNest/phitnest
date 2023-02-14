part of home_page;

enum PressType { up, down }

class _ExploreState extends _HomeState {
  final StreamController<PressType> logoPress;

  const _ExploreState({
    required super.user,
    required super.gym,
    required super.accessToken,
    required super.refreshToken,
    required super.password,
    required super.userExploreResponse,
    required this.logoPress,
  }) : super(
          currentPage: NavbarPage.explore,
        );

  @override
  List<Object> get props => [...super.props, logoPress];
}
