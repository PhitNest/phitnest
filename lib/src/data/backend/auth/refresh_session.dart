part of backend;

class RefreshSessionResponse extends Equatable {
  final String accessToken;
  final String idToken;

  const RefreshSessionResponse({
    required this.accessToken,
    required this.idToken,
  }) : super();

  @override
  factory RefreshSessionResponse.fromJson(Map<String, dynamic> json) =>
      RefreshSessionResponse(
        accessToken: json['accessToken'],
        idToken: json['idToken'],
      );

  @override
  List<Object> get props => [accessToken, idToken];
}

extension RefreshSession on _Auth {
  Future<Either<RefreshSessionResponse, Failure>> refreshSession({
    required String email,
    required String refreshToken,
  }) =>
      _requestJson(
        route: "/auth/refreshSession",
        method: HttpMethod.post,
        parser: RefreshSessionResponse.fromJson,
        data: {
          "email": email,
          "refreshToken": refreshToken,
        },
      );
}
