part of backend;

class LoginResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final ProfilePictureUserEntity user;
  final GymEntity gym;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.gym,
  }) : super();

  @override
  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        user: ProfilePictureUserEntity.fromJson(json['user']),
        gym: GymEntity.fromJson(json['gym']),
      );

  @override
  List<Object> get props => [accessToken, refreshToken, user, gym];
}

extension Login on _Auth {
  Future<Either<LoginResponse, Failure>> login({
    required String email,
    required String password,
  }) =>
      _requestJson(
        route: "/auth/login",
        method: HttpMethod.post,
        parser: LoginResponse.fromJson,
        data: {
          "email": email,
          "password": password,
        },
      );
}
