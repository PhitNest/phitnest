part of backend;

extension Explore on User {
  Future<Either<List<ProfilePicturePublicUserEntity>, Failure>> explore({
    required String accessToken,
    required String gymId,
  }) =>
      _requestList(
        route: "/user/explore",
        method: HttpMethod.get,
        parser: ProfilePicturePublicUserEntity.fromJson,
        authorization: accessToken,
        data: {
          "gymId": gymId,
        },
      );
}
