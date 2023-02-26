part of backend;

class GetUnauthorizedUploadUrlResponse {
  final String url;

  const GetUnauthorizedUploadUrlResponse({
    required this.url,
  }) : super();

  factory GetUnauthorizedUploadUrlResponse.fromJson(
          Map<String, dynamic> json) =>
      GetUnauthorizedUploadUrlResponse(
        url: json['url'],
      );
}

extension GetUnauthorized on ProfilePicture {
  Future<Either<GetUnauthorizedUploadUrlResponse, Failure>>
      getUnauthorizedUploadUrl(String email) => _requestJson(
            route: "/profilePicture/unauthorized",
            method: HttpMethod.get,
            parser: GetUnauthorizedUploadUrlResponse.fromJson,
            data: {
              'email': email,
            },
          );
}
