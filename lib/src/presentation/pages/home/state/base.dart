part of home_page;

abstract class _HomeState extends Equatable {
  final ProfilePictureUserEntity user;
  final GymEntity gym;
  final String accessToken;
  final String refreshToken;
  final String password;
  final NavbarPage currentPage;

  const _HomeState({
    required this.user,
    required this.gym,
    required this.accessToken,
    required this.refreshToken,
    required this.password,
    required this.currentPage,
  }) : super();

  @override
  List<Object> get props => [
        user,
        gym,
        accessToken,
        refreshToken,
        password,
        currentPage,
      ];
}
