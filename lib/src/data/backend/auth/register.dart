part of backend;

class RegisterResponse extends Equatable {
  final String uploadUrl;
  final UserEntity user;

  const RegisterResponse({
    required this.user,
    required this.uploadUrl,
  }) : super();

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        user: UserEntity.fromJson(json['user']),
        uploadUrl: json['uploadUrl'],
      );

  @override
  List<Object> get props => [user, uploadUrl];
}

extension Register on Auth {
  Future<Either<RegisterResponse, Failure>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gymId,
  }) =>
      _requestJson(
        route: "/auth/register",
        method: HttpMethod.post,
        parser: RegisterResponse.fromJson,
        data: {
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "gymId": gymId,
        },
      );
}
