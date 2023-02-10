part of home_page;

abstract class _HomeState extends Equatable {
  final ProfilePictureUserEntity user;
  final GymEntity gym;
  final String accessToken;
  final String refreshToken;
  final String password;

  const _HomeState({
    required this.user,
    required this.gym,
    required this.accessToken,
    required this.refreshToken,
    required this.password,
  }) : super();

  @override
  List<Object> get props => [user, gym, accessToken, refreshToken, password];
}
