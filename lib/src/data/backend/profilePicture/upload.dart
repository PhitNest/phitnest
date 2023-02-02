part of backend;

class GetUploadUrlResponse extends Equatable {
  final String url;

  const GetUploadUrlResponse({
    required this.url,
  }) : super();

  factory GetUploadUrlResponse.fromJson(Map<String, dynamic> json) =>
      GetUploadUrlResponse(
        url: json['url'],
      );

  @override
  List<Object> get props => [url];
}

Future<Either<GetUploadUrlResponse, Failure>> _getUploadUrl({
  required String accessToken,
}) =>
    _requestJson(
      route: "/profilePicture/upload",
      method: HttpMethod.get,
      parser: GetUploadUrlResponse.fromJson,
      authorization: accessToken,
      data: {},
    );
