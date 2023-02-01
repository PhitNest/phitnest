part of backend;

class LoginResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String idToken;
  final UserEntity user;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
    required this.user,
  }) : super();

  @override
  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        idToken: json['idToken'],
        user: UserEntity.fromJson(json['user']),
      );

  @override
  List<Object?> get props => [accessToken, refreshToken, idToken, user];
}

Future<Either<LoginResponse, Failure>> _login({
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
